
//
//  SysService.m
//  market
//
//  Created by Lipeng on 2017/8/19.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "SysService.h"

#define kSysCfgKey @"kSysCfgKey"
#define kMax_free_times_Key @"kMax_free_times_Key"

@interface SysService()

@end

@implementation SysService
LP_SingleInstanceImpl(SysService)
- (instancetype)init{
    if (self=[super init]) {
        
    }
    return self;
}

- (void)getConfigure
{
    NSString *x=LP_ReadUserDefault(kSysCfgKey);
    if (nil!=x) {
        _configure=[Configure mj_objectWithKeyValues:x];
        if (_configure.topics.count>0){
            LP_PostNotification(kNotifySysReady,@(TRUE),nil);
        }
        _ads=_configure.banner_ads;
    }
    [self refreshConfigure];
}

- (void)refreshConfigure
{
    [self.httpProxy post:sys_get_config data:nil class:Configure.class block:^(TransResp *resp) {
        if (0==resp.resp_code){
            Configure *cfg=(Configure *)resp.data;
            LP_WriteUserDefault(kSysCfgKey,[cfg mj_JSONString]);
            LP_WriteUserDefault(kMax_free_times_Key, @(cfg.max_free_times))
            if (!self.ready){
                _configure=cfg;
                LP_PostNotification(kNotifySysReady,@(TRUE),nil);
            }
            _ads=cfg.banner_ads;
            LP_PostNotification(kNotifySysAdRefreshed,@(TRUE),nil);
        } else {
            [self refreshConfigure];
        }
    }];
}

- (BOOL)ready
{
    return (_configure.topics.count>0);
}
- (NSArray<MXImageModel *> *)bannerAds
{
    NSMutableArray<MXImageModel *> *as=[NSMutableArray array];
    
    for (Ad *ad in _ads){
        MXImageModel *im=[[MXImageModel alloc] init];
        im.imageUrl=ad.image_url;
        [as addObject:im];
    }
    return as;
}
@end
