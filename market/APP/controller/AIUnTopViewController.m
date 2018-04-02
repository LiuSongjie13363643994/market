//
//  AIUnTopViewController.m
//  market
//
//  Created by Lipeng on 2017/8/18.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "AIUnTopViewController.h"

@interface AIUnTopViewController ()

@end

@implementation AIUnTopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) wself=self;
    UIButton *btn=[self addLeftNavigationImageButton:[UIImage imageNamed:@"btn-back"]];
    [btn addActionBlock:^(UIButton *button) {
        [wself onBack:button];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
