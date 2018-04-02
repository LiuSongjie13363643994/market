//
//  LPSIMDB.h
//
//
//  Created by Lipeng on 15-6-24.
//  Copyright (c) 2015年 esuizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPDBValues.h"
#import "LPDBCursor.h"
#import "LPDBBuilder.h"

typedef void (^db_execute_block)(BOOL result);
typedef void (^db_select_block)(NSArray *objects);
//条数 -1错误
typedef void (^db_rows_block)(NSInteger rows);
//简单数据库连接类，仅支持单表操作
@interface LPSIMDB : NSObject

- (instancetype)initWithName:(NSString *)name;
//打开数据库连接
- (void)open;
//关闭数据库连接
- (void)close;
//执行SQL
- (void)execSQL:(NSString *)sql block:(db_execute_block)block;
//创建表
- (void)createTable:(NSString *)table fields:(NSString *)fields block:(db_execute_block)block;
//修改表
- (void)alertTable:(NSString *)table fields:(NSArray<NSString *> *)fields block:(db_execute_block)block;
//单条插入
- (void)insert:(NSString *)table object:(id)object builer:(id<LPDBBuilderDelegate>)builder block:(db_execute_block)block;
//批量插入
- (void)insert:(NSString *)table objects:(NSArray *)objects builer:(id<LPDBBuilderDelegate>)builder block:(db_execute_block)block;
//查询
- (void)select:(NSString *)table fields:(NSString *)fields condition:(NSString *)condition order:(NSString *)order builer:(id<LPDBBuilderDelegate>)builder block:(db_select_block)block;
//删除
- (void)delete:(NSString *)table condition:(NSString *)condition block:(db_execute_block)block;
//更新
- (void)update:(NSString *)table object:(id)object builer:(id<LPDBBuilderDelegate>)builder condition:(NSString *)condition block:(db_execute_block)block;
@end
