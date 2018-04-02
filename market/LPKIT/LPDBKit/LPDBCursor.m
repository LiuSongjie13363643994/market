//
//  LPDBCursor.m
//
//
//  Created by Lipeng on 15-6-24.
//  Copyright (c) 2015年 esuizhen. All rights reserved.
//

#import "LPDBCursor.h"
#import <sqlite3.h>

@interface LPDBCursor(){
    sqlite3_stmt *stmt;
}
@property(nonatomic, strong) NSArray *keys;
@end

@implementation LPDBCursor
- (void)setStmt:(void *)stmt0
{
    NSAssert(stmt0!=NULL, @"%s", __func__);
    self->stmt=stmt0;
    NSArray *a=[NSArray array];
    int cols = sqlite3_column_count(stmt0);
    for (int i=0; i<cols; i++) {
        a = [a arrayByAddingObject:[NSString stringWithUTF8String:sqlite3_column_name(stmt0, i)]];
    }
    _keys = a;
}

- (NSInteger)integerOfColumn:(NSString *)key
{
    NSUInteger idx = [_keys indexOfObject:key];
    
    if (NSNotFound!=idx && SQLITE_INTEGER==sqlite3_column_type(stmt, (int)idx)){
        return sqlite3_column_int(stmt, (int)idx);
    }
    return NSIntegerMin;
}

- (CGFloat)floatOfColumn:(NSString *)key
{
    NSUInteger idx = [_keys indexOfObject:key];
    if (NSNotFound!=idx && SQLITE_FLOAT==sqlite3_column_type(stmt, (int)idx)){
        return (CGFloat)sqlite3_column_double(stmt, (int)idx);
    }
    return CGFLOAT_MIN;
}
- (double)doubleOfColumn:(NSString *)key
{
    NSUInteger idx = [_keys indexOfObject:key];
    if (NSNotFound!=idx && SQLITE_FLOAT==sqlite3_column_type(stmt, (int)idx)){
        return sqlite3_column_double(stmt, (int)idx);
    }
    return DBL_MIN;
}

- (NSNumber *)numberOfCloumn:(NSString *)key
{
    NSUInteger idx = [_keys indexOfObject:key];
    if (NSNotFound!=idx){
        int ctype=sqlite3_column_type(stmt, (int)idx);
        if (SQLITE_INTEGER==ctype){
            return [NSNumber numberWithInteger:sqlite3_column_int(stmt, (int)idx)];
        } else if (SQLITE_FLOAT==ctype){
            return [NSNumber numberWithFloat:sqlite3_column_double(stmt, (int)idx)];
        }
    }
    return nil;
}

- (NSString *)stringOfColumn:(NSString *)key
{
    NSUInteger idx = [_keys indexOfObject:key];
    if (NSNotFound!=idx && SQLITE_TEXT==sqlite3_column_type(stmt, (int)idx)){
        return [NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, (int)idx)];
    }
    return nil;
}

- (NSData *)blobOfColumn:(NSString *)key
{
    NSUInteger idx = [_keys indexOfObject:key];
    if (NSNotFound != idx && SQLITE_BLOB == sqlite3_column_type(stmt, (int)idx)){
        int length = sqlite3_column_bytes(stmt, (int)idx);
        void *byte = (void *)sqlite3_column_blob(stmt, (int)idx);
        return [NSData dataWithBytes:byte length:length];
    }
    return nil;
}
@end
