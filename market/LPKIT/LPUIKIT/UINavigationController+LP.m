//
//  UINavigationController+LP.m
//
//
//  Created by Lipeng on 15/11/15.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import "UINavigationController+LP.h"
#import "LPKit.h"
#import <objc/runtime.h>

static char kVCs;

@implementation UINavigationController(LP)

- (void)removeViewController:(UIViewController *)viewController
{
    NSMutableArray *as=objc_getAssociatedObject(self,&kVCs);
    if (nil==as) {
        as=[NSMutableArray array];
        objc_setAssociatedObject(self,&kVCs,as,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [as addObject:viewController];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (as.count>0){
            NSMutableArray *xas=[NSMutableArray arrayWithArray:self.viewControllers];
            [xas removeObjectsFromArray:as];
            self.viewControllers=xas;
            [as removeAllObjects];
        }
//    });
}

//- (void)lp_viewWillAppear:(BOOL)animated
//{
//    [self lp_viewWillAppear:animated];
//    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]){
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
//    
//    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//        self.interactivePopGestureRecognizer.delegate = self;
//    }
//}
//
//- (void)lp_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    [self lp_pushViewController:viewController animated:animated];
//    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
//}
//
//#pragma mark
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    if (self.viewControllers.count <= 1 ) {
//        return NO;
//    }
//    
//    return YES;
//}

#pragma mark - Method Swizzling

+ (void)loadSwizzling
{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class = [self class];
//
//        SwizzleSelector(class, @selector(pushViewController:animated:), @selector(lp_pushViewController:animated:));
//        SwizzleSelector(class, @selector(viewWillAppear:), @selector(lp_viewWillAppear:));
//    });
}
@end
