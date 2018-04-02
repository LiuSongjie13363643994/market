//
//  MarketTopViewController.m
//  market
//
//  Created by Lipeng on 2017/8/18.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "MarketTopViewController.h"
#import "ProductWebViewController.h"
#import "ProductsViewController.h"
#import "ADWebViewController.h"

#import "MXCycleScrollView.h"
#import "ProductTableViewCell.h"

#import "SysService.h"
#import "ProductService.h"
#import "OpService.h"

@interface MarketTopViewController ()<UITableViewDelegate,UITableViewDataSource,MXCycleScrollViewDelegate>
@property(nonatomic) MXCycleScrollView *bannerView;
@property(nonatomic) UILabel *onlineLabel;
@property(nonatomic) UITableView *tableView;
@property(nonatomic,strong) LPCollection *grooms;
@end

@implementation MarketTopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"全网速贷";
    [self hideNavigationBar];
    _grooms=[ProductService shared].grooms;
    [self groomBlocks];
    _tableView=LPAddPlainTableView(self.contentView,UITableView,NO,self.contentView.bounds);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableHeaderView=self.headerView;
    [self fetchState];
    
    [self checkLogin:^{}];
    
    LP_AddObserver(kNotifyUserLogined,self,@selector(onLogin:));
    LP_AddObserver(kNotifyUserUpdated,self,@selector(onUpdate:));
    LP_AddObserver(kNotifySysAdRefreshed,self,@selector(onAdRefresh:));
}
- (void)onLogin:(id)notify
{
    [_grooms reset];
    _tableView.mj_header=nil;
    _tableView.mj_footer=nil;
    [self fetchState];
}
- (void)onUpdate:(id)notify
{
    [_grooms reset];
    _tableView.mj_header=nil;
    _tableView.mj_footer=nil;    
    [self fetchState];
}
- (void)onAdRefresh:(id)notify
{
    _bannerView.contents=[SysService shared].bannerAds;
}
- (UIView *)headerView
{
    CGFloat h=(9*LP_Screen_Width)/16;
    
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0,0,LP_Screen_Width,h+84+34+10)];
    
    _bannerView=[[MXCycleScrollView alloc] initWithFrame:CGRectMake(15,-5,v.w-30,h)
                                            withContents:[SysService shared].bannerAds
                                          andScrollDelay:3];
    _bannerView.delegate=self;
    [v addSubview:_bannerView];
    
    _onlineLabel = (UILabel *)v.lp_av(UILabel.class, 0, 25, 0, 34);
    [_onlineLabel setFont:LPFont(14) color:kColorffffff alignment:NSTextAlignmentCenter];
    [_onlineLabel asRoundStlye:kColor0000006];
    _onlineLabel.fitWidth = YES;
    
    UIView *v1=v.lp_av(UIView.class,0,h,LP_Screen_Width,85);
    v1.backgroundColor=kColorffffff;
    [v1 drawBottomLine:self.view.backgroundColor];
    
    __weak typeof(self) wself=self;
    int count = (int)MIN(4, [SysService shared].configure.topics.count);
    CGFloat w=LP_Screen_Width/count;
    for (int i=0;i<count;i++){
        Topic *topic=[SysService shared].configure.topics[i];
        UIButton *btn=(UIButton *)v1.lp_av(UIButton.class,i*w,0,w,-1);
        [self button:btn image:topic.icon_url text:topic.title];
        [btn addActionBlock:^(UIButton *button) {
            ProductsViewController *pvc=[[ProductsViewController alloc] init];
            pvc.topic=topic;
            [wself pushViewController:pvc];
        }];
    }
    
    UIView *v2=v.lp_av(UIView.class,0,v1.y2,LP_Screen_Width,34);
    v2.backgroundColor=kColorffffff;
    v2.clipsToBounds=YES;
    UIImageView *iv=(UIImageView *)v2.lp_av(UIImageView.class,5,0,34,34);
    iv.image=[UIImage imageNamed:@"ic-cast"];
    
    CGFloat x=iv.x2;
    __weak UILabel *la1=(UILabel *)v2.lp_av(UILabel.class,x,0,v2.w-x-LP_X_GAP,34);
    [la1 setFont:LPFont(14) color:kColor666666 alignment:NSTextAlignmentLeft];
    __weak UILabel *la2=(UILabel *)v2.lp_av(UILabel.class,x,0,v2.w-x-LP_X_GAP,34);
    [la2 setFont:LPFont(14) color:kColor666666 alignment:NSTextAlignmentLeft];
    la2.transform=CGAffineTransformMakeTranslation(0,34);
    
    __block int tick=0,i=0;
    
    NSString *(^tip_block)()=^NSString *{
        NSString *txt=nil;
        if (i<[OpService shared].tips.count){
             txt=[OpService shared].tips[i];
        } else {
            i=0;
            txt=[OpService shared].tips.firstObject;
        }
        i++;
        return txt;
    };
    la1.text=tip_block();
    la2.text=tip_block();
    [NSTimer scheduledTimerWithTimeInterval:1.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        UILabel *up,*down;
        if (0==tick){
            tick=1;
            up=la1;
            down=la2;
        } else {
            tick=0;
            up=la2;
            down=la1;
        }
        
        [UIView animateWithDuration:.3 animations:^{
            up.transform=CGAffineTransformMakeTranslation(0,-34);
            down.transform=CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            up.transform=CGAffineTransformMakeTranslation(0,34);
            up.text=tip_block();
        }];
    }];
    
    return v;
}

