//
//  LPDBHelper.m
//
//
//  Created by Lipeng on 15-6-24.
//  Copyright (c) 2015年 esuizhen. All rights reserved.
//

#import "LPDBHelper.h"
#import <sqlite3.h>

#define kLPDBHelperVersionKey @"kLPDBHelperVersionKey"

@interface LPDBHelper()
//db连接，需要
@property(nonatomic, strong) LPSIMDB *db;
@property(nonatomic, strong) NSMutableDictionary<NSString *, LPDBDao *> *daos;
@end

@implementation LPDBHelper
- (instancetype)init
{
    if (self = [super init]){
        _daos = [NSMutableDictionary dictionary];
        self.db = [[LPSIMDB alloc] initWithName:NSStringFromClass(self.class)];
    }
    return self;
}

- (void)open
{
    [_db open];
    for (Class clz in self.daoClazs){
        if (![clz isKindOfClass:LPDBDao.class]) {
            NSAssert(1, @"%s",__func__);
        }
        _daos[NSStringFromClass(clz)] = [[clz alloc] initWithDB:self.db];
    }
}

- (void)close
{
    [_db close];
}

- (NSString *)version
{
    NSAssert(1,@"%s",__func__);
    return nil;
}

- (NSArray<Class> *)daoClazs
{
    NSAssert(1,@"%s",__func__);
    return nil;
}

- (id)daoOfClaz:(Class)claz
{
    return _daos[NSStringFromClass(claz)];
}
@end
