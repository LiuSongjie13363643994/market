//
//  IconViewController.m
//  market
//
//  Created by Lipeng on 2017/8/20.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "IconViewController.h"

@interface IconViewController ()

@end

@implementation IconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *v=self.contentView.lp_av(UIView.class,0,10,400,400);
    CAGradientLayer *layer=[CAGradientLayer layer];
    layer.frame=v.bounds;
    layer.locations=@[@0.0,@1.0];
    layer.colors=@[(__bridge id)kColore13f3c.CGColor,(__bridge id)kColore13f3c.CGColor];
    [v.layer addSublayer:layer];
    
    for (int i=0;i<10;i++){
        [self addMoney:40*i max:40 view:v];
    }
    
    UIImageView *iv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-icon"]];
    [v addSubview:iv];
    iv.layer.shadowColor=kColorff8606.CGColor;
    iv.layer.shadowOpacity=.8;
    iv.layer.shadowRadius=8;
    iv.lp_midx().lp_midy();
}

- (void)addMoney:(CGFloat)x max:(int)max view:(UIView *)v
{
    CGFloat w=20+(arc4random()%40),y=(arc4random()%(int)v.h);
    x+=(arc4random()%(int)max);
    UIImage *img=[[UIImage imageNamed:@"ic-money"] thumbImage:CGSizeMake(w,w)];
    CALayer *layer=[CALayer layer];
    layer.frame=CGRectMake(0,0,w,w);
    layer.position=CGPointMake(x,y);
    layer.contents=(__bridge id)img.CGImage;
    layer.opacity=.1;
    layer.affineTransform=CGAffineTransformMakeRotation(arc4random());
    [v.layer addSublayer:layer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
