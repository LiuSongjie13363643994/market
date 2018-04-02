//
//  User.m
//  market
//
//  Created by Lipeng on 2017/8/22.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "User.h"

@implementation User
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"user_id":@"id"};
}
- (instancetype)initWithUser:(User *)user
{
    if (self=[super init]){
        _user_id=user.user_id;
        _mobile=user.mobile;
        _name=user.name;
        _id_card=user.id_card;
        _city=user.city;
        _education=user.education;
        _occupation=user.occupation;
        _income=user.income;
        _zhima=user.zhima;
        _supplies=user.supplies;
        _loan_amount=user.loan_amount;
        _loan_period=user.loan_period;
    }
    return self;
}
@end
