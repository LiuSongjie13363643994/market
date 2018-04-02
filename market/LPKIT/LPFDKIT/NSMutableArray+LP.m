//
//  NSMutableArray+LP.m
//  Beauty
//
//  Created by Lipeng on 2017/6/8.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "NSMutableArray+LP.h"

@implementation NSMutableArray(LP)
- (void)addDiffObjectsFromArray:(NSArray *)otherArray
{
    NSMutableArray *a=[NSMutableArray array];
    for (id object in otherArray) {
        if (NSNotFound==[self indexOfObject:object]){
            [a addObject:object];
        }
    }
    [self addObjectsFromArray:a];
}
- (void)removeObjectsFromArray:(NSArray *)otherArray
{
    for (NSInteger i=self.count-1;i>=0;i--){
        id object=self[i];
        if (NSNotFound!=[otherArray indexOfObject:object]) {
            [self removeObject:object];
        }
    }
}
@end
