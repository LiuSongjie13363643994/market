//
//  MeService.h
//  market
//
//  Created by Lipeng on 2017/8/24.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "IService.h"
#import "Product.h"
#import "Loan.h"
#import "ScoreItem.h"

@interface MeService : IService
LP_SingleInstanceDec(MeService)
#pragma 我的收藏
@property(nonatomic,strong,readonly) LPCollection *favs;

- (void)fav:(Product *)product block:(rm_result_block)block;
- (void)unfav:(Product *)product block:(rm_result_block)block;

- (void)firstFavs;
- (void)refreshFavs;
- (void)moreFavs;

#pragma 我的贷款
- (void)apply:(Product *)product amount:(NSInteger)amount block:(rm_result_block)block;
- (void)loan:(Loan *)loan amount:(NSInteger)amount loan_date:(NSDate *)loan_date repay_date:(NSDate *)repay_date block:(rm_result_block)block;
- (void)repaid:(Loan *)loan date:(NSDate *)date block:(rm_result_block)block;

- (LPCollection *)loans:(NSInteger)state;
- (void)firstLoans:(LPCollection *)loans;
- (void)refreshLoans:(LPCollection *)loans;
- (void)moreLoans:(LPCollection *)loans;

#pragma 积分商场
- (void)getAllScoreItems:(void (^)(BOOL result, NSArray<ScoreItem *>* items))block;
- (void)exchangeGoodsOfId:(NSInteger)goodid block:(void (^)(BOOL result, NSString *url))block;
@end
