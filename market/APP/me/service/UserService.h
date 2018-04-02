//
//  UserService.h
//  market
//
//  Created by Lipeng on 2017/8/19.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "IService.h"
#import "User.h"

@interface UserService : IService
LP_SingleInstanceDec(UserService)

@property(nonatomic,strong) User *user;
//登录
@property(nonatomic,assign) BOOL logined;
//个人资料
@property(nonatomic,assign) BOOL authed;

- (void)getCaptcha:(NSString *)mobile block:(void (^)(BOOL result,NSString *captcha,NSString *msg))block;
- (void)login:(NSString *)mobile captcha:(NSString *)captcha block:(rm_result_block)block;
- (void)update:(User *)user block:(rm_result_block)block;
- (void)updateUserInfo:(UserInfo *)userInfo block:(rm_result_block)block;
- (void)logout:(rm_result_block)block;

- (void)checkIn:(rm_result_block)block;

@end
