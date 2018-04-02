//
//  LPNotifyBus.h
//
//
//  Created by Lipeng on 15/11/15.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LPNotifyBus : NSObject
//注册通知
+ (void)registerObserver:(id)observer names:(NSArray *)names selector:(SEL)selector object:(id)object;
//反注册
+ (void)unregisterObserver:(id)observer;

@end


