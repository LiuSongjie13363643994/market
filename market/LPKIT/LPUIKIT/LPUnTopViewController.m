//
//  LPUnTopViewController.m
//  MDT
//
//  Created by Lipeng on 15/11/24.
//  Copyright (c) 2015年 West. All rights reserved.
//

#import "LPUnTopViewController.h"

@interface LPUnTopViewController ()

@end

@implementation LPUnTopViewController

- (void)loadView
{
    [super loadView];
    //布局控件使用
    CGRect frame = self.view.frame;
    if (self.navigationController.navigationBar && !self.navigationController.navigationBar.hidden){
        frame.size.height -= CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
        frame.size.height -= CGViewGetHeight(self.navigationController.navigationBar);
    }
    self.view.frame = frame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    if (iPhoneX){
//        self.contentView.lp_h(self.contentView.h - 20);
//        self.contentView.clipsToBounds = NO;
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onBack:(id)sender
{
    if ([self invokeBeforePopup]){
        [self popupViewController];
    }
}

- (BOOL)invokeBeforePopup
{
    return YES;
}
@end
