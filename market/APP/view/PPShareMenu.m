//
//  PPShareMenu.m
//  ppablum
//
//  Created by Lipeng on 2018/1/2.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import "PPShareMenu.h"
#import "PPShareButton.h"
@interface PPShareMenu()<UIGestureRecognizerDelegate>
@property(nonatomic) UIView *actionView;
@property(nonatomic) UIView *row1View;
@property(nonatomic) UIView *row2View;

@property(nonatomic, copy) share_block share_block;
@end

@implementation PPShareMenu
- (void)dealloc
{
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = kColor0000006;
        self.alpha = 0.f;
        __weak typeof(self) wself = self;
        [self addTapGestureBlock:^(UITapGestureRecognizer *gesture) {
            [wself removeFromSuperview];
        }].delegate = self;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (nil == _actionView) {
        self.actionView.transform = CGAffineTransformMakeTranslation(0, _actionView.h);
        for (UIView *v in _row1View.subviews) {
            v.transform = CGAffineTransformMakeTranslation(0, _row1View.h - v.y);
        }
        for (UIView *v in _row2View.subviews) {
            v.transform = CGAffineTransformMakeTranslation(0, _row2View.h - v.y);
        }
        
        [UIView animateWithDuration:0.2f animations:^{
            self.alpha = 1.f;
            self.actionView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            for (int i = 0; i < _row1View.subviews.count; i++) {
                UIView *v = _row1View.subviews[i];
                [UIView animateWithDuration:.2f animations:^{
                    v.transform = CGAffineTransformMakeTranslation(0,-2.f * (i + 1));
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.05f animations:^{
                        v.transform = CGAffineTransformIdentity;
                    }];
                }];
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.02f]];
            }
            for (int i = 0; i < _row2View.subviews.count; i++) {
                UIView *v = _row2View.subviews[i];
                [UIView animateWithDuration:.2f animations:^{
                    v.transform = CGAffineTransformMakeTranslation(0, -2.f * (i + 1));
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.05f animations:^{
                        v.transform=CGAffineTransformIdentity;
                    }];
                }];
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.02f]];
            }
        }];
    }
}

- (UIView *)barAtY:(CGFloat)y withItems:(NSArray *)items
{
    CGFloat h = (54 + [PPShareButton size].height);
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.w, h)];
    v.clipsToBounds = YES;
    CGFloat x = LP_X_GAP,w = [PPShareButton size].width;
    y = 27.f;
    h = [PPShareButton size].height;
    __weak typeof(self) wself = self;
    for (int i = 0; i < items.count; i++) {
        PPShareButton *sib = (PPShareButton *)v.lp_av(PPShareButton.class, x, y ,w ,h);
        sib.tag=[items[i][2] integerValue];
        [sib addActionBlock:^(UIButton *button) {
            PPShareButton *sib = (PPShareButton *)button;
            wself.share_block(sib.tag, sib.text);
            [wself removeFromSuperview];
        }];
        [sib setImage:[UIImage imageNamed:items[i][0]] text:items[i][1]];
        x = sib.x2;
    }
    return v;
}

- (UIView *)actionView
{
    if (nil == _actionView) {
        CGFloat h1 = (54 + [PPShareButton size].height), h2 = h1 + 50;
        UIView *bgv = self.lp_av(UIView.class, 0, 0, -1, h2).lp_iny1(0);
        bgv.backgroundColor = kColorffffff;
        NSArray *a=@[@[@"gx_dt_wx", @"微信", @(kPPShare_WX_Session)],
                     @[@"gx_dt_pyq", @"朋友圈",@(kPPShare_WX_TimeLine)],
                     @[@"gx_dt_qq", @"QQ",@(kPPShare_QQ)],];
        
        _row1View=[self barAtY:0 withItems:a];
        [bgv addSubview:_row1View];
        
        //
        CGFloat x = LP_X_GAP,y = _row1View.y, w = bgv.w - LP_X_2GAP,h = LPWidthOfPx;
        if (a.count > 0) {
            [bgv drawLineAsLayer:CGRectMake(x, y, w, h) color:LPColor(0xdd,0xdd,0xdd,1)];
        }
        
        UIButton *btn = (UIButton *)bgv.lp_av(UIButton.class, 0, 0, -1, 50.f).lp_iny1(0);
        [btn drawTopLine:kColore1e1e1];
        [btn setTitleFont:LPFont(19.f) color:kColor717171 text:@"取消"];
        __weak typeof(self) wself = self;
        [btn addActionBlock:^(UIButton *button) {
            [wself removeFromSuperview];
        }];
        _actionView = bgv;
    }
    return _actionView;
}

- (void)removeFromSuperview
{
    [UIView animateWithDuration:.2f animations:^{
        self.actionView.transform = CGAffineTransformMakeTranslation(0,CGViewGetHeight(_actionView));
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

#pragma mark
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return NO;
    }
    return [gestureRecognizer locationInView:_actionView].y < 0;
}

+ (void)show:(share_block)block
{
    UIView *win = [UIApplication sharedApplication].keyWindow;
    PPShareMenu *sv = [[PPShareMenu alloc] initWithFrame:win.bounds];
    sv.share_block = block;
    [win addSubview:sv];
}

@end
