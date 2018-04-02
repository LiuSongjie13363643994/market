//
//  LPDBDao.m
//
//
//  Created by Lipeng on 15-6-24.
//  Copyright (c) 2015年 esuizhen. All rights reserved.
//

#import "LPDBDao.h"
#import "LPSIMDBBuilder.h"

@interface LPDBDao()
@property(nonatomic, strong) LPSIMDB *db;
@property(nonatomic, copy) NSString *tableName;
@end

@implementation LPDBDao

+ (void)createOnDb:(LPSIMDB *)db withTableName:(NSString *)tableName
{
    [db createTable:tableName fields:[self tableFields] block:nil];
}

+ (void)alertOnDb:(LPSIMDB *)db withTableName:(NSString *)tableName
{
    NSArray *fields = [self alertFields];
    if (0 != fields.count) {
        [db alertTable:tableName fields:fields block:nil];
    }
}

//字段
+ (NSString *)tableFields
{
    NSAssert(0, @"%s", __func__);
    return nil;
}
//添加的字段
+ (NSArray<NSString *> *)alertFields
{
    return nil;
}

- (instancetype)initWithDB:(LPSIMDB *)db
{
    if (self = [super init]) {
        self.db = db;
        self.tableName = NSStringFromClass(self.class);
        [self.class createOnDb:db withTableName:self.tableName];
        [self.class alertOnDb:db withTableName:self.tableName];
    }
    return self;
}

//直接执行SQL语句
- (void)execSQL:(NSString *)sql block:(db_execute_block)block
{
    [_db execSQL:sql block:block];
}
//插入
- (void)insert:(id)object block:(db_execute_block)block
{
    [_db insert:_tableName object:object builer:self block:block];
}
//批量插入
- (void)insertBatch:(NSArray *)objects block:(db_execute_block)block
{
    [_db insert:_tableName objects:objects builer:self block:block];
}
//查询
- (void)select:(NSString *)fields condition:(NSString *)condition order:(NSString *)order block:(db_select_block)block
{
    [_db select:_tableName fields:fields condition:condition order:order builer:self block:block];
}
//更新
- (void)update:(id)object condition:(NSString *)condition block:(db_execute_block)block
{
    [_db update:_tableName object:object builer:self condition:condition block:block];
}
//删除
- (void)delete:(NSString *)condition block:(db_execute_block)block
{
    [_db delete:_tableName condition:condition block:block];
}

//查询总数
- (void)rows:(NSString *)condition table:(NSString *)table block:(db_rows_block)block
{
    [_db select:(0 == table.length)?[self.class tableName]:table
         fields:@"count(*) as count"
      condition:condition
          order:nil
         builer:[[LPSIMDBRowsBuilder alloc] init]
          block:^(NSArray *objects) {
              if (0==objects.count) {
                  block(-1);
              } else {
                  block(((LPSIMDBRowsObject*)objects[0]).rows);
              }
          }];
}
//转对象
- (id)build:(LPDBCursor *)cursor
{
    return nil;
}

//转contentValues
- (LPDBValues *)deconstruct:(id)object
{
    return nil;
}
@end
