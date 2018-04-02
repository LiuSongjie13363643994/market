//
//  LPToastView.m
//  DU365
//
//  Created by Lipeng on 16/7/4.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import "LPToastView.h"

#define kLabelHeight    47.f
#define kLabelToBottomMargin   140.f
@interface LPToastView()
@property(nonatomic) UIImageView *iconImageView;
@property(nonatomic) UILabel *textLabel;
@end

@implementation LPToastView

- (id)initWithState:(ToastState)state text:(NSString *)text
{
    self=[super initWithFrame:CGRectMake(0,0,110.f,90.f)];
    if (self) {
        self.backgroundColor=LPColor(0x00,0x00,0x00,.6f);
        self.cornerRadius=6.f;
        
        UIImageView *iv=[[UIImageView alloc] initWithImage:[self imageWithState:state]];
        [self addSubview:iv];
        
        UILabel *la=LPAddClearBGSubView(self,UILabel,CGRectMake(0,0,0,17.f));
        [la setFont:LPFont(17) color:LPColor(0xff,0xff,0xff,1) alignment:NSTextAlignmentCenter];
        la.fitWidth=YES;
        la.text=text;

        CGFloat w=[la textWidthWhen1Line] + 42.f;
        if (w > 110.f) {
            CGViewChangeWidth(self,w);
        }
        CGViewTransX1ToMidOfView(iv,self);
        CGViewTransY(iv, LP_Float_2(CGViewGetHeight(self)-(CGViewGetHeight(iv)+15+CGViewGetHeight(la))));
        CGViewTransX1ToMidOfView(la,self);
        CGViewTransY(la,CGViewGetY2(iv)+15.f);
    }
    return self;
}

- (UIImage *)imageWithState:(ToastState)state
{
    NSArray *n=@[@"ic-toast-yes",@"ic-toast-no",@"ic-toast-t"];
    return [UIImage imageNamed:n[state]];
}

- (void)showInView:(UIView *)view
{
    self.alpha=0.f;
    [view addSubview:self];
    CGViewTransX1ToMidOfView(self, view);
    CGViewTransY1ToMidOfView(self, view);
    [UIView animateWithDuration:.2f animations:^{
        self.alpha=1.f;
    } completion:^(BOOL finished) {
        dispatch_time_t t=dispatch_time(DISPATCH_TIME_NOW, 1.f*NSEC_PER_SEC);
        dispatch_after(t, dispatch_get_main_queue(), ^{
           [UIView animateWithDuration:.1f animations:^{
               self.alpha=0.f;
           } completion:^(BOOL finished) {
               [self removeFromSuperview];
           }];
        });
    }];
}

+ (void)toast:(ToastState)state text:(NSString *)text
{
    [[[LPToastView alloc] initWithState:state text:text] showInView:[UIApplication sharedApplication].keyWindow];
}

+ (void)toastBottomText:(NSString *)text
{
    CGFloat offset = LP_Screen_Height-kLabelToBottomMargin-kLabelHeight;
    [self showOnlyText:text offset:offset];
}

+ (void)toastCenterText:(NSString *)text
{
    CGFloat offset = (LP_Screen_Height-kLabelHeight)/2.f-50.f;
    [self showOnlyText:text offset:offset];
}

+ (void)showOnlyText:(NSString *)text offset:(CGFloat)offset
{
    UIView *w=[UIApplication sharedApplication].keyWindow;
    UILabel *la=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0,kLabelHeight)];
    la.backgroundColor = LPColor(0x00,0x00,0x00,.6f);
    la.cornerRadius=5.f;
    [la setFont:LPFont(17) color:LPColor(0xff,0xff,0xff,1) alignment:NSTextAlignmentCenter];
    la.fitWidth=YES;
    la.text=text;
    la.alpha=0.0;
    [w addSubview:la];
    CGViewChangeDWidth(la, 42.f);
    CGViewTransX1ToMidOfView(la,w);
    CGViewChangeDWidth(la,15.f);
    CGViewTransY(la,offset);
    [UIView animateWithDuration:.2f animations:^{
        la.alpha=1.f;
    } completion:^(BOOL finished) {
        dispatch_time_t t=dispatch_time(DISPATCH_TIME_NOW, 1.f*NSEC_PER_SEC);
        dispatch_after(t, dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.1f animations:^{
                la.alpha=0.f;
            } completion:^(BOOL finished) {
                [la removeFromSuperview];
            }];
        });
    }];
}

@end
