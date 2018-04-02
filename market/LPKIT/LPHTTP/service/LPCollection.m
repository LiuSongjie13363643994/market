//
//  LPCollection.m
//  JamGo
//
//  Created by Lipeng on 2017/6/23.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "LPCollection.h"

@interface LPCollection()
@property(nonatomic,strong) NSTimer *timer;
@end

@implementation LPCollection
- (instancetype)init
{
    if (self = [super init]) {
        _items = [NSMutableArray array];
    }
    return self;
}

- (void)discard:(NSTimeInterval)delay
{
    [_timer invalidate];
    __weak typeof(self) wself=self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:delay repeats:NO block:^(NSTimer * _Nonnull timer) {
        [wself reset];
    }];
}

- (void)pickup
{
    [_timer invalidate];
    _timer = nil;
}

- (void)reset
{
    _session++;
    if (kLoading_First == _state){
        [self block:_first_block result:NO count:0 echo:nil msg:nil];
    } else if (kLoading_Refresh == _state){
        [self block:_refresh_block result:NO count:0 echo:nil msg:nil];
    } else if (kLoading_More == _state){
        [self block:_more_block result:NO count:0 echo:nil msg:nil];
    }
    _state = kLoading_NA;
    [_items removeAllObjects];
    [_timer invalidate];
    _timer = nil;
}

- (void)block:(rm_fetch_done_block)block
       result:(BOOL)result
        count:(NSInteger)count
         echo:(id)echo msg:(NSString *)msg
{
    if (nil != block) {
        block(result, count, echo, msg);
    }
}
- (rm_fetch_done_block)blockOfState:(Loading_State)state
{
    if (kLoading_First == state){
        return _first_block;
    }
    if (kLoading_Refresh == state){
        return _refresh_block;
    }
    if (kLoading_More == state){
        return _more_block;
    }
    return nil;
}
- (void)didChange:(id)object
{
    if (nil != _change_block){
        _change_block(object);
    }
}
- (void)removeAllObjects{
    [_items removeAllObjects];
}

- (void)removeObject:(id)object
{
    [_items removeObject:object];
}

- (void)addObjectsFromArray:(NSArray *)otherArray
{
    [_items addObjectsFromArray:otherArray];
}

- (NSUInteger)count
{
    return _items.count;
}

@end
