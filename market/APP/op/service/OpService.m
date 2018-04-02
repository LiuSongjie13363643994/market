//
//  OpService.m
//  market
//
//  Created by Lipeng on 2017/8/27.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "OpService.h"

@interface OpService()

@end

@implementation OpService
LP_SingleInstanceImpl(OpService)

- (instancetype)init
{
    if (self=[super init]) {
        [NSTimer scheduledTimerWithTimeInterval:5*60 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self refreshTips];
        }];
        [self refreshTips];
    }
    return self;
}

- (void)refreshTips
{
    [self.httpProxy post:op_get_tips data:nil arrayClass:NSString.class block:^(TransResp *resp) {
        if (0==resp.resp_code){
            _tips=resp.data;
        }
    }];
}
@end
