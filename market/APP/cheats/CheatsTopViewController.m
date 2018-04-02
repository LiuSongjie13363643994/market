//
//  CheatsTopViewController.m
//  market
//
//  Created by Lipeng on 2017/8/18.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "CheatsTopViewController.h"
#import "CheatWebViewController.h"
#import "AuthBaseViewController.h"
#import "AppCreditViewController.h"

#import "CheatTableViewCell.h"

#import "CheatService.h"

@interface CheatsTopViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic) UITableView *tableView;
@property(nonatomic,strong) LPCollection *cheats;
@end

@implementation CheatsTopViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self fetchState];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"秘籍";
    _cheats=[CheatService shared].cheats;
    [self cheatBlocks];
    
    _tableView=LPAddPlainTableView(self.contentView,UITableView,YES,self.contentView.bounds);
    _tableView.delegate=self;
    _tableView.dataSource=self;
//    _tableView.tableHeaderView=self.headerView;
    
}

- (UIView *)headerView
{
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.w,54*2+10)];
    
    __weak typeof(self) wself=self;
    CGFloat w=v.w,h=54;
    UIButton *btn=(UIButton *)v.lp_av(UIButton.class,0,0,w,h);
    [self button:btn image:@"ic-cridit" title:@"信用评级" desc:@"建议每周进行一次信用评级"];
    [btn addActionBlock:^(UIButton *button) {
        [wself checkLogin:^{
            AuthBaseViewController *abvc=[[AuthBaseViewController alloc] init];
            abvc.grade=YES;
            [wself pushViewController:abvc];
        }];
    }];
    
    btn=(UIButton *)v.lp_av(UIButton.class,0,btn.y2,w,h);
    [self button:btn image:@"ic-app" title:@"征信检测" desc:@"查看APP是否查征信上征信"];
    [btn addActionBlock:^(UIButton *button) {
        [wself pushViewController:[[AppCreditViewController alloc] init]];
    }];
//    btn=(UIButton *)v.lp_av(UIButton.class,0,btn.y2,w,h);
//    [self button:btn image:@"ic-progress" title:@"进度查询" desc:@"各贷款平台客服电话集中营"];
    v.lp_av(UIView.class,LP_X_GAP,h,w-LP_X_2GAP,LPWidthOfPx).backgroundColor=kColorf6f6f6;
    v.lp_av(UIView.class,0,h+h,w,LPWidthOfPx).backgroundColor=kColorf6f6f6;
//    v.lp_av(UIView.class,0,0,w,10).lp_iny1(0).backgroundColor=kColorffffff;
    
    return v;
}
- (void)button:(UIButton *)button image:(NSString *)image title:(NSString *)title desc:(NSString *)desc
{
    button.backgroundColor=kColorffffff;
    UIImageView *iv=(UIImageView *)button.lp_av(UIImageView.class,0,0,54,54);
    iv.image=[UIImage imageNamed:image];
    
    UILabel *la=(UILabel *)button.lp_av(UILabel.class,54,0,button.w-54,40).lp_midy();
    la.numberOfLines=0;
    la.attributedText=[NSAttributedString string:@[title,@"\n",desc]
                                          colors:@[kColor23232b,kColor23232b,kColor919191]
                                           fonts:@[LPFont(16),LPFont(4),LPFont(12)]];
    iv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-next"]];
    [button addSubview:iv];
    iv.lp_inx1(LP_X_GAP).lp_midy();
}

- (void)fetchState
{
    if (kLoading_NA==_cheats.state){
        if (0==_cheats.items.count){
            _tableView.stateObject=[ViewStateObject initWithState:ViewState_Loading object:nil];
            [[CheatService shared] firstCheats];
        } else {
            [self fetchBlocks];
        }
    } else if (kLoading_First==_cheats.state){
        self.contentView.stateObject=[ViewStateObject initWithState:ViewState_Loading object:nil];
    } else if (kLoading_Refresh==_cheats.state){
        [self fetchBlocks];
        [_tableView.mj_header beginRefreshing];
    } else if (kLoading_More==_cheats.state){
        [self fetchBlocks];
        [_tableView.mj_footer beginRefreshing];
    }
}
- (void)cheatBlocks
{
    __weak typeof(self) wself=self;
    _cheats.first_block=^(BOOL result,NSInteger count,id echo,NSString *msg){
        wself.tableView.stateObject=[ViewStateObject initWithState:ViewState_Done object:nil];
        [wself fetchBlocks];
        [wself.tableView lp_reloadData];
    };
    _cheats.refresh_block=^(BOOL result,NSInteger count,id echo,NSString *msg){
        [wself.tableView.mj_header endRefreshing];
        [wself fetchBlocks];
        [wself.tableView lp_reloadData];
    };
    _cheats.more_block=^(BOOL result,NSInteger count,id echo,NSString *msg){
        [wself.tableView.mj_footer endRefreshing];
        [wself fetchBlocks];
        [wself.tableView lp_reloadData];
    };
}
- (void)fetchBlocks
{
    _tableView.mj_header=[MJRefreshGifHeader headerWithRefreshingBlock:^{
        [[CheatService shared] refreshCheats];
    }];
    if (_cheats.hasmore){
        _tableView.mj_footer=[MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            [[CheatService shared] moreCheats];
        }];
    } else {
        _tableView.mj_footer=nil;
    }
}
- (Cheat *)cheatAtIndexPath:(NSIndexPath *)indexPath
{
    return _cheats.items[indexPath.row];
}
#pragma mark
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (0==_cheats.items.count)?0:10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0==_cheats.items.count){
        return nil;
    }
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.w,10)];
    v.backgroundColor=kColorffffff;
    return v;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cheats.items.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CheatTableViewCell height];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier=@"cell";
    CheatTableViewCell *cell=LPMakeDefaultStyleTableViewCell(tableView,CheatTableViewCell,identifier);
    cell.cheat=[self cheatAtIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheatWebViewController *cwvc=[[CheatWebViewController alloc] init];
    cwvc.cheat=[self cheatAtIndexPath:indexPath];
    [self pushViewController:cwvc];
}
@end
