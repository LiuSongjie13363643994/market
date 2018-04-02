//
//  UIViewController+LP.m
//  MDT
//
//  Created by Lipeng on 15/11/24.
//  Copyright (c) 2015年 West. All rights reserved.
//

#import "UIViewController+LP.h"

static char kDisplayingKey;

@implementation UIViewController(LP)
- (void)lp_viewDisappear:(BOOL)animated
{
    [self lp_viewDisappear:animated];
    self.displaying=YES;
}

- (void)lp_viewDidDisappear:(BOOL)animated
{
    [self lp_viewDidDisappear:animated];
    self.displaying=NO;
}

- (void)setDisplaying:(BOOL)displaying
{
    objc_setAssociatedObject(self,&kDisplayingKey,@(displaying),OBJC_ASSOCIATION_RETAIN);
}
- (BOOL)displaying
{
    return [objc_getAssociatedObject(self,&kDisplayingKey) boolValue];
}

- (void)pushViewController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)popupViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)removeSelf
{
    [self.navigationController removeViewController:self];
}

+ (void)loadSwizzling
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SwizzleSelector(class, @selector(viewDidDisappear:), @selector(lp_viewDisappear:));
        SwizzleSelector(class, @selector(viewDidDisappear:), @selector(lp_viewDidDisappear:));
    });
}

@end
