//
//  Product.h
//  market
//
//  Created by Lipeng on 2017/8/21.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property(nonatomic,assign) NSInteger product_id;
//标题
@property(nonatomic,copy) NSString *title;
//icon
@property(nonatomic,copy) NSString *icon_url;
//产品地址
@property(nonatomic,copy) NSString *product_url;
//最高额度
@property(nonatomic,copy) NSString *max_amount_txt;
//放款用时
@property(nonatomic,copy) NSString *loan_time_txt;
//利率
@property(nonatomic,copy) NSString *interest_txt;
//认证项
@property(nonatomic,copy) NSString *auth_txt;
//宣传语
@property(nonatomic,copy) NSString *slogan;
//提示文本
@property(nonatomic,copy) NSString *tip_txt;
//收藏次数
@property(nonatomic,copy) NSString *fav_counts_txt;
//是否上征信
@property(nonatomic,assign) BOOL is_to_credit;
//是否有效
@property(nonatomic,assign) BOOL is_valid;
//是否收藏
@property(nonatomic,assign) BOOL is_fav;
@end
