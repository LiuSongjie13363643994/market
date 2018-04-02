//
//  TouTiaotService.m
//  market
//
//  Created by 刘松杰 on 2018/3/24.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import "TouTiaotService.h"
#import "ReqPage.h"

@implementation TouTiaotService
LP_SingleInstanceImpl(TouTiaotService)

- (instancetype)init{
    if (self=[super init]) {
        _toutiaos=[[LPCollection alloc] init];
    }
    return self;
}

- (void)firstProducts:(LPCollection *)toutiaos
{
    [self remoteProducts:toutiaos state:kLoading_First];
}
- (void)refreshProducts:(LPCollection *)toutiaos
{
    [self remoteProducts:toutiaos state:kLoading_Refresh];
}
- (void)moreProducts:(LPCollection *)toutiaos
{
    [self remoteProducts:toutiaos state:kLoading_More];
}

- (void)remoteProducts:(LPCollection *)toutiaos state:(Loading_State)state
{
    rm_fetch_done_block block=[toutiaos blockOfState:state];
    if (kLoading_NA!=toutiaos.state) {
        [toutiaos block:block result:NO count:0 echo:nil msg:nil];
        return;
    }
    ReqPage *request=[[ReqPage alloc] init];
    request.page_no=(kLoading_More==state)?(toutiaos.items.count+49)/50:0;
    request.page_size=50;
    
    NSInteger session=toutiaos.session;
    [self.httpProxy post:product_tts data:request arrayClass:TouTiao.class block:^(TransResp *resp) {
        if (session==toutiaos.session){
            NSArray *a=nil;
            if (0==resp.resp_code) {
                a=(NSArray *)resp.data;
                if (kLoading_More!=state){
                    [toutiaos.items removeAllObjects];
                }
                [toutiaos.items addDiffObjectsFromArray:a];
                toutiaos.hasmore=(a.count>=50);
            }
            toutiaos.state=kLoading_NA;
            [toutiaos block:block result:0==resp.resp_code count:a.count echo:toutiaos.object msg:nil];
        }
    }];
}

@end
