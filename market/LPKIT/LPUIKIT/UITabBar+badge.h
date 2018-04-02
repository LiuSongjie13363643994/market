//
//  UITabBar+badge.h
//  DU365
//
//  Created by xuyuqiang on 16/7/15.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)
- (void)showBadgeOnItemIndex:(int)index;   //显示小红点
- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点
@end
