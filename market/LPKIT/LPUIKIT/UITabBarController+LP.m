//
//  UITabBarController+LP.m
//  MrMood
//
//  Created by Lipeng on 2017/7/22.
//  Copyright © 2017年 Lipeng. All rights reserved.
//

#import "UITabBarController+LP.h"

static char kHideKey;

@implementation UITabBarController(LP)
- (BOOL)hideTabBar
{
    return [objc_getAssociatedObject(self,&kHideKey) boolValue];
}

- (void)setHideTabBar:(BOOL)hideTabBar
{
    objc_setAssociatedObject(self,&kHideKey,@(hideTabBar),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITabBar class]]) {
            if (hideTabBar) {
                [view setFrame:CGRectMake(view.frame.origin.x, [UIScreen mainScreen].bounds.size.height, view.frame.size.width , view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, [UIScreen mainScreen].bounds.size.height - 49, view.frame.size.width, view.frame.size.height)];
            }
        }else if([view isKindOfClass:NSClassFromString(@"UITransitionView")]){
            if (hideTabBar) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
                
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 49)];
            }
        }
    }
    [UIView commitAnimations];
    if (hideTabBar){
        for (UIViewController *vc in self.viewControllers){
            vc.view.lp_h(LP_Screen_Height);
        }
    } else {
        for (UIViewController *vc in self.viewControllers){
            vc.view.lp_h(LP_Screen_Height-49);
        }
    }
}

@end
