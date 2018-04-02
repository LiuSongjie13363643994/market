//
//  GradeView.m
//  market
//
//  Created by Lipeng on 2017/8/28.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "GradeView.h"

@interface GradeView()
@property(nonatomic,strong) NSTimer *timer;
@end

@implementation GradeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        __weak typeof(self) wself=self;
        [self addTapGestureBlock:^(UITapGestureRecognizer *gesture) {
            [wself removeFromSuperview];
        }];
    }
    return self;
}

- (void)removeFromSuperview
{
    [_timer invalidate];
    [super removeFromSuperview];
}

- (void)setGrade:(GradeLevel *)grade
{
    _grade=grade;
    self.backgroundColor=kColor0000004;
    UIView *bg=self.lp_av(UIView.class,30,60,self.w-60,0);
    bg.backgroundColor=kColorffffff;
    bg.cornerRadius=8;
    
    UILabel *la=(UILabel *)bg.lp_av(UILabel.class,0,LP_X_GAP,-1,84);
    [la setFont:LPBoldFont(34) color:kColore13f3c alignment:NSTextAlignmentCenter];
    la.attributedText=[NSAttributedString string:@[grade.level,@"级用户"]
                                          colors:@[kColore13f3c,kColorff8606]
                                           fonts:@[LPBoldFont(34),LPFont(14)]];
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
    
    
    if (grade.suggests.count>0){
        CALayer *layer=[CALayer layer];
        layer.frame=CGRectMake(0,la.y2,bg.w,(grade.suggests.count+1)*24+LP_X_2GAP);
        layer.backgroundColor=kColore13f3c.CGColor;
        [bg.layer addSublayer:layer];
        
        la=(UILabel *)bg.lp_av(UILabel.class,LP_X_GAP,la.y2+LP_X_GAP,bg.w-LP_X_2GAP,24);
        [la setFont:LPFont(14) color:kColorffffff alignment:NSTextAlignmentLeft];
        la.text=@"更多建议：";
        
        for (NSString *txt in grade.suggests){
            la=(UILabel *)bg.lp_av(UILabel.class,LP_X_GAP,la.y2,bg.w-LP_X_2GAP,24);
            [la setFont:LPFont(14) color:kColorffffff alignment:NSTextAlignmentLeft];
            la.text=txt;
        }
    }
    bg.lp_h(la.y2+LP_X_GAP);
}
@end
