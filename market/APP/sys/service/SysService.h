//
//  SysService.h
//  market
//
//  Created by Lipeng on 2017/8/19.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "IService.h"
#import "Configure.h"
#import "MXCycleScrollView.h"

@interface SysService : IService
LP_SingleInstanceDec(SysService)
@property(nonatomic,strong,readonly) Configure *configure;
@property(nonatomic,strong,readonly) NSArray<Ad *> *ads;
- (void)getConfigure;
- (BOOL)ready;

- (NSArray<MXImageModel *> *)bannerAds;
@end
