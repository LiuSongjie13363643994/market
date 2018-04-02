//
//  MasterMenu.m
//  market
//
//  Created by Lipeng on 2017/8/20.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "MasterMenu.h"

@implementation MasterMenu
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self addTapGestureWithTarget:self action:@selector(removeFromSuperview)];
        self.layer.shadowRadius=2;
        self.layer.shadowColor=kColorffffff.CGColor;
        self.layer.shadowOpacity=0.6;
    }
    return self;
}

- (void)setItems:(NSArray<NSArray *> *)items
{
    CGFloat ah=10,x=self.w-25,y=64,aw=16;
    CAShapeLayer *layer=[CAShapeLayer layer];
    layer.fillColor=kColor0000006.CGColor;
    
    CGMutablePathRef path=CGPathCreateMutable();
    CGPoint p[3]={{x,y},{x+aw/2,y+ah},{x-aw/2,y+ah}};
    CGPathAddLines(path,NULL,p,3);
    CGPathCloseSubpath(path);
    layer.path=path;
    [self.layer addSublayer:layer];
    CGPathRelease(path);
    
    
    UIView *v=self.lp_av(UIView.class,0,y+ah,100,items.count*34).lp_inx1(5);
    v.backgroundColor=kColor0000006;
    v.cornerRadius=4;
    __weak typeof(self) wself=self;
    y=0;
    for (NSInteger i=0;i<items.count;i++){
        NSArray *item=items[i];
        UIButton *btn=(UIButton *)v.lp_av(UIButton.class,0,y,v.w,34);
        [btn setTitleFont:LPFont(15) color:kColorffffff text:item[1]];
        [btn addActionBlock:^(UIButton *button) {
            wself.block(i);
            [wself removeFromSuperview];
        }];
        y+=34;
        if (i<items.count-1){
            [v drawLineAsLayer:CGRectMake(10,y,v.w-20,LPWidthOfPx) color:kColorffffff];
        }
    }
}
@end
