//
//  Table.h
//
//
//  Created by Lipeng on 15-6-24.
//  Copyright (c) 2015年 esuizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPSIMDB.h"

//数据表
@interface LPDBDao : NSObject<LPDBBuilderDelegate>

//字段
+ (NSString *)tableFields;
//添加的字段
+ (NSArray<NSString *> *)alertFields;

- (instancetype)initWithDB:(LPSIMDB *)db;

//直接执行SQL语句
- (void)execSQL:(NSString *)sql block:(db_execute_block)block;
//插入
- (void)insert:(id)object block:(db_execute_block)block;
//批量插入
- (void)insertBatch:(NSArray *)objects block:(db_execute_block)block;
//查询
- (void)select:(NSString *)fields condition:(NSString *)condition order:(NSString *)order block:(db_select_block)block;
//更新 object:{@"key":,@"value":, @"id":}
- (void)update:(id)object condition:(NSString *)condition block:(db_execute_block)block;
//删除
- (void)delete:(NSString *)condition block:(db_execute_block)block;
//查询总数
- (void)rows:(NSString *)condition table:(NSString *)table block:(db_rows_block)block;

//转对象
- (id)build:(LPDBCursor *)cursor;
//转contentValues
- (LPDBValues *)deconstruct:(id)object;
@end
