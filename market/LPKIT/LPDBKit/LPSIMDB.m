//
//  LPSIMDB.m
//
//
//  Created by Lipeng on 15-6-24.
//  Copyright (c) 2015年 esuizhen. All rights reserved.
//

#import "LPSIMDB.h"
#import <sqlite3.h>

@interface LPSIMDB(){
    sqlite3 *sqlite;
}
@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) dispatch_queue_t ioQueue;
@end

@implementation LPSIMDB

- (instancetype)initWithName:(NSString *)name
{
    if (self = [super init]){
        _name = name;
        _ioQueue = dispatch_queue_create([_name UTF8String], DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (NSString *)dbPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingPathComponent:self.name];
    return path;
}
//打开
- (void)open
{
    NSString *path = self.dbPath;
    TRACE(@"%@", path);
    sqlite3_config(SQLITE_CONFIG_SINGLETHREAD);
    
    if (SQLITE_OK != (sqlite3_open(path.UTF8String, &sqlite))) {
        sqlite3_close(sqlite);
        sqlite = NULL;
        return;
    }
    char *err;
    if (sqlite3_exec(sqlite, "PRAGMA journal_mode=WAL;", NULL, NULL, &err)!=SQLITE_OK) {
        TRACE(@"Failed to set WAL mode: %s", err);
    }
    sqlite3_wal_checkpoint(sqlite, NULL);
}

//关闭
- (void)close
{
    if (NULL != sqlite){
        sqlite3_close(sqlite);
        sqlite = NULL;
    }
}

//- (NSString *)queueName
//{
//    NSAssert(0, @"%s", __func__);
//    return nil;
//}
//- (NSString *)databaseName
//{
//    NSAssert(0, @"%s", __func__);
//    return nil;
//}

//从哪儿来回哪儿去
- (void)performThreadBlock:(void (^)(void))block
{
    block();
}
//安排同步执行
- (void)scheduleBlock:(void (^)(void))block mainBlock:(void (^)(void))mainblock
{
    NSThread *thread = [NSThread currentThread];
    dispatch_async(_ioQueue, ^{ @autoreleasepool {
        block();
        [self performSelector:@selector(performThreadBlock:) onThread:thread withObject:mainblock waitUntilDone:NO];
    }});
}
//直接执行SQL
- (void)execSQL:(NSString *)sql block:(db_execute_block)block
{
    NSAssert(sql.length>0, @"%s", __func__);
    __block BOOL result = NO;
    [self scheduleBlock:^{
        char *err = NULL;
        if (SQLITE_OK != sqlite3_exec(sqlite, [sql UTF8String], NULL, NULL, &err)) {
            TRACE(@"execSQL %@ error:%s", sql, err);
        } else {
            result = YES;
        }
    } mainBlock:^{
        if (block) {
            block(result);
        }
    }];
}

//创建表
- (void)createTable:(NSString *)table fields:(NSString *)fields block:(db_execute_block)block
{
    NSAssert(table.length > 0 && fields.length > 0, @"%s", __func__);
    [self execSQL:[NSString stringWithFormat:@"create table if not exists %@(%@)", table, fields] block:block];
}
- (void)alertTable:(NSString *)table fields:(NSArray<NSString *> *)fields block:(db_execute_block)block
{
    NSAssert(table.length > 0 && fields.count > 0, @"%s", __func__);
    for (NSString *field in fields) {
        [self execSQL:[NSString stringWithFormat:@"alter table %@ add column %@", table, field] block:block];
    }
}
//单条插入
- (void)insert:(NSString *)table object:(id)object builer:(id<LPDBBuilderDelegate>)builder block:(db_execute_block)block
{
    NSAssert((0 != table.length && nil != object && nil != builder), @"%s", __func__);
    __block BOOL result=YES;
    [self scheduleBlock:^{
        LPDBValues *cv = [builder deconstruct:object];
        if (nil != cv){
            int t;
            sqlite3_stmt *stmt;
            NSArray *keys = [cv allKeys];
            if ((t=sqlite3_prepare_v2(sqlite, [[self insertSQL:keys forTalbe:table] UTF8String], -1, &stmt, NULL)) == SQLITE_OK) {
                for (int i=0; i < [keys count]; i++) {
                    [self bindObject:[cv valueForKey:keys[i]] toColumn:i + 1 inStatement:stmt];
                }
                sqlite3_step(stmt);
                sqlite3_finalize(stmt);
            } else {
                TRACE(@"insert %@ error:%d", table, t);
                result=NO;
            }
        }
    } mainBlock:^{
        if (block){
            block(result);
        }
    }];
}
//批量插入
- (void)insert:(NSString *)table objects:(NSArray *)objects builer:(id<LPDBBuilderDelegate>)builder block:(db_execute_block)block
{
    NSAssert((0 != table.length && 0 != objects.count && nil != builder), @"%s", __func__);
    __block BOOL result = YES;
    [self scheduleBlock:^{
        int index = 0;
        NSArray *keys = nil;
        //找到第一个非空元素，并获取keys
        for (; index < objects.count; index++) {
            LPDBValues * cv = [builder deconstruct:objects[index]];
            if (nil != cv) {
                keys = [cv allKeys];
                break;
            }
        }
        if (objects.count == index){
            result = NO;
        } else {
            sqlite3_stmt *stmt; int t; char *err;
            if (sqlite3_exec(sqlite, "BEGIN TRANSACTION", NULL, NULL, &err)!=SQLITE_OK) {
                TRACE(@"Failed to begin transaction: %s", err);
            } else {
                if ((t=sqlite3_prepare_v2(sqlite, [[self insertSQL:keys forTalbe:table] UTF8String], -1, &stmt, NULL)) == SQLITE_OK) {
                    for (; index < objects.count; index++) {
                        LPDBValues *cv = [builder deconstruct:objects[index]];
                        if (nil!=cv){
                            for (int i = 0; i < [keys count]; i++) {
                                [self bindObject:[cv valueForKey:keys[i]] toColumn:i+1 inStatement:stmt];
                            }
                            sqlite3_step(stmt);
                            sqlite3_reset(stmt);
                        }
                    }
                    sqlite3_finalize(stmt);
                    if (sqlite3_exec(sqlite, "COMMIT TRANSACTION", NULL, NULL, &err) != SQLITE_OK) {
                        TRACE(@"Failed to commit transaction: %s", err);
                        result=NO;
                    }
                } else {
                    TRACE(@"insert %@ error:%d", table, t);
                    result=NO;
                }
            }
        }
    } mainBlock:^{
        if (block){
            block(result);
        }
    }];
}
//查询
- (void)select:(NSString *)table fields:(NSString *)fields condition:(NSString *)condition order:(NSString *)order builer:(id<LPDBBuilderDelegate>)builder block:(db_select_block)block
{
    NSAssert((0 != table.length && nil != builder), @"%s", __func__);
    __block NSMutableArray *objects = [NSMutableArray array];
    [self scheduleBlock:^{
        NSString *sql = [NSString stringWithFormat:@"select %@ from %@", fields.length > 0 ? fields : @"*", table];
        if (condition.length > 0){
            sql = [sql stringByAppendingFormat:@" %@", condition];
        }
        if (order.length > 0){
            sql = [sql stringByAppendingFormat:@" %@", order];
        }
        
        int t;
        sqlite3_stmt *stmt;
        
        if ((t = sqlite3_prepare(sqlite, [sql UTF8String], -1, &stmt, NULL)) == SQLITE_OK) {
            LPDBCursor *cs = [[LPDBCursor alloc] init];
            [cs setStmt:stmt];
            while (SQLITE_ROW == sqlite3_step(stmt)) {
                id ob = [builder build:cs];
                if (ob != nil) {
                    [objects addObject:ob];
                }
            }
            sqlite3_finalize(stmt);
        } else {
            TRACE(@"select %@ error:%d", table, t);
        }
    } mainBlock:^{
        if (block){
            block(objects);
        }
    }];
}
//删除
- (void)delete:(NSString *)table condition:(NSString *)condition block:(db_execute_block)block
{
    NSAssert(0!=table.length, @"%s", __func__);
    __block BOOL result=YES;
    [self scheduleBlock:^{
        NSString *sql = [NSString stringWithFormat:@"delete from %@", table];
        if (condition.length > 0){
            sql = [sql stringByAppendingFormat:@" %@", condition];
        }
        int t;
        char *err;
        if ((t = sqlite3_exec(sqlite, [sql UTF8String], NULL, NULL, &err)) == SQLITE_OK) {
            if ((t = sqlite3_exec(sqlite, "VACUUM", NULL, NULL, &err))!=SQLITE_OK){
                TRACE(@"vacuum %@ error:%d %s", table, t, err);
            }
        } else {
            TRACE(@"delete %@ error:%d %s", table, t, err);
            result = NO;
        }
    } mainBlock:^{
        if (block){
            block(result);
        }
    }];
}

//更新
- (void)update:(NSString *)table object:(id)object builer:(id<LPDBBuilderDelegate>)builder condition:(NSString *)condition block:(db_execute_block)block
{
    NSAssert(0 != table.length && nil != object && nil != builder, @"%s", __func__);
    __block BOOL result = YES;
    [self scheduleBlock:^{
        LPDBValues *cv = [builder deconstruct:object];
        if (nil != cv){
            int t;
            sqlite3_stmt *stmt;
            NSArray *keys = [cv allKeys];
            if ((t = sqlite3_prepare_v2(sqlite, [[self updateSQL:keys condition:condition forTalbe:table] UTF8String], -1, &stmt, NULL)) == SQLITE_OK) {
                for (int i = 0; i < [keys count]; i++) {
                    [self bindObject:[cv valueForKey:keys[i]] toColumn:i + 1 inStatement:stmt];
                }
                sqlite3_step(stmt);
                sqlite3_finalize(stmt);
            } else {
                TRACE(@"update %@ error:%d", table, t);
                result=NO;
            }
        }
    } mainBlock:^{
        if (block){
            block(result);
        }
    }];
}

//准备更新SQL
- (NSString *)updateSQL:(NSArray *)keys condition:(NSString *)condition forTalbe:(NSString *)table
{
    NSString *sql = [NSString stringWithFormat:@"update %@ set ", table];
    
    for (NSString *key in keys) {
        sql = [sql stringByAppendingFormat:@"%@=?", key];
        if ([keys lastObject] != key){
            sql = [sql stringByAppendingString:@", "];
        }
    }
    if (condition.length > 0){
        sql = [sql stringByAppendingFormat:@" %@", condition];
    }
    return sql;
}

//准备插入SQL
- (NSString *)insertSQL:(NSArray *)keys forTalbe:(NSString *)table
{
    NSString *sql = [NSString stringWithFormat:@"insert into %@(", table];
    NSString *v = @") values(";
    
    for (NSString *key in keys) {
        sql = [sql stringByAppendingString:key];
        v = [v stringByAppendingString:@"?"];
        if ([keys lastObject] == key){
            v = [v stringByAppendingString:@")"];
            break;
        }
        sql = [sql stringByAppendingString:@","];
        v = [v stringByAppendingString:@","];
    }
    sql = [sql stringByAppendingString:v];
    return sql;
}

- (void)bindObject:(id)obj toColumn:(int)idx inStatement:(sqlite3_stmt*)pStmt
{
    if ((!obj) || ((NSNull *)obj == [NSNull null])) {
        sqlite3_bind_null(pStmt, idx);
    } else if ([obj isKindOfClass:[NSData class]]) {
        const void *bytes = [obj bytes];
        if (!bytes) {
            bytes = "";
        }
        sqlite3_bind_blob(pStmt, idx, bytes, (int)[obj length], SQLITE_STATIC);
    } else if ([obj isKindOfClass:[NSDate class]]) {
        //        if (self.hasDateFormatter)
        //            sqlite3_bind_text(pStmt, idx, [[self stringFromDate:obj] UTF8String], -1, SQLITE_STATIC);
        //        else
        //            sqlite3_bind_double(pStmt, idx, [obj timeIntervalSince1970]);
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        
        if (strcmp([obj objCType], @encode(char)) == 0) {
            sqlite3_bind_int(pStmt, idx, [obj charValue]);
        } else if (strcmp([obj objCType], @encode(unsigned char)) == 0) {
            sqlite3_bind_int(pStmt, idx, [obj unsignedCharValue]);
        } else if (strcmp([obj objCType], @encode(short)) == 0) {
            sqlite3_bind_int(pStmt, idx, [obj shortValue]);
        } else if (strcmp([obj objCType], @encode(unsigned short)) == 0) {
            sqlite3_bind_int(pStmt, idx, [obj unsignedShortValue]);
        } else if (strcmp([obj objCType], @encode(int)) == 0) {
            sqlite3_bind_int(pStmt, idx, [obj intValue]);
        } else if (strcmp([obj objCType], @encode(unsigned int)) == 0) {
            sqlite3_bind_int64(pStmt, idx, (long long)[obj unsignedIntValue]);
        } else if (strcmp([obj objCType], @encode(long)) == 0) {
            sqlite3_bind_int64(pStmt, idx, [obj longValue]);
        } else if (strcmp([obj objCType], @encode(unsigned long)) == 0) {
            sqlite3_bind_int64(pStmt, idx, (long long)[obj unsignedLongValue]);
        } else if (strcmp([obj objCType], @encode(long long)) == 0) {
            sqlite3_bind_int64(pStmt, idx, [obj longLongValue]);
        } else if (strcmp([obj objCType], @encode(unsigned long long)) == 0) {
            sqlite3_bind_int64(pStmt, idx, (long long)[obj unsignedLongLongValue]);
        } else if (strcmp([obj objCType], @encode(float)) == 0) {
            sqlite3_bind_double(pStmt, idx, [obj floatValue]);
        } else if (strcmp([obj objCType], @encode(double)) == 0) {
            sqlite3_bind_double(pStmt, idx, [obj doubleValue]);
        } else if (strcmp([obj objCType], @encode(BOOL)) == 0) {
            sqlite3_bind_int(pStmt, idx, ([obj boolValue] ? 1 : 0));
        } else {
            sqlite3_bind_text(pStmt, idx, [[obj description] UTF8String], -1, SQLITE_STATIC);
        }
    } else {
        sqlite3_bind_text(pStmt, idx, [[obj description] UTF8String], -1, SQLITE_STATIC);
    }
}
@end
