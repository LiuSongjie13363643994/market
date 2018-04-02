//
//  Ad.h
//  market
//
//  Created by Lipeng on 2017/8/27.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
enum{
    kAdClickType_Product=1,
    kAdClickType_Inner=2,
    kAdClickType_Outer=3,
};

@interface Ad : NSObject
@property(nonatomic,assign) NSInteger ad_id;
@property(nonatomic,assign) NSInteger click_type;
@property(nonatomic,copy) NSString *image_url;
@property(nonatomic,copy) NSString *icon_url;
@property(nonatomic,copy) NSString *tip_text;
@property(nonatomic,copy) NSString *click_url;
@property(nonatomic,assign) NSInteger product_id;
@property(nonatomic,assign) BOOL need_login;
@end
