//
//  MeService.m
//  market
//
//  Created by Lipeng on 2017/8/24.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "MeService.h"
#import "ReqPage.h"
#import "ReqGetLoans.h"
#import "ReqLoan.h"
#import "ReqApply.h"
#import "ReqRepaid.h"

@interface MeService()
@property(nonatomic,strong) NSMutableDictionary *loansDic;
@end

@implementation MeService
LP_SingleInstanceImpl(MeService)

- (instancetype)init{
    if (self=[super init]) {
        _favs=[[LPCollection alloc] init];
        _loansDic=[NSMutableDictionary dictionary];
    }
    return self;
}

- (void)fav:(Product *)product block:(rm_result_block)block
{
    [self.httpProxy post:me_fav data:@(product.product_id) class:nil block:^(TransResp *resp) {
        if (0==resp.resp_code){
            product.fav_counts_txt=resp.data;
            product.is_fav=YES;
            if (_favs.items.count>0){
                [_favs.items insertObject:product atIndex:0];
                [_favs didChange:nil];
            }
        }
        block(0==resp.resp_code,resp.resp_msg);
    }];
}

- (void)unfav:(Product *)product block:(rm_result_block)block
{
    [_favs.items removeObject:product];
    [self.httpProxy post:me_unfav data:@(product.product_id) class:nil block:^(TransResp *resp) {
        if (0==resp.resp_code){
            product.fav_counts_txt=resp.data;
            product.is_fav=NO;
            if (_favs.items.count>0){
                [_favs didChange:nil];
            }
        }
        block(0==resp.resp_code,resp.resp_msg);
    }];
}

- (void)firstFavs
{
    [self remoteFavs:kLoading_First];
}
- (void)refreshFavs
{
    [self remoteFavs:kLoading_Refresh];
}
- (void)moreFavs
{
    [self remoteFavs:kLoading_More];
}
- (void)remoteFavs:(Loading_State)state
{
    rm_fetch_done_block block=[_favs blockOfState:state];
    if (kLoading_NA!=_favs.state) {
        [_favs block:block result:NO count:0 echo:nil msg:nil];
        return;
    }
    ReqPage *request=[[ReqPage alloc] init];
    request.page_no=(kLoading_More==state)?(_favs.items.count+49)/50:0;
    request.page_size=50;
    
    NSInteger session=_favs.session;
    [self.httpProxy post:me_get_favs data:request arrayClass:Product.class block:^(TransResp *resp) {
        if (session==_favs.session){
            NSArray *a=nil;
            if (0==resp.resp_code) {
                a=(NSArray *)resp.data;
                if (kLoading_More!=state){
                    [_favs.items removeAllObjects];
                }
                [_favs.items addDiffObjectsFromArray:a];
                _favs.hasmore=(a.count>=50);
            }
            _favs.state=kLoading_NA;
            [_favs block:block result:0==resp.resp_code count:a.count echo:nil msg:nil];
        }
    }];
}

#pragma 我的贷款

- (void)apply:(Product *)product amount:(NSInteger)amount block:(rm_result_block)block
{
    ReqApply *request=[[ReqApply alloc] init];
    request.product_id=product.product_id;
    request.apply_amount=amount;
    [self.httpProxy post:me_apply data:request class:nil block:^(TransResp *resp) {
        block(0==resp.resp_code,resp.resp_msg);
    }];
}
- (void)loan:(Loan *)loan amount:(NSInteger)amount loan_date:(NSDate *)loan_date repay_date:(NSDate *)repay_date block:(rm_result_block)block
{
    ReqLoan *request=[[ReqLoan alloc] init];
    request.loan_id=loan.loan_id;
    request.loan_amount=amount;
    request.loan_date=loan_date;
    request.repay_date=repay_date;
    [self.httpProxy post:me_loan data:request class:Loan.class block:^(TransResp *resp) {
        if (0==resp.resp_code){
            [self replace:loan with:resp.data];
        }
        block(0==resp.resp_code,resp.resp_msg);
    }];
}
- (void)repaid:(Loan *)loan date:(NSDate *)date block:(rm_result_block)block
{
    ReqRepaid *request=[[ReqRepaid alloc] init];
    request.loan_id=loan.loan_id;
    request.repaid_date=date;
    [self.httpProxy post:me_repaid data:request class:Loan.class block:^(TransResp *resp) {
        if (0==resp.resp_code){
            [self replace:loan with:resp.data];
        }
        block(0==resp.resp_code,resp.resp_msg);
    }];
}
- (void)replace:(Loan *)loan1 with:(Loan *)loan2
{
    for (NSString *key in _loansDic.allKeys){
        LPCollection *loans=_loansDic[key];
        if ([loans.object integerValue]==-1){
            [loans.items replaceObjectAtIndex:[loans.items indexOfObject:loan1] withObject:loan2];
        } else {
            [loans.items removeObject:loan1];
        }
    }
}
- (LPCollection *)loans:(NSInteger)state
{
    NSString *key=@(state).stringValue;
    LPCollection *loans=_loansDic[key];
    if (nil==loans) {
        loans=[[LPCollection alloc] init];
        loans.object=@(state);
        _loansDic[key]=loans;
    }
    return loans;
}
- (void)firstLoans:(LPCollection *)loans
{
    [self remoteLoans:loans state:kLoading_First];
}
- (void)refreshLoans:(LPCollection *)loans
{
    [self remoteLoans:loans state:kLoading_Refresh];
}
- (void)moreLoans:(LPCollection *)loans
{
    [self remoteLoans:loans state:kLoading_More];
}
- (void)remoteLoans:(LPCollection *)loans state:(Loading_State)state
{
    rm_fetch_done_block block=[loans blockOfState:state];
    if (kLoading_NA!=loans.state) {
        [loans block:block result:NO count:0 echo:nil msg:nil];
        return;
    }
    ReqGetLoans *request=[[ReqGetLoans alloc] init];
    request.state=[loans.object integerValue];
    request.page_no=(kLoading_More==state)?(loans.items.count+49)/50:0;
    request.page_size=50;
    
    NSInteger session=loans.session;
    [self.httpProxy post:me_get_loans data:request arrayClass:Loan.class block:^(TransResp *resp) {
        if (session==loans.session){
            NSArray *a=nil;
            if (0==resp.resp_code) {
                a=(NSArray *)resp.data;
                if (kLoading_More!=state){
                    [loans.items removeAllObjects];
                }
                [loans.items addDiffObjectsFromArray:a];
                loans.hasmore=(a.count>=50);
            }
            loans.state=kLoading_NA;
            [loans block:block result:0==resp.resp_code count:a.count echo:nil msg:nil];
        }
    }];
}

- (void)getAllScoreItems:(void (^)(BOOL, NSArray<ScoreItem *> *))block
{
    [self.httpProxy post:op_get_goods data:nil arrayClass:ScoreItem.class block:^(TransResp *resp) {
         block(0==resp.resp_code, resp.data);
    }];
}

- (void)exchangeGoodsOfId:(NSInteger)goodid block:(void (^)(BOOL result, NSString *url))block
{
    [self.httpProxy post:op_exchange_goods data:@(goodid) class:nil block:^(TransResp *resp) {
        block(0 == resp.resp_code, resp.data);
    }];
}

@end
