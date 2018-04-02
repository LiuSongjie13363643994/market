//
//  ScoreItmeTableViewCell.h
//  market
//
//  Created by 刘松杰 on 2018/3/31.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import "AITableViewCell.h"
#import "ScoreItem.h"
@interface ScoreItmeTableViewCell : AITableViewCell
@property(nonatomic, strong) ScoreItem *item;
+ (CGFloat)cellHeight;
@end
