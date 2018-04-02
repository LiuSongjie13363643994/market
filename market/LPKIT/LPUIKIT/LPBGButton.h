//
//  LPBGButton.h
//  MDT
//
//  Created by Lipeng on 15/11/25.
//  Copyright (c) 2015年 West. All rights reserved.
//

#import <UIKit/UIKit.h>

//可修改背景按钮
@interface LPBGButton : UIButton
- (void)setBGColor:(UIColor *)bgColor bgHLColor:(UIColor *)bgHLColor;
- (void)setBGSColor:(UIColor *)bgColor bgSHLColor:(UIColor *)bgHLColor;
@end
