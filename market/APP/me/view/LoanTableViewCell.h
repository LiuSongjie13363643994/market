//
//  LoanTableViewCell.h
//  market
//
//  Created by Lipeng on 2017/8/20.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "AIGTableViewCell.h"
#import "Loan.h"

@interface LoanTableViewCell : AIGTableViewCell
@property(nonatomic,strong) Loan *loan;
+ (CGFloat)height;
@end
