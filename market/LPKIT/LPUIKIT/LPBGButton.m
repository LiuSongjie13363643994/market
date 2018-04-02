//
//  LPBGButton.m
//  MDT
//
//  Created by Lipeng on 15/11/25.
//  Copyright (c) 2015年 West. All rights reserved.
//

#import "LPBGButton.h"

@interface LPBGButton()
@property(nonatomic, strong) UIColor *bgColor;
@property(nonatomic, strong) UIColor *bgHLColor;
@property(nonatomic, strong) UIColor *bgSColor;
@property(nonatomic, strong) UIColor *bgSHLColor;
@end

@implementation LPBGButton
- (void)setBGColor:(UIColor *)bgColor bgHLColor:(UIColor *)bgHLColor
{
    _bgColor = bgColor;
    _bgHLColor = bgHLColor;
}

- (void)setBGSColor:(UIColor *)bgColor bgSHLColor:(UIColor *)bgHLColor
{
    _bgSColor = bgColor;
    _bgSHLColor = bgHLColor;
}

- (void)setHighlighted:(BOOL)highlighted
{
    super.highlighted = highlighted;
    if (self.selected) {
        self.backgroundColor = !highlighted ? _bgSColor : _bgSHLColor;
    } else {
        self.backgroundColor = !highlighted ? _bgColor : _bgHLColor;
    }
}

- (void)setSelected:(BOOL)selected
{
    super.selected = selected;
    self.backgroundColor = selected ? _bgSColor : _bgColor;
}

@end
