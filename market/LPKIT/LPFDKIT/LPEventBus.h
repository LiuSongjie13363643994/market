//
//  LPEventBus.h
//  ppablum
//
//  Created by Lipeng on 2017/12/10.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^event_block)(id event);
@interface LPEventBus : NSObject
LP_SingleInstanceDec(LPEventBus)

+ (void)register:(id)tagert event:(Class)claz block:(event_block)block;

+ (void)register:(id)tagert events:(NSArray<Class> *)clazs block:(event_block)block;

+ (void)unregister:(id)target;

+ (void)postEvent:(NSObject *)event;

@end

//typedef void (^register_event_block)(Class claz, event_block block);
//typedef void (^unregister_event_block)(void);
//
//@interface NSObject(Event)
//
//- (register_event_block)event_register;
//
//- (unregister_event_block)event_unregister;
//@end

