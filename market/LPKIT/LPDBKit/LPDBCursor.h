//
//  LPDBCursor.h
//
//
//  Created by Lipeng on 15-6-24.
//  Copyright (c) 2015年 esuizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
//数据库游标
@interface LPDBCursor : NSObject
//db调用，请勿随意设置
- (void)setStmt:(void *)stmt;
//整数
- (NSInteger)integerOfColumn:(NSString *)key;
//
- (CGFloat)floatOfColumn:(NSString *)key;
//
- (double)doubleOfColumn:(NSString *)key;
//数字
- (NSNumber *)numberOfCloumn:(NSString *)key;
//字符串
- (NSString *)stringOfColumn:(NSString *)key;
//NSData
- (NSData *)blobOfColumn:(NSString *)key;
@end
