//
//  ScoreItem.h
//  market
//
//  Created by 刘松杰 on 2018/3/31.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreItem : NSObject
@property(nonatomic,assign) int item_id;
@property(nonatomic,copy) NSString *image_url;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *price_txt;
@property(nonatomic,copy) NSString *count_txt;
@end
