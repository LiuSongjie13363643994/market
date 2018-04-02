//
//  LPNetworkAide.m
//  ppablum
//
//  Created by Lipeng on 2017/12/1.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "LPNetworkAide.h"
#import "Reachability.h"

@interface LPNetworkAide()
@property (nonatomic, strong) Reachability *tester;
@end

@implementation LPNetworkAide
LP_SingleInstanceImpl(LPNetworkAide)

- (instancetype)init
{
    if (self = [super init]){
        _network = kNetwork_NA;
        _tester = [Reachability reachabilityForInternetConnection];
        LP_AddObserver(kReachabilityChangedNotification, self,@selector(reachabilityChanged:));
    }
    return self;
}

- (void)startTesting
{
    [_tester startNotifier];
    [self resetNetwork];
}

- (void)reachabilityChanged:(NSNotification *)notify
{
    [self resetNetwork];
}

- (void)resetNetwork
{
    switch (_tester.currentReachabilityStatus){
        case NotReachable:{
            _network = kNetwork_NA;
        }break;
        case ReachableViaWWAN:{
            _network = kNetwork_WWAN;
        }break;
        case ReachableViaWiFi:{
            _network = kNetwork_WiFi;
        }break;
        case Reachable4G:{
            _network = kNetwork_4G;
        }break;
        case Reachable3G:{
            _network = kNetwork_3G;
        }break;
        case Reachable2G:{
            _network = kNetwork_2G;
        }break;
        default: {
            _network = kNetwork_Unknown;
        }break;
    }
}
            
@end
