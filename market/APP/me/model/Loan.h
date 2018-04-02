//
//  Loan.h
//  market
//
//  Created by Lipeng on 2017/8/24.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "Product.h"

enum{
    //全部
    kLoan_State_All=-1,
    //已申请
    kLoan_State_Apply=0,
    //已放款
    kLoan_State_Loan=1,
    //已还款
    kLoan_State_Repay=2,
    //已逾期
    kLoan_State_Overdue=3,
};

@interface Loan : NSObject
@property(nonatomic,assign) NSInteger loan_id;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *icon_url;
@property(nonatomic,assign) NSInteger state;
//申请金额
@property(nonatomic,assign) NSInteger apply_amount;
@property(nonatomic,strong) NSDate *apply_date;
@property(nonatomic,strong) NSDate *loan_date;
@property(nonatomic,strong) NSDate *repay_date;
@property(nonatomic,strong) NSDate *repaid_date;
//积分
@property(nonatomic,assign) NSInteger score;
@property(nonatomic,copy) NSString *state_txt;

@end
