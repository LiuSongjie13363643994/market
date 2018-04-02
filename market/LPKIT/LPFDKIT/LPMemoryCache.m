//
//  LPMemoryCache.m
//  DU365
//
//  Created by Lipeng on 16/7/3.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import "LPMemoryCache.h"


@interface LPCacheObject : NSObject
//对象
@property(nonatomic,strong) id object;
//放入的时间戳
@property(nonatomic,assign) NSTimeInterval liveTimestamp;
//结束时间戳
@property(nonatomic,assign) NSTimeInterval deathTimestamp;
@end

@implementation LPCacheObject

@end

@interface LPMemoryCache()
@property(nonatomic,strong) NSMutableDictionary *cacheMem;
@property(nonatomic,strong) NSTimer *cycelTimer;
@end

@implementation LPMemoryCache
LP_SingleInstanceImpl(LPMemoryCache)
- (void)dealloc
{
    LP_RemoveObserver(self);
}

- (id)init
{
    self=[super init];
    if (self) {
        LP_AddObserver(UIApplicationDidReceiveMemoryWarningNotification,self,@selector(onMemoryWarning:));
        _cacheMem=[NSMutableDictionary dictionary];
        _cycelTimer=[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(onOneCycel:) userInfo:nil repeats:YES];
    }
    return self;
}
- (void)onMemoryWarning:(id)notify
{
    _cacheMem=[NSMutableDictionary dictionary];
}
- (void)start
{
//    _cacheMem=[NSMutableDictionary dictionary];
//    _cycelTimer=[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(onOneCycel:) userInfo:nil repeats:YES];
}
- (void)onOneCycel:(id)timer
{
    NSTimeInterval now=[[NSDate date] timeIntervalSince1970];
    NSArray *allKeys=[NSArray arrayWithArray:_cacheMem.allKeys];
    for (NSString *key in allKeys) {
        LPCacheObject *co=_cacheMem[key];
        if (co.deathTimestamp<=now) {
            [_cacheMem removeObjectForKey:key];
        }
    }
}

- (void)putObject:(id)object key:(NSString *)key period:(NSTimeInterval)period
{
    LPCacheObject *co=[[LPCacheObject alloc] init];
    co.object=object;
    co.liveTimestamp=[[NSDate date] timeIntervalSince1970];
    co.deathTimestamp=co.liveTimestamp+period;
    _cacheMem[key]=co;
}
- (id)getObjectForKey:(NSString *)key
{
    LPCacheObject *co=_cacheMem[key];
    return nil==co?nil:co.object;
}
- (void)removeObjectForKey:(NSString *)key
{
    _cacheMem[key]=nil;
}
@end
