//
//  LPViewController+AI.h
//  market
//
//  Created by Lipeng on 2017/8/18.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "LPViewController.h"

@interface LPViewController(AI)
//是否登录
- (BOOL)checkLogin:(void (^)(void))block;
//是否登录，立即响应(不根据freetimes判断)
- (BOOL)instantCheckLogin:(void (^)(void))block;
//是否填写个人资料
- (BOOL)checkAuthed:(void (^)(void))block;

+ (void)loadSwizzling;
@end
