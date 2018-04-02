//
//  LPTabBarController.m
//
//
//  Created by Lipeng on 15/11/15.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import "LPTabBarController.h"
#import "LPFDKit.h"
#import "LPTopViewController.h"

@interface LPTabBarController ()<UITabBarControllerDelegate>{
    BOOL didLoad;
}
@end


@implementation LPTabBarController

- (void)loadView
{
    [super loadView];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if ([self.tabBar respondsToSelector:@selector(setTranslucent:)]){
        self.tabBar.translucent = NO;
    }
    [self initAppearanceStyles];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    didLoad = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!didLoad) {
        NSArray *va = [NSArray array];
        NSInteger count = [_dataSource numberOfTabOptions:self];
        for (NSInteger index = 0; index < count; index++) {
            LPTopViewController *tvc = [self optionViewController:[_dataSource optionViewController:self atIndex:index]];
            tvc.tabIndex = index;
            va = [va arrayByAddingObject:tvc];
        }
        self.viewControllers = va;
        [self onIniting];
        didLoad = YES;
    }
}

- (void)onIniting
{
    
}

- (void)onTap:(UITapGestureRecognizer *)tap
{
    [_dataSource doubleTapTabItemAtInex:tap.view.tag];
}

- (BOOL)shouldAutorotate
{
    return NO;
}


- (LPTopViewController *)optionViewController:(NSArray *)array
{
    LPTopViewController *vc = [[array[0] alloc] init];
    vc.title             = array[1];
    vc.tabBarItem.title  = array[1];
    if (!IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        vc.tabBarItem.image = [UIImage imageNamed:array[2]];
        vc.tabBarItem.selectedImage = [UIImage imageNamed:array[3]];
    } else {
        vc.tabBarItem.image = [[UIImage imageNamed:array[2]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:array[3]]
                                       imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return vc;
}

- (void)initAppearanceStyles
{}

- (void)didSelectedOptionAtIndex:(NSInteger)index
{}

- (void)noTitle
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIView *v in self.tabBar.subviews) {
            if ([NSStringFromClass(v.class) rangeOfString:@"Button"].length > 0) {
                for (UIView *iv in v.subviews){
                    if ([iv isKindOfClass:UIImageView.class]) {
                        iv.lp_midy().lp_midx();
                        break;
                    }
                }
            }
        }
    });
}

- (void)redDotOnIndex:(NSInteger)index hidden:(BOOL)hidden
{
    UIView *itemv = nil;
    for (UIView *v in self.tabBar.subviews) {
        if ([NSStringFromClass(v.class) rangeOfString:@"Button"].length > 0) {
            if (0 == index) {
                itemv = v;
                break;
            } else {
                index--;
            }
        }
    }
    for (UIView *iv in itemv.subviews) {
        if ([iv isKindOfClass:UIImageView.class]) {
            iv.clipsToBounds = NO;
            UIView *dotv = [iv viewWithTag:-1];
            if (nil == dotv) {
                dotv = [[UIView alloc] initWithFrame:CGRectMake(0,0,6,6)];
                [dotv asRoundStlye:[UIColor redColor]];
                dotv.tag = -1;
                [iv addSubview:dotv];
                CGViewTransX(dotv, CGViewGetWidth(iv));
            }
            dotv.hidden = hidden;
            return;
        }
    }
}
#pragma mark -

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    [self didSelectedOptionAtIndex:[self.viewControllers indexOfObject:viewController]];
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
}
@end

