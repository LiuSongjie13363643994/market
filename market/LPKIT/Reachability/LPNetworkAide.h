//
//  LPNetworkAide.h
//  ppablum
//
//  Created by Lipeng on 2017/12/1.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNetwork_NA         @"NA"
#define kNetwork_WWAN       @"WWAN"
#define kNetwork_WiFi       @"WiFi"
#define kNetwork_4G         @"4G"
#define kNetwork_3G         @"3G"
#define kNetwork_2G         @"2G"
#define kNetwork_Unknown    @"Unknown"

@interface LPNetworkAide : NSObject
LP_SingleInstanceDec(LPNetworkAide)

@property(nonatomic, copy, readonly) NSString *network;

- (void)startTesting;
@end
