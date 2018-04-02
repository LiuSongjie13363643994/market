//
//  Product.m
//  market
//
//  Created by Lipeng on 2017/8/21.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "Product.h"

@implementation Product
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"product_id":@"id"};
}
@end
