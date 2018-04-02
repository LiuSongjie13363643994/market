//
//  LoanView.h
//  market
//
//  Created by Lipeng on 2017/8/25.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Loan.h"

@interface LoanView : UIView
@property(nonatomic,copy) void (^cancel_block)(void);
@property(nonatomic,copy) void (^done_block)(NSInteger amount,NSDate *loanDate,NSDate *repayDate);
- (void)setLoan:(Loan *)loan;
@end
