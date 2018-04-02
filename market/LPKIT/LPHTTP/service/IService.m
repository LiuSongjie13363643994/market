//
//  IService.m
//  JamGo
//
//  Created by Lipeng on 2017/6/22.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "IService.h"
enum{
    ERROR_CODE_SUCCESS=0,
    ERROR_CODE_FAILURE=1,
    ERROR_CODE_SECRET=2,
    ERROR_QUESTION_NOT_EXIST=3,
};
@implementation IService
- (instancetype)init
{
    if (self=[super init]) {
        _httpProxy=[[HttpProxy alloc] init];
        _httpProxy.filter_block=^(TransResp *resp){
            if (0!=resp.resp_code && 1!=resp.resp_code && -1!=resp.resp_code){
                [LPAlertView know:resp.resp_msg block:^{}];
            }
        };
    }
    return self;
}
@end
