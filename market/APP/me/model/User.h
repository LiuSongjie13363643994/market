//
//  User.h
//  market
//
//  Created by Lipeng on 2017/8/22.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface User : NSObject
@property(nonatomic,strong)UserInfo *user_info;
//
@property(nonatomic,assign) NSInteger user_id;
//手机号
@property(nonatomic,copy) NSString *mobile;
//姓名
@property(nonatomic,copy) NSString *name;
//身份证号码
@property(nonatomic,copy) NSString *id_card;
//城市
@property(nonatomic,copy) NSString *city;
//最高学历
@property(nonatomic,copy) NSString *education;
//职业状态
@property(nonatomic,copy) NSString *occupation;
//收入
@property(nonatomic,assign) NSInteger income;
//芝麻分
@property(nonatomic, assign) NSInteger zhima;
//补充信息
@property(nonatomic,copy) NSString *supplies;
//贷款金额
@property(nonatomic,assign) NSInteger loan_amount;
//贷款周期
@property(nonatomic,assign) NSInteger loan_period;

@property(nonatomic,assign) NSInteger score;

@property(nonatomic,copy) NSString *level;

@property(nonatomic,strong) NSDate *last_checkin_date;

- (instancetype)initWithUser:(User *)user;
@end
