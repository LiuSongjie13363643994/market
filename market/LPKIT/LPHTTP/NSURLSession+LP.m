//
//  NSURLSession+LP.m
//  DU365
//
//  Created by Lipeng on 16/7/21.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import "NSURLSession+LP.h"
#import <objc/runtime.h>

static char kNumberOfTaskingKey;

@implementation NSURLSession(LP)
- (void)setNumberOfTasking:(NSInteger)numberOfTasking
{
    objc_setAssociatedObject(self,&kNumberOfTaskingKey,[NSNumber numberWithInteger:numberOfTasking],OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)numberOfTasking
{
    return [objc_getAssociatedObject(self,&kNumberOfTaskingKey) integerValue];
}
@end

