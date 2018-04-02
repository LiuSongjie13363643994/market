//
//  NSNumber+LP.m
//  DU365
//
//  Created by Lipeng on 16/7/4.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import "NSNumber+LP.h"

@implementation NSNumber(LP)
- (NSString *)toString
{
    return [[[NSNumberFormatter alloc] init] stringFromNumber:self];
}
@end
