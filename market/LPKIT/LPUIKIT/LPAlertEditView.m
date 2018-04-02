//
//  LPAlertEditView.m
//  MDT
//
//  Created by Lipeng on 15/11/28.
//  Copyright (c) 2015年 West. All rights reserved.
//

#import "LPAlertEditView.h"

@interface LPAlertEditView()<UITextViewDelegate>
@property(nonatomic) CGRect tipFrame;
@property(nonatomic) UIView *backgroundView;
@end

@implementation LPAlertEditView

- (void)dealloc
{
    self.block = nil;
    _textView.placeHolder = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LPColor(0, 0, 0, 0.6);
        [self invokeLayoutSubviews];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)resetBackgroundColor
{
    self.backgroundColor = LPColor(0, 0, 0, 0.6);
}

- (void)invokeLayoutSubviews
{
    CGSize size = CGSizeMake(CGViewGetWidth(self)-44, 172);
    _backgroundView = LPAddClearBGSubView(self, UIView, CGRectMake(0,0,size.width,size.height));
    _backgroundView.backgroundColor = LPColor(0xff,0xff,0xff,1);
    _backgroundView.cornerRadius = 3;
    _backgroundView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)-44);
    
    CGFloat gap = 15;
    CGFloat x = gap, y = gap, width = size.width - gap*2, height = 68;
    //编辑框
    _textView = LPAddClearBGSubView(_backgroundView, UITextView, CGRectMake(x, y, width, height));
    [_textView setFont:LPFont(14) color:LPColor(51,51,51,1) alignment:NSTextAlignmentLeft];
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.backgroundColor = LPColor(250,250,250,1);
    _textView.cornerRadius = 3;
    _textView.borderColor = LPColor(219,219,219,1);
    _textView.borderWidth = LPWidthOfPx;
    _textView.delegate = self;
    //提示
    _tipFrame = CGRectMake(x, y+height,width, size.height-y-height-48);
    //取消
    height = 48, width = size.width/2, y = size.height - height;
    LPBGButton *btn = LPAddClearBGSubView(_backgroundView, LPBGButton, CGRectMake(0, y, width, height));
    [btn setBGColor:[UIColor clearColor] bgHLColor:LPColor(246,246,246,1)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:LPColor(48,169,229,1) forState:UIControlStateNormal];
//    [btn setTitleColor:LPColor(246,246,246,1) forState:UIControlStateHighlighted];
    btn.titleLabel.font = LPFont(16);
    [btn addTarget:self action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];
    //确定
    btn = LPAddClearBGSubView(_backgroundView, LPBGButton, CGRectMake(width, y, width, height));
    [btn setBGColor:[UIColor clearColor] bgHLColor:LPColor(246,246,246,1)];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:LPColor(48,169,229,1) forState:UIControlStateNormal];
//    [btn setTitleColor:LPColor(246,246,246,1) forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onDone:) forControlEvents:UIControlEventTouchUpInside];

    //分割线
    [_backgroundView drawLineAsLayer:CGRectMake(0,y,size.width,LPWidthOfPx) color:LPColor(219,219,219,1)];
    [_backgroundView drawLineAsLayer:CGRectMake(size.width/2,y,LPWidthOfPx,height) color:LPColor(219,219,219,1)];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (nil != self.superview) {
        [_textView becomeFirstResponder];
    }
}

- (void)onTap:(id)tap
{
    [self removeFromSuperview];
}

- (void)onCancel:(UIButton *)button
{
    [self removeFromSuperview];
}

- (void)onDone:(UIButton *)button
{
    _block(_textView.text);
    [self removeFromSuperview];
}

- (void)addTipLabel:(UILabel *)tipLabel
{
    tipLabel.frame = _tipFrame;
    tipLabel.numberOfLines = 1;
    [_backgroundView addSubview:tipLabel];
}

#pragma mark
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text]) {
        [self onDone:nil];
        return NO;
    }
    return YES;
}
@end