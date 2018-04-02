//
//  TouTiaoTableViewCell.h
//  market
//
//  Created by 刘松杰 on 2018/3/24.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import "AITableViewCell.h"
#import "TouTiao.h"

@interface TouTiaoTableViewCell : AITableViewCell
@property(nonatomic,strong) TouTiao *toutiao;
+ (CGFloat)height;

@end
