//
//  LPCollection.h
//  JamGo
//
//  Created by Lipeng on 2017/6/23.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    //NA状态
    kLoading_NA = 0,
    //首次加载
    kLoading_First,
    //下拉刷新
    kLoading_Refresh,
    //上拉加载
    kLoading_More
} Loading_State;

typedef void (^rm_fetch_done_block)(BOOL result,NSInteger count,id echo,NSString *msg);
typedef void (^lc_did_change_block)(id echo);

@interface LPCollection<T> : NSObject
//item列表
@property(nonatomic,strong,readonly) NSMutableArray<T> *items;
//session，用于判断响应的数据是否已过期
@property(nonatomic,assign,readonly) NSInteger session;
//当前状态
@property(nonatomic,assign) Loading_State state;
//是否有更多数据
@property(nonatomic,assign) BOOL hasmore;
//首次获取回调
@property(nonatomic,copy) rm_fetch_done_block first_block;
//下拉刷新回调
@property(nonatomic,copy) rm_fetch_done_block refresh_block;
//上啦加载回调
@property(nonatomic,copy) rm_fetch_done_block more_block;
//数据集变化时回调
@property(nonatomic,copy) lc_did_change_block change_block;
//可用于echo
@property(nonatomic,strong) id object;

//超时丢弃数据
- (void)discard:(NSTimeInterval)delay;
//数据重新有效
- (void)pickup;
//恢复
- (void)reset;
//执行回调
- (void)block:(rm_fetch_done_block)block result:(BOOL)result count:(NSInteger)count echo:(id)echo msg:(NSString *)msg;
//根据状态获取回调block
- (rm_fetch_done_block)blockOfState:(Loading_State)state;

- (NSUInteger)count;
- (void)removeAllObjects;
- (void)removeObject:(id)object;
- (void)addObjectsFromArray:(NSArray *)otherArray;
- (void)didChange:(id)object;
@end
