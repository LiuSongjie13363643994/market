//
//  NSURLSessionManager.m
//  DU365
//
//  Created by Lipeng on 16/7/21.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import "NSURLSessionManager.h"

@interface NSURLSessionManager()
@property(nonatomic,strong) NSMutableArray *sessions;
@end

@implementation NSURLSessionManager
LP_SingleInstanceImpl(NSURLSessionManager)
- (id)init
{
    if (self=[super init]) {
        _sessions = [NSMutableArray array];
    }
    return self;
}

- (NSURLSession *)session
{
    for (NSURLSession *session in _sessions) {
        if (session.numberOfTasking < session.configuration.HTTPMaximumConnectionsPerHost) {
            return session;
        }
    }
    NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    cfg.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    cfg.timeoutIntervalForRequest = 20;
    cfg.HTTPShouldSetCookies = NO;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:cfg];
    [_sessions addObject:session];
    return session;
}
@end
