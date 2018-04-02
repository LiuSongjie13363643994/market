//
//  ScoreItem.m
//  market
//
//  Created by 刘松杰 on 2018/3/31.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import "ScoreItem.h"

@implementation ScoreItem
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"item_id":@"id"};
}
@end
