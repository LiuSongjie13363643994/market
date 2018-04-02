//
//  LPTopViewController.m
//
//
//  Created by Lipeng on 15/11/15.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import "LPTopViewController.h"
#import "LPGeometry.h"

@interface LPTopViewController ()

@end

@implementation LPTopViewController
- (void)loadView
{
    [super loadView];
    if (!self.tabBarController.hideTabBar){
        self.view.lp_h(self.view.h - (iPhoneX ? 83 : 49));
    }
    if (self.navigationController.navigationBar && !self.navigationController.navigationBar.hidden){
        self.view.lp_h(self.view.h - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
        self.view.lp_h(self.view.h - self.tabBarController.navigationController.navigationBar.h);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.title = self.title;
    self.tabBarController.navigationItem.leftBarButtonItem  = [self leftNavigationItem];
    self.tabBarController.navigationItem.rightBarButtonItem = [self rightNavigationItem];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//选中
- (void)singleTapOnTabBar:(BOOL)changed{}
@end
