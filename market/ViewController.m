//
//  ViewController.m
//  market
//
//  Created by Lipeng on 2017/8/17.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"
#import "NavigationProxy.h"
#import "SysService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationBar.hidden=YES;
    self.view.backgroundColor=kColorf2f2f2;
    [NavigationProxy shared].navigationController=self;
    [LPUIProxy shared].navigationController=self;
    if ([SysService shared].ready){
        [self pushViewController:[[MainViewController alloc] init] animated:NO];
    }
    LP_AddObserver(kNotifySysReady,self,@selector(onReady:));
}

- (void)onReady:(id)notify {
    [self pushViewController:[[MainViewController alloc] init] animated:NO];
}
@end
