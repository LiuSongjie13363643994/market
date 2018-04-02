//
//  UIResponder+LP.m
//  MDT
//
//  Created by Lipeng on 15/11/28.
//  Copyright (c) 2015年 West. All rights reserved.
//

#import "UIResponder+LP.h"

@implementation UIResponder(LP)
- (void)routerEvent:(NSString *)event information:(NSDictionary *)information
{
    [[self nextResponder] routerEvent:event information:information];
}
@end
