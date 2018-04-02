//
//  LPTabBarController.h
//
//
//  Created by Lipeng on 15/11/15.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITabBarController+LP.h"

@class LPTabBarController;

@protocol LPTabBarControllerDataSouce <NSObject>
//tab控制器个数
- (NSInteger)numberOfTabOptions:(LPTabBarController *)tabBarController;
//选项对应的viewController
//@[class, title, image, imageHL]
- (NSArray *)optionViewController:(LPTabBarController *)tabBarController atIndex:(NSInteger)index;
//双击TabItem
- (void)doubleTapTabItemAtInex:(NSInteger)index;
@end

@interface LPTabBarController : UITabBarController

@property(nonatomic, assign) id<LPTabBarControllerDataSouce> dataSource;
//初始化显示样式
- (void)initAppearanceStyles;
//选中某个tab
- (void)didSelectedOptionAtIndex:(NSInteger)index;

- (void)redDotOnIndex:(NSInteger)index hidden:(BOOL)hidden;

- (void)onIniting;

- (void)noTitle;
@end
