//
//  ReqLoan.h
//  market
//
//  Created by Lipeng on 2017/8/25.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReqLoan : NSObject
//
@property(nonatomic,assign) NSInteger loan_id;
//
@property(nonatomic,assign) NSInteger loan_amount;
//
@property(nonatomic,assign) NSDate *loan_date;
//
@property(nonatomic,assign) NSDate *repay_date;
@end
