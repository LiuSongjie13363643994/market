//
//  UIViewController+LP.h
//  MDT
//
//  Created by Lipeng on 15/11/24.
//  Copyright (c) 2015年 West. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(LP)

@property(nonatomic,assign) BOOL displaying;

- (void)pushViewController:(UIViewController *)viewController;

- (void)popupViewController;

- (void)removeSelf;

+ (void)loadSwizzling;
@end
