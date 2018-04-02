//
//  CheatService.m
//  market
//
//  Created by Lipeng on 2017/8/21.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "CheatService.h"
#import "ReqGetCheat.h"

@interface CheatService()

@end

@implementation CheatService
LP_SingleInstanceImpl(CheatService)
- (instancetype)init
{
    if (self=[super init]) {
        _cheats=[[LPCollection alloc] init];
    }
    return self;
}
- (void)firstCheats
{
    [self remoteCheats:kLoading_First];
}
- (void)refreshCheats
{
    [self remoteCheats:kLoading_Refresh];
}
- (void)moreCheats
{
    [self remoteCheats:kLoading_More];
}
- (void)remoteCheats:(Loading_State)state
{
    rm_fetch_done_block block=[_cheats blockOfState:state];
    if (kLoading_NA!=_cheats.state){
        block(NO,0,nil,nil);
        return;
    }
    NSInteger direct,cheat_id;
    if (0==_cheats.items.count){
        direct=1;
        cheat_id=0;
    } else {
        direct=(kLoading_More==state)?-1:1;
        Cheat *cheat=(kLoading_More==state)?_cheats.items.lastObject:_cheats.items.firstObject;
        cheat_id=cheat.cheat_id;
    }
    ReqGetCheat *request=[[ReqGetCheat alloc] init];
    request.direct=direct;
    request.size=50;
    request.cheat_id=cheat_id;
    _cheats.state=state;
    [self.httpProxy post:cheat_get data:request arrayClass:Cheat.class block:^(TransResp *resp) {
        NSArray *as=(NSArray *)resp.data;
        if (0==resp.resp_code){
            if (as.count>0){
                if (-1==request.direct){
                    [_cheats.items addObjectsFromArray:as];
                } else {
                    NSIndexSet *idxs=[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0,as.count)];
                    [_cheats.items removeObjectsFromArray:as];
                    [_cheats.items insertObjects:as atIndexes:idxs];
                }
            }
            if (kLoading_First==state||kLoading_More==state){
                _cheats.hasmore=(as.count>=50);
            }
        }
        _cheats.state=kLoading_NA;
        [_cheats block:block result:(0==resp.resp_code) count:as.count echo:nil msg:resp.resp_msg];
    }];
}

- (void)readCheat:(Cheat *)cheat
{
    [self.httpProxy post:cheat_read data:@(cheat.cheat_id) class:nil block:^(TransResp *resp) {
        if (0==resp.resp_code){
            cheat.tip=resp.data;
        }
    }];
}
@end
