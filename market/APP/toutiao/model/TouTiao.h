//
//  TouTiao.h
//  market
//
//  Created by 刘松杰 on 2018/3/24.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouTiao : NSObject
@property(nonatomic,assign) NSInteger product_id;
@property(nonatomic,copy) NSString *image_url;
@property(nonatomic,copy) NSString *tt_url;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *source;
@property(nonatomic,strong) NSDate *date;
@property(nonatomic,copy) NSString *read_counts;
@end
