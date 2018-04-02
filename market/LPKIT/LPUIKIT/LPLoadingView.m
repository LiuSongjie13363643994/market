//
//  LPLoadingView.m
//  DU365
//
//  Created by Lipeng on 16/7/16.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import "LPLoadingView.h"

@implementation LPLoadingView
- (id)init
{
    if (self=[super initWithFrame:CGRectMake(0,0,110.f,90.f)]) {
        self.backgroundColor=LPColor(0x00,0x00,0x00,.8f);
        self.cornerRadius=6.f;
        UIActivityIndicatorView *aiv=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        CGViewTransX1ToMidOfView(aiv, self);
        CGViewTransY1ToMidOfView(aiv, self);
        [self addSubview:aiv];
        [aiv startAnimating];
    }
    return self;
}
- (void)stop:(BOOL)animated
{
    if (!animated) {
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled=YES;
        [self removeFromSuperview];
    } else {
        [UIView animateWithDuration:.2f animations:^{
            self.alpha=0.f;
        } completion:^(BOOL finished) {
            [UIApplication sharedApplication].keyWindow.userInteractionEnabled=YES;
            [self removeFromSuperview];
        }];
    }
}
+ (LPLoadingView *)show
{
    UIView *v=[LPUIProxy shared].navigationController.view;
    LPLoadingView *LV=[[LPLoadingView alloc] init];
    [v addSubview:LV];
    LV.lp_midx().lp_midy();
    return LV;
}

+ (LPLoadingView *)showAsModal
{
    return [self showAsModal:[LPUIProxy shared].navigationController.view];
}

+ (LPLoadingView *)showAsModal:(UIView *)view
{
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled=NO;
    UIView *v=view;
    LPLoadingView *LV=[[LPLoadingView alloc] init];
    [v addSubview:LV];
    LV.lp_midx().lp_midy();
    return LV;
}

@end
