//
//  UINavigationController+LP.h
//
//
//  Created by Lipeng on 15/11/15.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController(LP)<UIGestureRecognizerDelegate>
- (void)removeViewController:(UIViewController *)viewController;
+ (void)loadSwizzling;
@end
