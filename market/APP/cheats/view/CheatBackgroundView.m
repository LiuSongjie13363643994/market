//
//  CheatBackgroundView.m
//  market
//
//  Created by Lipeng on 2017/8/19.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "CheatBackgroundView.h"

@interface CheatBackgroundView()
@property(nonatomic) CAGradientLayer *gradientLayer;
@end

@implementation CheatBackgroundView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        _gradientLayer=[CAGradientLayer layer];
        _gradientLayer.frame=self.bounds;
        _gradientLayer.locations=@[@0.0,@1.0];
        
        [self.layer addSublayer:_gradientLayer];
        
        int x=MAX(3,arc4random()%4);
        CGFloat w=self.w/x;
        for (int i=0;i<x;i++){
            [self addMoney:w*i max:w];
        }
    }
    return self;
}
- (void)addMoney:(CGFloat)x max:(int)max
{
    CGFloat w=20+(arc4random()%40),y=(arc4random()%(int)self.h);
    x+=(arc4random()%(int)max);
    UIImage *img=[[UIImage imageNamed:@"ic-money"] thumbImage:CGSizeMake(w,w)];
    CALayer *layer=[CALayer layer];
    layer.frame=CGRectMake(0,0,w,w);
    layer.position=CGPointMake(x,y);
    layer.contents=(__bridge id)img.CGImage;
    layer.opacity=.1;
    layer.affineTransform=CGAffineTransformMakeRotation(arc4random());
    [self.layer addSublayer:layer];
}
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    CGFloat r,g,b,a;
    [backgroundColor getRed:&r green:&g blue:&b alpha:&a];
    _gradientLayer.colors=@[(__bridge id)backgroundColor.CGColor,
                            (__bridge id)LPColor(r*255,g*255,b*255,.8).CGColor];
}
@end
