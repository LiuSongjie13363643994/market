//
//  TouTiaoTopViewController.m
//  market
//
//  Created by 刘松杰 on 2018/3/24.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import "TouTiaoTopViewController.h"

#import "ProductWebViewController.h"
#import "ProductsViewController.h"
#import "ADWebViewController.h"
#import "TouTiaoWebViewController.h"
#import "AuthBaseViewController.h"
#import "PersonInfoViewController.h"

#import "MXCycleScrollView.h"
#import "TouTiaoTableViewCell.h"

#import "SysService.h"
#import "UserService.h"
#import "TouTiaotService.h"
#import "OpService.h"

#import "RegisterViewController.h"

@interface TouTiaoTopViewController ()<UITableViewDelegate,UITableViewDataSource,MXCycleScrollViewDelegate>
@property(nonatomic) MXCycleScrollView *bannerView;
@property(nonatomic) UITableView *tableView;
@property(nonatomic,strong) LPCollection *toutiaos;
@end

@implementation TouTiaoTopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    _toutiaos=[TouTiaotService shared].toutiaos;
    [self productsBlocks];
    
    _tableView=LPAddPlainTableView(self.contentView,UITableView,NO,self.contentView.bounds);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
    }
    [self fetchState];
    
    LP_AddObserver(kNotifyUserLogined,self,@selector(onLogin:));
    LP_AddObserver(kNotifyUserUpdated,self,@selector(onUpdate:));
    LP_AddObserver(kNotifySysAdRefreshed,self,@selector(onAdRefresh:));
}

- (void)onLogin:(id)notify
{
    [_toutiaos reset];
    _tableView.mj_header=nil;
    _tableView.mj_footer=nil;
    [self fetchState];
}
- (void)onUpdate:(id)notify
{
    [_toutiaos reset];
    _tableView.mj_header=nil;
    _tableView.mj_footer=nil;
    [self fetchState];
}
- (void)onAdRefresh:(id)notify
{
    _bannerView.contents=[SysService shared].bannerAds;
}

- (void)fetchState
{
    __weak typeof (self) wself = self;
    if (kLoading_NA==_toutiaos.state){
        if (0==_toutiaos.items.count){
            _tableView.stateObject=[ViewStateObject initWithState:ViewState_Loading object:nil];
            [[TouTiaotService shared] firstProducts:wself.toutiaos];
        }
    } else if (kLoading_First==_toutiaos.state){
        self.contentView.stateObject=[ViewStateObject initWithState:ViewState_Loading object:nil];
    } else if (kLoading_Refresh==_toutiaos.state){
        [self fetchBlocks];
        [_tableView.mj_header beginRefreshing];
    }
}
- (void)productsBlocks
{
    __weak typeof(self) wself=self;
    _toutiaos.first_block=^(BOOL result,NSInteger count,id echo,NSString *msg){
        wself.tableView.stateObject=[ViewStateObject initWithState:ViewState_Done object:nil];
        [wself fetchBlocks];
        [wself.tableView lp_reloadData];
    };
    _toutiaos.refresh_block=^(BOOL result,NSInteger count,id echo,NSString *msg){
        [wself.tableView.mj_header endRefreshing];
        [wself fetchBlocks];
        [wself.tableView lp_reloadData];
    };
}
- (void)fetchBlocks
{
    __weak typeof (self) wself = self;
    _tableView.mj_header=[MJRefreshGifHeader headerWithRefreshingBlock:^{
        [[TouTiaotService shared] refreshProducts:wself.toutiaos];
    }];
}

- (TouTiao *)produtAtIndexPath:(NSIndexPath *)indexPath
{
    return _toutiaos.items[indexPath.row];
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
    return _toutiaos.items.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TouTiaoTableViewCell height];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    TouTiaoTableViewCell *cell=LPMakeDefaultStyleTableViewCell(tableView,TouTiaoTableViewCell,identifier);
    cell.toutiao=[self produtAtIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof (self) wself = self;
    TouTiaoWebViewController *pwvc = [[TouTiaoWebViewController alloc] init];
    pwvc.url = ((TouTiao *)[self produtAtIndexPath:indexPath]).tt_url;
    [self checkLogin:^{
        [wself pushViewController:pwvc];
    }];
}

@end
