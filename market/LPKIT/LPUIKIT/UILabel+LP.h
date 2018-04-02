//
//  UILabel+LP.h
//
//
//  Created by Lipeng on 15/11/15.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel(LP)
//是否根据文字自适应宽度
@property(nonatomic,assign) BOOL fitWidth;
@property(nonatomic,assign) BOOL fitHeight;
- (UILabel *)setFont:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment;
- (CGFloat)textWidthWhen1Line;
- (CGFloat)textHeightWhen0Line;
- (CGFloat)attributedTextHeightWhen0Line;
+ (void)loadSwizzling;
@end
