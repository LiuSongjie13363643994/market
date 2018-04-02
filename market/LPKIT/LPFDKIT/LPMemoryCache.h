//
//  LPMemoryCache.h
//  DU365
//
//  Created by Lipeng on 16/7/3.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import <Foundation/Foundation.h>
//对象缓存
@interface LPMemoryCache : NSObject
LP_SingleInstanceDec(LPMemoryCache)
- (void)start;
- (void)putObject:(id)object key:(NSString *)key period:(NSTimeInterval)period;
- (id)getObjectForKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;
@end

#define LP_PutObjectInCacheMemory(OBJECT,KEY,PEROID) [[LPMemoryCache shared] putObject:OBJECT key:KEY period:PEROID]
#define LP_GetObjectOnCacheMemory(KEY) [[LPMemoryCache shared] getObjectForKey:KEY]
#define LP_RmoveObjectOnCacheMemory(KEY) [[LPMemoryCache shared] removeObjectForKey:KEY]

#define LP_MemoryMin(x) ((x)*60)
