//
//  Configure.h
//  market
//
//  Created by Lipeng on 2017/8/21.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"
#import "Topic.h"
#import "Ad.h"
#import "ShareConfig.h"

@interface Configure : NSObject
//用户协议
@property(nonatomic,copy,readonly) NSString *protocol_url;
//积分规则
@property(nonatomic,copy,readonly) NSString *score_url;

@property(nonatomic,assign,readonly) BOOL has_user;
@property(nonatomic,assign,readonly) BOOL need_login;
@property(nonatomic,assign,readonly) int max_free_times;

@property(nonatomic,strong,readonly) Ad *splash_ad;
@property(nonatomic,strong,readonly) NSArray<Topic *> *topics;
@property(nonatomic,strong,readonly) NSArray<NSString *> *supplies;

@property(nonatomic,strong,readonly) NSArray<Ad *> *banner_ads;
@property(nonatomic,strong,readonly) NSString *fast_url;
@property(nonatomic,strong,readonly) Contact *contact;
@property(nonatomic,copy,readonly) NSString *register_tip;
@property(nonatomic,copy,readonly) NSString *day_tip;

//模式：0 贷超 1 头条 2 工作
@property(nonatomic,assign,readonly) int project;
//分享
@property(nonatomic,strong,readonly) ShareConfig *share;

@end
