//
//  ScoreStoreViewController.m
//  market
//
//  Created by 刘松杰 on 2018/3/31.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import "ScoreStoreViewController.h"
#import "AIWeb1ViewController.h"
#import "ScoreItmeTableViewCell.h"
#import "UserService.h"
#import "MeService.h"
#import "SysService.h"
@interface ScoreStoreViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic) UITableView *tableView;
@property(nonatomic, strong) NSArray<ScoreItem *> *items;
@end

@implementation ScoreStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) wself = self;
    [[self addRightNavigationTextButton:@"积分规则"] addActionBlock:^(UIButton *button) {
        AIWeb1ViewController *wvc=[[AIWeb1ViewController alloc] init];
        wvc.url=[SysService shared].configure.score_url;
        [self pushViewController:wvc];
    }];
    
    _tableView = LPAddPlainTableView(self.contentView,UITableView,NO,self.contentView.bounds);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.headView;
    [self fetchData];
    
    _tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [wself fetchData];
    }];
}

- (void)fetchData
{
    __weak typeof (self) wself = self;
    [[MeService shared] getAllScoreItems:^(BOOL result, NSArray<ScoreItem *> *items) {
        if (result) {
            [wself.tableView.mj_header endRefreshing];
            wself.items = items;
            [wself.tableView lp_reloadData];
        }
    }];
}

- (UIView *)headView
{
    NSString *score = [NSString stringWithFormat:@"%ld", (long)[UserService shared].user.score];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.w, 140)];
    UILabel *la = (UILabel *)v.lp_av(UILabel.class, 0, 0, 0, LPBoldFontHeight(30));
    [la setFont:LPBoldFont(30) color:kColor6d9ff8 alignment:NSTextAlignmentCenter];
    la.fitWidth = YES;
    la.text = score;
    la.lp_inx(LP_Screen_Width/2 - 20).lp_midy();
    
    la = (UILabel *)v.lp_av(UILabel.class, 0, 75, 0, LPBoldFontHeight(12));
    [la setFont:LPBoldFont(12) color:kColorf0a56f alignment:NSTextAlignmentCenter];
    la.fitWidth = YES;
    la.text = @"积分";
    la.lp_inx(LP_Screen_Width/2 + 10);
    return v;
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ScoreItmeTableViewCell cellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    ScoreItmeTableViewCell *cell=LPMakeDefaultStyleTableViewCell(tableView,ScoreItmeTableViewCell,identifier);
    cell.item = _items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[MeService shared] exchangeGoodsOfId:((ScoreItem *)(_items[indexPath.row])).item_id block:^(BOOL result, NSString *url) {
        
    }];
}

@end
