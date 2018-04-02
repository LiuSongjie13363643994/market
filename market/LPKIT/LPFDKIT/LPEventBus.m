//
//  LPEventBus.m
//  ppablum
//
//  Created by Lipeng on 2017/12/10.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "LPEventBus.h"

@interface LPEventBus()
//target_event--->block
@property(nonatomic, strong) NSMutableDictionary *eventMap;
@end

@implementation LPEventBus
LP_SingleInstanceImpl(LPEventBus)

- (instancetype)init
{
    if (self = [super init]){
        _eventMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)register:(id)tagert event:(Class)claz block:(event_block)block
{
    NSString *name = NSStringFromClass(claz);
    NSString *key = [NSString stringWithFormat:@"%@__%p", name, (void *)tagert];
    _eventMap[key] = [block copy];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
    LP_AddObserver(name, self, @selector(onReceivedNotify:));
}

- (void)register:(id)tagert events:(NSArray<Class> *)clazs block:(event_block)block
{
    for (Class claz in clazs){
        [self register:tagert event:claz block:block];
    }
}

- (void)unregister:(id)target
{
    NSString *suffix = [NSString stringWithFormat:@"%p", (void *)target];
    NSMutableArray *keys = [NSMutableArray array];
    for (NSString *key in _eventMap.allKeys){
        if ([key hasSuffix:suffix]){
            [keys addObject:key];
        }
    }
    for (NSString *key in keys){
        [_eventMap removeObjectForKey:key];
    }
}

- (void)postEvent:(NSObject *)event
{
    LP_PostNotification(NSStringFromClass(event.class), event, nil);
}

- (void)onReceivedNotify:(NSNotification *)notify
{
    NSObject *event = notify.object;
    
    NSString *prefix = [NSStringFromClass(event.class) copy];
    for (NSString *key in _eventMap.allKeys){
        if ([key hasPrefix:prefix]){
            event_block block = _eventMap[key];
            dispatch_async(dispatch_get_main_queue(), ^{
                block(event);
            });
        }
    }
}
+ (void)register:(id)tagert event:(Class)claz block:(event_block)block
{
    [[LPEventBus shared] register:tagert event:claz block:block];
}

+ (void)register:(id)tagert events:(NSArray<Class> *)clazs block:(event_block)block
{
    [[LPEventBus shared] register:tagert events:clazs block:block];
}

+ (void)unregister:(id)target
{
    [[LPEventBus shared] unregister:target];
}

+ (void)postEvent:(NSObject *)event
{
    [[LPEventBus shared] postEvent:event];
}
@end

//static char kRegisterBlock;
//static char kUnRegisterBlock;
//
//@implementation NSObject(Event)
//- (register_event_block)event_register
//{
//    register_event_block block = objc_getAssociatedObject(self, &kRegisterBlock);
//    if (nil == block){
//        __weak typeof(self) wself = self;
//        block = ^(Class claz, event_block event_block){
//            if (nil != wself){
//                [[LPEventBus shared] register:wself event:claz block:event_block];
//            }
//        };
//        objc_setAssociatedObject(self, &kRegisterBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
//    }
//    return block;
//}
//
//- (unregister_event_block)event_unregister
//{
//    unregister_event_block block = objc_getAssociatedObject(self, &kUnRegisterBlock);
//    if (nil == block) {
//        __weak typeof(self) wself = self;
//        block = ^{
//            if (nil != wself){
//                [[LPEventBus shared] unregister:wself];
//                objc_setAssociatedObject(self, &kRegisterBlock, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
//                objc_setAssociatedObject(self, &kUnRegisterBlock, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
//            }
//        };
//        objc_setAssociatedObject(self, &kUnRegisterBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
//    }
//    return block;
//}
//@end

