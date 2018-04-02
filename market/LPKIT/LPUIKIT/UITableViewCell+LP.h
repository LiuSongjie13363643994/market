//
//  UITableViewCell+LP.h
//
//
//  Created by Lipeng on 15/11/15.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell(LP)
//初始化显示样式
- (void)initAppearanceStyles;
//布局subviews
- (void)invokeLayoutSubviews;
//填充内容
- (void)invokeFillSubviews;
//分割线颜色
- (UIColor *)separatorColor;
- (CGSize)contentSize;
//分割线
@property(nonatomic,weak,readonly) UIView *separatorView;

+ (void)loadSwizzling;
@end
