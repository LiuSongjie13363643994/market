//
//  LPNotifyBus.m
//
//
//  Created by Lipeng on 15/11/15.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import "LPNotifyBus.h"

@implementation LPNotifyBus
//注册通知
+ (void)registerObserver:(id)observer names:(NSArray *)names selector:(SEL)selector object:(id)object
{
    for (NSString *name in names) {
        [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:object];
    }
}
//反注册
+ (void)unregisterObserver:(id)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}
@end
