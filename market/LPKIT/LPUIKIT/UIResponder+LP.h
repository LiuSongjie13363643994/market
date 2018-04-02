//
//  UIResponder+LP.h
//  MDT
//
//  Created by Lipeng on 15/11/28.
//  Copyright (c) 2015年 West. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma 事件路由
//控件KEY
#define kRouterEventKey_Responder @"kRouterEventKey_Responder"
//信息KEY
#define kRouterKeyInformation @"kRouterKeyInformation"

#define kRouterKeyInformation2 @"kRouterKeyInformation2"

#define kRouterKeyInformation3 @"kRouterKeyInformation3"

@interface UIResponder(LP)
- (void)routerEvent:(NSString *)event information:(NSDictionary *)information;
@end
