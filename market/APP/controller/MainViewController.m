//
//  MainViewController.m
//  market
//
//  Created by Lipeng on 2017/8/18.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "MainViewController.h"
#import "MarketTopViewController.h"
#import "CheatsTopViewController.h"
#import "MeTopViewController.h"
#import "FindViewController.h"

#import "TouTiaoTopViewController.h"

#import "SysService.h"

@interface MainViewController ()<LPTabBarControllerDataSouce>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource=self;

}

//初始化显示样式
- (void)initAppearanceStyles
{
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kColora8a8a8,
                                                        NSFontAttributeName:LPFont(12)}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kColore13f3c,
                                                        NSFontAttributeName:LPFont(12)}
                                             forState:UIControlStateSelected];
    [[UITabBar appearance] setBackgroundColor:kColorf6f6f6];
}
//选中某个tab
- (void)didSelectedOptionAtIndex:(NSInteger)index
{}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark

- (NSInteger)numberOfTabOptions:(LPTabBarController *)tabBarController
{
    return 4;
}

- (NSArray *)optionViewController:(LPTabBarController *)tabBarController atIndex:(NSInteger)index
{

    if (0==index){
        if (0 == [SysService shared].configure.project) {
            return @[MarketTopViewController.class, @"首页", @"ic-home-n", @"ic-home-y"];
        } else {
            return @[TouTiaoTopViewController.class, @"首页", @"ic-home-n", @"ic-home-y"];
        }
    }
    if (1==index) {
        return @[FindViewController.class, @"发现", @"ic-find-n", @"ic-find-y"];
    }
    if (2==index){
        return @[CheatsTopViewController.class, @"秘籍", @"ic-cheats-n", @"ic-cheats-y"];
    }
    return @[MeTopViewController.class, @"我的", @"ic-me-n", @"ic-me-y"];
}
//双击TabItem
- (void)doubleTapTabItemAtInex:(NSInteger)index{}
@end
