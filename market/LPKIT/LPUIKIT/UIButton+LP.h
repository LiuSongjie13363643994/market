//
//  UIButton+LP.h
//  DU365
//
//  Created by Lipeng on 16/6/21.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton(LP)
@property(nonatomic,assign) BOOL fitWidth;
- (void)setTitleFont:(UIFont *)font;
- (void)setTitleFont:(UIFont *)font color:(UIColor *)color text:(NSString *)title;
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;
- (void)maskColor:(UIColor *)color;
- (UIButton *)addActionBlock:(void (^)(UIButton *button))block;
@end
