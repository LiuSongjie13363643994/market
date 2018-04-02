//
//  UserService.m
//  market
//
//  Created by Lipeng on 2017/8/19.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "UserService.h"
#import "ReqLogin.h"

#define kUserKey @"kUserKey"

@implementation UserService
LP_SingleInstanceImpl(UserService)
- (instancetype)init{
    if (self=[super init]) {
        if ((self.user=[self read])!=nil){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LP_PostNotification(kNotifyUserLogined,nil,nil);
            });
        }
    }
    return self;
}

- (User *)read
{
    NSString *x=LP_ReadUserDefault(kUserKey);
    if (nil!=x) {
        return [User mj_objectWithKeyValues:x];
    }
    return nil;
}
- (void)write:(User *)user
{
    if (nil==user) {
        LP_RemoveUserDefault(kUserKey);
    } else {
        LP_WriteUserDefault(kUserKey,user.mj_JSONString);
    }
}
- (void)setUser:(User *)user
{
    _user=user;
    if (nil==user){
        _logined=NO;
        _authed=NO;
    } else {
        _logined=YES;
        _authed=(_user.name.length>0);
    }
}
- (void)getCaptcha:(NSString *)mobile block:(void (^)(BOOL result,NSString *captcha,NSString *msg))block
{
    [self.httpProxy post:user_get_captcha data:mobile class:nil block:^(TransResp *resp) {
        block(0==resp.resp_code,resp.data,resp.resp_msg);
    }];
}
- (void)login:(NSString *)mobile captcha:(NSString *)captcha block:(rm_result_block)block
{
    ReqLogin *request=[[ReqLogin alloc] init];
    request.mobile=mobile;
    request.captcha=captcha;
    [self.httpProxy post:user_login data:request class:User.class block:^(TransResp *resp) {
        if (0==resp.resp_code){
            [self write:resp.data];
            self.user=resp.data;
            LP_PostNotification(kNotifyUserLogined,nil,nil);
        }
        block(0==resp.resp_code,resp.resp_msg);
    }];
}
- (void)update:(User *)user block:(rm_result_block)block
{
    [self.httpProxy post:user_update data:user class:User.class block:^(TransResp *resp) {
        if (0==resp.resp_code){
            [self write:resp.data];
            self.user=resp.data;
            LP_PostNotification(kNotifyUserUpdated,nil,nil);
        }
        block(0==resp.resp_code,resp.resp_msg);
    }];
}
- (void)logout:(rm_result_block)block
{
    [self write:nil];
    _logined=NO;
    _user=nil;
    block(YES,nil);
    LP_PostNotification(kNotifyUserLogouted,nil,nil);
}

- (void)updateUserInfo:(UserInfo *)userInfo block:(rm_result_block)block
{
    [self.httpProxy post:userInfo_update data:userInfo class:UserInfo.class block:^(TransResp *resp) {
        if (0 == resp.resp_code) {
            self.user.user_info = resp.data;
            [self write:self.user];
        }
        block(0==resp.resp_code,resp.resp_msg);
    }];
}

- (void)checkIn:(rm_result_block)block
{
    [self.httpProxy post:user_check_in data:nil class:User.class block:^(TransResp *resp) {
        if (0==resp.resp_code){
            [self write:resp.data];
            self.user=resp.data;
            LP_PostNotification(kNotifyUserUpdated,nil,nil);
        }
        block(0==resp.resp_code,resp.resp_msg);
    }];
}

@end
