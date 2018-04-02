//
//  NSMutableArray+LP.h
//  Beauty
//
//  Created by Lipeng on 2017/6/8.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray(LP)
- (void)addDiffObjectsFromArray:(NSArray *)otherArray;
- (void)removeObjectsFromArray:(NSArray *)otherArray;
@end
