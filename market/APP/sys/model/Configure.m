//
//  Configure.m
//  market
//
//  Created by Lipeng on 2017/8/21.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "Configure.h"

@implementation Configure
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"topics":Topic.class,
             @"supplies":NSString.class,
             @"banner_ads":Ad.class};
}
@end
