//
//  MyFavsViewController.m
//  market
//
//  Created by Lipeng on 2017/8/20.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "MyFavsViewController.h"
#import "ProductWebViewController.h"
#import "FavTableViewCell.h"

#import "MeService.h"

@interface MyFavsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic) UITableView *tableView;
@property(nonatomic,strong) LPCollection *favs;
@end

@implementation MyFavsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"我的收藏";
    
    _favs=[MeService shared].favs;
    [self favBlocks];

    _tableView=LPAddPlainTableView(self.contentView,UITableView,NO,self.contentView.bounds);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self fetchState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
- (void)fetchState
{
    if (kLoading_NA==_favs.state){
        if (0==_favs.items.count){
            _tableView.stateObject=[ViewStateObject initWithState:ViewState_Loading object:nil];
            [[MeService shared] firstFavs];
        } else {
            [self fetchBlocks];
        }
    } else if (kLoading_First==_favs.state){
        self.contentView.stateObject=[ViewStateObject initWithState:ViewState_Loading object:nil];
    } else if (kLoading_Refresh==_favs.state){
        [self fetchBlocks];
        [_tableView.mj_header beginRefreshing];
    } else if (kLoading_More==_favs.state){
        [self fetchBlocks];
        [_tableView.mj_footer beginRefreshing];
    }
}
- (void)favBlocks
{
    __weak typeof(self) wself=self;
    _favs.first_block=^(BOOL result,NSInteger count,id echo,NSString *msg){
        wself.tableView.stateObject=[ViewStateObject initWithState:ViewState_Done object:nil];
        [wself fetchBlocks];
        [wself.tableView lp_reloadData];
    };
    _favs.refresh_block=^(BOOL result,NSInteger count,id echo,NSString *msg){
        [wself.tableView.mj_header endRefreshing];
        [wself fetchBlocks];
        [wself.tableView lp_reloadData];
    };
    _favs.more_block=^(BOOL result,NSInteger count,id echo,NSString *msg){
        [wself.tableView.mj_footer endRefreshing];
        [wself fetchBlocks];
        [wself.tableView lp_reloadData];
    };
    _favs.change_block=^(id echo){
        [wself.tableView lp_reloadData];
    };
}

- (void)fetchBlocks
{
    _tableView.mj_header=[MJRefreshGifHeader headerWithRefreshingBlock:^{
        [[MeService shared] refreshFavs];
    }];
    if (_favs.hasmore){
        _tableView.mj_footer=[MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            [[MeService shared] moreFavs];
        }];
    } else {
        _tableView.mj_footer=nil;
    }
}
- (Product *)favAtIndexPath:(NSIndexPath *)indexPath
{
    return _favs.items[indexPath.row];
}
#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _favs.items.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FavTableViewCell height];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    FavTableViewCell *cell=LPMakeSubtitleStyleTableViewCell(tableView,FavTableViewCell,identifier);
    cell.fav=[self favAtIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) wself=self;
    [self checkLogin:^{
        [wself checkAuthed:^{
            ProductWebViewController *pwvc=[[ProductWebViewController alloc] init];
            pwvc.product=[wself favAtIndexPath:indexPath];
            [wself pushViewController:pwvc];
        }];
    }];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"取消收藏";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) wself=self;
    Product *fav=[self favAtIndexPath:indexPath];
    [[MeService shared] unfav:fav block:^(BOOL result, NSString *msg) {
        if (wself.favs.hasmore && wself.favs.items.count<50){
            [[MeService shared] moreFavs];
        }
    }];
    if (0==_favs.items.count){
        [self.tableView lp_reloadData];
    } else {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}
@end