- (void)button:(UIButton *)btn image:(NSString *)url text:(NSString *)text
{
    UIImageView *iv=(UIImageView *)btn.lp_av(UIImageView.class,0,10,44,44).lp_midx();
    [iv asRoundStlye:kColordddddd];
    [iv sd_setImageWithURL:[NSURL URLWithString:url]];
    
    UILabel *la=(UILabel *)btn.lp_av(UILabel.class,0,iv.y2+5,-1,12);
    [la setFont:LPFont(12) color:kColor23232b alignment:NSTextAlignmentCenter];
    la.text=text;
}

- (void)fetchState
{
    if (kLoading_NA==_grooms.state){
        if (0==_grooms.items.count){
            _tableView.stateObject=[ViewStateObject initWithState:ViewState_Loading object:nil];
            [[ProductService shared] firstGrooms];
        }
    } else if (kLoading_First==_grooms.state){
        self.contentView.stateObject=[ViewStateObject initWithState:ViewState_Loading object:nil];
    } else if (kLoading_Refresh==_grooms.state){
        [self fetchBlocks];
        [_tableView.mj_header beginRefreshing];
    }
}
- (void)groomBlocks
{
    __weak typeof(self) wself=self;
    _grooms.first_block=^(BOOL result,NSInteger count,id echo,NSString *msg){
        wself.tableView.stateObject=[ViewStateObject initWithState:ViewState_Done object:nil];
        [wself fetchBlocks];
        [wself.tableView lp_reloadData];
    };
    _grooms.refresh_block=^(BOOL result,NSInteger count,id echo,NSString *msg){
        [wself.tableView.mj_header endRefreshing];
        [wself fetchBlocks];
        [wself.tableView lp_reloadData];
    };
}
- (void)fetchBlocks
{
    _tableView.mj_header=[MJRefreshGifHeader headerWithRefreshingBlock:^{
        [[ProductService shared] refreshGrooms];
    }];
}
- (Product *)produtAtIndexPath:(NSIndexPath *)indexPath
{
    return _grooms.items[indexPath.row];
}
#pragma mark
- (void)clickImageIndex:(NSInteger)index
{
    Ad *ad=[SysService shared].ads[index];
    
    void (^block)()=^{
        if (kAdClickType_Product==ad.click_type){
            ProductWebViewController *pwvc=[[ProductWebViewController alloc] init];
            pwvc.product_id=ad.product_id;
            [self pushViewController:pwvc];
        } else if (kAdClickType_Inner==ad.click_type){
            ADWebViewController *wvc=[[ADWebViewController alloc] init];
            wvc.ad=ad;
            [self pushViewController:wvc];
        } else if (kAdClickType_Outer==ad.click_type){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ad.click_url]];
        }
    };
    if (!ad.need_login){
        block();
    } else {
        [self checkLogin:^{
            [self checkAuthed:^{
                block();
            }];
        }];
    }
    
}
#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _grooms.items.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ProductTableViewCell height];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier=@"cell";
    ProductTableViewCell *cell=LPMakeDefaultStyleTableViewCell(tableView,ProductTableViewCell,identifier);
    cell.product=[self produtAtIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) wself=self;
    Product *product=[wself produtAtIndexPath:indexPath];
    [[ProductService shared] click:product];
    [self checkLogin:^{
        [wself checkAuthed:^{
            ProductWebViewController *pwvc=[[ProductWebViewController alloc] init];
            pwvc.product=product;
            [wself pushViewController:pwvc];
        }];
    }];
}
@end
