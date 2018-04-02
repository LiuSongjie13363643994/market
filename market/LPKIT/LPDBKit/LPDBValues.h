//
//  LPDBValues.h
//
//
//  Created by Lipeng on 15-6-24.
//  Copyright (c) 2015年 esuizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
//数据库层对象
@interface LPDBValues : NSObject
//设置key-value
- (void)put:(NSString *)key value:(id)value;
//value4key
- (id)valueForKey:(NSString *)key;
//所有的key
- (NSArray *)allKeys;
@end
