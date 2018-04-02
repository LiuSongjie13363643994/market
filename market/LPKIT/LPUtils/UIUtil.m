//
//  UIUtil.m
//
//
//  Created by Lipeng on 15/11/16.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import "UIUtil.h"
#import "NSString+LP.h"

@implementation UIUtil
+ (CGFloat)testHeightWithFont:(UIFont *)font
{
    return [@"测试" lpSizeWithFont:font].height;
}
@end
