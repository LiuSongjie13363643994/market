//
//  ProductViewController.m
//  market
//
//  Created by Lipeng on 2017/8/19.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "ProductsViewController.h"
#import "ProductWebViewController.h"
#import "ProductTableViewCell.h"

#import "ProductService.h"

@interface ProductsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic) UITableView *tableView;
@property(nonatomic,strong) LPCollection *products;
@end

@implementation ProductsViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self fetchState];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=_topic.title;
    
    _products=[[ProductService shared] products:_topic];
    [self productBlocks];
    _tableView=LPAddPlainTableView(self.contentView,UITableView,NO,self.contentView.bounds);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    LP_AddObserver(kNotifyUserLogined,self,@selector(onLogin:));
}
- (void)onLogin:(id)notify
{
    [_products reset];
    _tableView.mj_header=nil;
    _tableView.mj_footer=nil;
    [self fetchState];
}
- (void)fetchState
{
    if (kLoading_NA==_products.state){
        if (0==_products.items.count){
            _tableView.stateObject=[ViewStateObject initWithState:ViewState_Loading object:nil];
            [[ProductService shared] firstProducts:_products];
        } else {
            [self fetchBlocks];
        }
    } else if (kLoading_First==_products.state){
        self.contentView.stateObject=[ViewStateObject initWithState:ViewState_Loading object:nil];
    } else if (kLoading_Refresh==_products.state){
        [self fetchBlocks];
        [_tableView.mj_header beginRefreshing];
    } else if (kLoading_More==_products.state){
        [self fetchBlocks];
        [_tableView.mj_footer beginRefreshing];
    }
}
- (void)productBlocks
{
    __weak typeof(self) wself=self;
    _products.first_block=^(BOOL result,NSInteger count,id echo,NSString *msg){
        wself.tableView.stateObject=[ViewStateObject initWithState:ViewState_Done object:nil];
        [wself fetchBlocks];
        [wself.tableView lp_reloadData];
    };
    _products.refresh_block=^(BOOL result,NSInteger count,id echo,NSString *msg){
        [wself.tableView.mj_header endRefreshing];
        [wself fetchBlocks];
        [wself.tableView lp_reloadData];
    };
    _products.more_block=^(BOOL result,NSInteger count,id echo,NSString *msg){
        [wself.tableView.mj_footer endRefreshing];
        [wself fetchBlocks];
        [wself.tableView lp_reloadData];
    };
}
- (void)fetchBlocks
{
    __weak typeof(self) wself=self;
    _tableView.mj_header=[MJRefreshGifHeader headerWithRefreshingBlock:^{
        [[ProductService shared] refreshProducts:wself.products];
    }];
    if (_products.hasmore){
        _tableView.mj_footer=[MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            [[ProductService shared] moreProducts:wself.products];
        }];
    } else {
        _tableView.mj_footer=nil;
    }
}
- (Product *)produtAtIndexPath:(NSIndexPath *)indexPath
{
    return _products.items[indexPath.row];
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _products.items.count;
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
