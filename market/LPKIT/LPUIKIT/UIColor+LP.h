//
//  UIColor+LP.h
//  DU365
//
//  Created by xuyuqiang on 16/7/21.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LP)
//从十六进制字符串获取颜色，
+ (UIColor *)colorWithHexString:(NSString *)color;

//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
