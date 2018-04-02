//
//  AppCreditView.m
//  market
//
//  Created by Lipeng on 2017/8/26.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "AppCreditView.h"

@interface AppCreditView()
@property(nonatomic,strong) NSTimer *timer;
@end

@implementation AppCreditView

- (void)removeFromSuperview
{
    [_timer invalidate];
    [super removeFromSuperview];
}

- (void)setProduct:(Product *)product
{
    _product=product;
    
    self.backgroundColor=kColor0000004;
    UIView *bg=self.lp_av(UIView.class,30,60,self.w-60,0);
    bg.backgroundColor=kColorffffff;
    bg.cornerRadius=8;
    
    UIImageView *iv=(UIImageView *)bg.lp_av(UIImageView.class,0,LP_X_GAP,54,54).lp_midx();
    iv.cornerRadius=8;
    iv.borderWidth=LPWidthOfPx;
    iv.borderColor=kColorcccccc;
    iv.backgroundColor=kColorf2f2f2;
    [iv sd_setImageWithURL:[NSURL URLWithString:product.icon_url]];
    
    UILabel *la=(UILabel *)bg.lp_av(UILabel.class,0,iv.y2,-1,34);
    [la setFont:LPFont(14) color:kColor23232b alignment:NSTextAlignmentCenter];
    la.text=_product.title;
    
    la=(UILabel *)bg.lp_av(UILabel.class,0,la.y2,-1,44);
    [la setFont:LPFont(24) color:product.is_to_credit?kColorff0000:kColorbad8e3 alignment:NSTextAlignmentCenter];
    la.text=product.is_to_credit?@"要上征信(* ￣︿￣)":@"不上征信✌️";
    
    __block int i=0;
    __weak typeof(la) wla=la;
    _timer=[NSTimer scheduledTimerWithTimeInterval:.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (i>=8){
            wla.transform=CGAffineTransformIdentity;
            [timer invalidate];
            return;
        }
        wla.transform=(0==((++i)%2))?CGAffineTransformMakeScale(.8,.8):CGAffineTransformIdentity;
    }];
    
    __weak typeof(self) wself=self;
    
    CGFloat y=la.y2;
    if (product.is_valid){
        UIButton *btn=(UIButton *)bg.lp_av(UIButton.class,LP_X_GAP,la.y2+10,bg.w-LP_X_2GAP,34);
        [btn asRoundStlye:kColore13f3c];
        [btn setTitleFont:LPFont(16) color:kColorffffff text:@"立即申请"];
        [btn addActionBlock:^(UIButton *button) {
            [wself removeFromSuperview];
            wself.apply_block(wself.product);
        }];
        y=btn.y2;
    }
    
    UIButton *btn=(UIButton *)bg.lp_av(UIButton.class,LP_X_GAP,y+10,bg.w-LP_X_2GAP,34);
    [btn asRoundStlye:kColorffffff];
    [btn setTitleFont:LPFont(16) color:kColore13f3c text:@"查询其他"];
    btn.borderColor=kColore13f3c;
    btn.borderWidth=1;
    [btn addActionBlock:^(UIButton *button) {
        [wself removeFromSuperview];
    }];
    
    bg.lp_h(btn.y2+30);
}

@end
