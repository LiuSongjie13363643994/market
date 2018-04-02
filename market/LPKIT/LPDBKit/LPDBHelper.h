//
//  LPDBHelper.h
//
//
//  Created by Lipeng on 15-6-24.
//  Copyright (c) 2015年 esuizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPSIMDB.h"

@interface LPDBHelper : NSObject
//当前的版本号
- (NSString *)version;
//打开
- (void)open;
//关闭
- (void)close;
//所有dao的class，不能重复，没有判断，子类实现
- (NSArray<Class> *)daoClazs;
//根据class获取dao
- (id)daoOfClaz:(Class)claz;
@end
