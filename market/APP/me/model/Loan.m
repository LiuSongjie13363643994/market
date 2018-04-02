//
//  Loan.m
//  market
//
//  Created by Lipeng on 2017/8/24.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "Loan.h"

@implementation Loan
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"loan_id":@"id"};
}
- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:Loan.class]) {
        return [(Loan *)object loan_id]==_loan_id;
    }
    return NO;
}
@end
