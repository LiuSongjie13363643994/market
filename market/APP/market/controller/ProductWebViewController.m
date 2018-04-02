//
//  ProductWebViewController.m
//  market
//
//  Created by Lipeng on 2017/8/18.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "ProductWebViewController.h"
#import "ApplyView.h"

#import "ProductService.h"
#import "MeService.h"

#define kFeedbackTipKey @"kFeedbackTipKey"

@interface ProductWebViewController ()<CAAnimationDelegate>
@property(nonatomic) UIView *censusView;
@end

@implementation ProductWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addRightNavigationImageButton:[UIImage imageNamed:@"btn-more"]];
    self.wkWebview.lp_h(self.wkWebview.h-49);
    if (nil!=_product){
        [self ready];
    } else {
        __weak typeof(self) wself=self;
        self.contentView.stateObject=[ViewStateObject initWithState:ViewState_Loading object:nil];
        [[ProductService shared] detail:_product_id block:^(BOOL result, Product *product, NSString *msg) {
            wself.contentView.stateObject=[ViewStateObject initWithState:ViewState_Done object:nil];
            if (result && nil!=wself){
                wself.product=product;
                [wself ready];
            } else {
                [wself popupViewController];
            }
        }];
    }
}

- (void)ready
{
    self.title=_product.title;
    [self startLoad];
    [self setupToolbar];
    self.censusView.hidden=YES;
    __weak typeof(self) wself=self;
    [[ProductService shared] getTracks:_product block:^(NSArray<ProductTrack *> *tracks) {
        if (nil!=tracks){
            [wself fillCensus:tracks];
        }
    }];
}

- (void)setProduct:(Product *)product
{
    _product=product;
    self.url=product.product_url;
}

- (void)setupToolbar
{
    __weak UIView *tb=self.contentView.lp_av(UIView.class,0,0,-1,49).lp_iny1(0);
    tb.backgroundColor=kColorffffff;
    [tb drawTopLine:kColore8e8e8];
    
    UIImage *img=[UIImage imageNamed:@"btn-faved"];
    __weak UIButton *btn=(UIButton *)tb.lp_av(UIButton.class,0,0,0,49);
    __weak UIImageView *iv=(UIImageView *)btn.lp_av(UIImageView.class,0,0,img.size.width,img.size.height).lp_midy();
    __weak UILabel *la=(UILabel *)btn.lp_av(UILabel.class,iv.x2+5,0,0,-1);
    [la setFont:LPFont(14) color:kColor23232b alignment:NSTextAlignmentCenter];
    la.fitWidth=YES;
    
    __weak typeof(self) wself=self;
    void (^fav_block)()=^(){
        if (wself.product.is_fav){
            iv.image=[UIImage imageNamed:@"btn-faved"];
        } else {
            iv.image=[UIImage imageNamed:@"btn-fav"];
        }
        la.text=wself.product.fav_counts_txt;
        btn.lp_w(la.x2).lp_inx1(LP_X_GAP);
    };
    fav_block();
    [btn addActionBlock:^(UIButton *button) {
        button.enabled=NO;
        if (wself.product.is_fav){
            [[MeService shared] unfav:wself.product block:^(BOOL result, NSString *msg) {
                button.enabled=YES;
                fav_block();
            }];
        } else {
            [[MeService shared] fav:wself.product block:^(BOOL result, NSString *msg) {
                button.enabled=YES;
                fav_block();
            }];
        }
    }];
    
    la=(UILabel *)tb.lp_av(UILabel.class,LP_X_GAP,0,0,-1);
    [la setFont:LPFont(14) color:kColor23232b alignment:NSTextAlignmentLeft];
    la.fitWidth=YES;
    la.text=@"申请后";
    btn=(UIButton *)tb.lp_av(UIButton.class,la.x2,0,0,-1);
    btn.fitWidth=YES;
    [btn setTitleFont:LPFont(14) color:kColore13f3c text:@"点击反馈"];
    [btn addActionBlock:^(UIButton *button) {
        __weak ApplyView *av=(ApplyView *)wself.contentView.lp_av(ApplyView.class,0,0,-1,wself.wkWebview.h);
        void (^block)()=^{
            [UIView animateWithDuration:.2f animations:^{
                av.transform=CGAffineTransformMakeTranslation(0,av.h);
            } completion:^(BOOL finished) {
                [av removeFromSuperview];
            }];
        };
        av.cancel_block=^{
            block();
        };
        av.done_block=^(NSInteger amount){
            __weak LPLoadingView *loading=[LPLoadingView showAsModal];
            [[MeService shared] apply:wself.product amount:amount block:^(BOOL result, NSString *msg) {
                [loading stop:NO];
                if (result){
                    [LPAlertView sure:msg block:block];
                } else {
                    [LPAlertView know:msg block:nil];
                }
            }];
        };
        av.transform=CGAffineTransformMakeTranslation(0,av.h);
        [UIView animateWithDuration:.2f animations:^{
            av.transform=CGAffineTransformIdentity;
        }];
        [wself.contentView bringSubviewToFront:tb];
    }];
    
    la=(UILabel *)tb.lp_av(UILabel.class,btn.x2,0,0,-1);
    [la setFont:LPFont(14) color:kColor23232b alignment:NSTextAlignmentLeft];
    la.fitWidth=YES;
    la.text=@"攒积分赚话费";
    
    if (nil==LP_ReadUserDefault(kFeedbackTipKey)){
        LP_WriteUserDefault(kFeedbackTipKey,@(1));
        __weak UIView *v=self.view.lp_av(UIView.class,0,0,-1,-1);
        v.backgroundColor=kColor0000001;
        v.layer.shadowRadius=2;
        v.layer.shadowOpacity=0.1;
        v.layer.shadowOffset=CGSizeZero;
        v.layer.shadowColor=kColore13f3c.CGColor;
        [v addTapGestureBlock:^(UITapGestureRecognizer *gesture) {
            [v removeFromSuperview];
        }];
        
        UIView *v1=v.lp_av(UIView.class,0,0,140,70).lp_iny1(44).lp_inx(LP_X_GAP);
        v1.backgroundColor=kColorffffff;
        v1.cornerRadius=8;
        UILabel *la=(UILabel *)v1.lp_av(UILabel.class,0,0,-1,-1);
        la.numberOfLines=0;
        la.textAlignment=NSTextAlignmentCenter;
        la.attributedText=[NSAttributedString string:@[@"申请后，点击反馈\n",@"攒积分赚话费"]
                                              colors:@[kColor23232b,kColore13f3c]
                                               fonts:@[LPFont(13),LPFont(17)]];
        
        CGFloat ah=10,x=CGRectGetMidX(v1.frame),y=v1.y2,aw=16;
        CAShapeLayer *layer=[CAShapeLayer layer];
        layer.fillColor=kColorffffff.CGColor;
        
        CGMutablePathRef path=CGPathCreateMutable()
        ;
        CGPoint p[3]={{x-aw/2,y},{x+aw/2,y},{x,y+ah}};
        CGPathAddLines(path,NULL,p,3);
        CGPathCloseSubpath(path);
        layer.path=path;
        [v.layer addSublayer:layer];
        CGPathRelease(path);
    }
}

- (UIView *)censusView
{
    if (nil==_censusView){
        _censusView=self.contentView.lp_av(UIView.class,0,0,self.contentView.w,140+22);
        _censusView.layer.shadowColor=kColor0000004.CGColor;
        _censusView.layer.shadowRadius=2;
        _censusView.layer.shadowOpacity=1.0f;
        _censusView.layer.shadowOffset=CGSizeZero;
        
        _censusView.lp_av(UIView.class,0,0,-1,140).backgroundColor=kColorffffff;
        __weak UIButton *btn=(UIButton *)_censusView.lp_av(UIButton.class,0,140-32,54,54).lp_midx();
        [btn asRoundStlye:kColorffffff];
        UIImageView *iv=(UIImageView *)btn.lp_av(UIImageView.class,0,27,54,27);
        iv.contentMode=UIViewContentModeCenter;
        iv.image=[UIImage imageNamed:@"btn-up"];
        
        UIView *v=_censusView.lp_av(UIView.class,0,0,0,20).lp_iny1(22);
        UILabel *la=[self prefixLabel:kColor999999 text:@"申请人数" height:20];
        [v addSubview:la];
        la.lp_midy();
        
        la=(UILabel *)[self prefixLabel:kColore13f3c text:@"放款人数" height:20].lp_inx(la.x2+10);
        [v addSubview:la];
        la.lp_midy();
        
        v.lp_w(la.x2).lp_midx();
        
        __weak NSTimer *timer=nil;
        __weak typeof(self) wself=self;
        void (^block)()=^{
            [timer invalidate];
            
            [UIView animateWithDuration:.4f animations:^{
                CGFloat h=wself.contentView.h;
                wself.censusView.transform=CGAffineTransformMakeTranslation(0,-h);
            } completion:^(BOOL finished) {
                [wself.censusView removeFromSuperview];
                wself.censusView=nil;
            }];
        };
        [btn addActionBlock:^(UIButton *button) {
            block();
        }];
        timer=[NSTimer scheduledTimerWithTimeInterval:4 repeats:NO block:^(NSTimer * _Nonnull timer) {
//            block();
        }];

    }
    return _censusView;
}

- (UILabel *)prefixLabel:(UIColor *)color text:(NSString *)text height:(CGFloat)height
{
    UILabel *la=[[UILabel alloc] initWithFrame:CGRectMake(0,0,0,height)];
    [la setFont:LPFont(12) color:color alignment:NSTextAlignmentRight];
    la.fitWidth=YES;
    la.text=text;
    la.lp_w(la.w+10);
    [la.lp_av(UIView.class,0,0,8,8).lp_midy() asRoundStlye:color];
    return la;
}
- (void)fillCensus:(NSArray<ProductTrack *> *)tracks
{
    if (0==tracks.count){
        return;
    }
    
    CGFloat max=0;
    for (ProductTrack *track in tracks){
        max=MAX(max,track.apply_counts);
        max=MAX(max,track.loan_counts);
    }
    
    NSInteger step=ceil(max/4);
    
    //画7日图
    UILabel *la;
    CGFloat w=_censusView.w-70,h=_censusView.h-22-44, gapy=h/4,y=10,x=50,gapx=w/6;
    for (int i=0;i<5;i++){
        if (i<4){
            la=(UILabel *)_censusView.lp_av(UILabel.class,0,y-10,x-4,20);
            [la setFont:LPFont(10) color:kColor23232b alignment:NSTextAlignmentRight];
            la.text=@(step*(4-i)).stringValue;
        }
        [_censusView drawLineAsLayer:CGRectMake(x,y,w,LPWidthOfPx) color:kColordedede];
        y+=gapy;
    }
    y=10;
    for (int i=0;i<7;i++){
        [_censusView drawLineAsLayer:CGRectMake(x,y,LPWidthOfPx,h) color:kColordedede];
        if (i<tracks.count){
            NSDate *date=tracks[i].date;
            la=(UILabel *)_censusView.lp_av(UILabel.class,0,0,0,14).lp_iny1(40);
            [la setFont:LPFont(10) color:kColor23232b alignment:NSTextAlignmentCenter];
            la.fitWidth=YES;
            if ([date isToday]){
                la.text=@"今天";
            } else {
                la.text=[NSString stringWithFormat:@"%@-%@",@(date.month),@(date.day)];
            }
            la.lp_inx(x-la.w/2);
        }
        x+=gapx;
    }
    
    CGPoint xy1[]={CGPointZero,CGPointZero,CGPointZero,CGPointZero,CGPointZero,CGPointZero,CGPointZero};
    CGPoint xy2[]={CGPointZero,CGPointZero,CGPointZero,CGPointZero,CGPointZero,CGPointZero,CGPointZero};
    y=10,x=50;
    for (int i=0;i<tracks.count;i++){
        ProductTrack *track=tracks[i];
        xy1[i].x=x;
        xy1[i].y=y+h*(1-(CGFloat)(track.apply_counts)/(CGFloat)max);
        
        xy2[i].x=x;
        xy2[i].y=y+h*(1-(CGFloat)(track.loan_counts)/(CGFloat)max);
        x+=gapx;
    }
    self.censusView.hidden=NO;
    [self drawLine:xy1 count:tracks.count color:kColor999999];
    [self drawLine:xy2 count:tracks.count color:kColore13f3c];
}

- (void)drawLine:(CGPoint [])xys count:(NSInteger)count color:(UIColor *)color
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSMutableArray *a=[NSMutableArray array];
    
    for (int i=0;i<count;i++){
        [a addObject:[NSValue valueWithCGPoint:xys[i]]];
        if (0==i){
            [path moveToPoint:xys[i]];
        } else {
            [path addLineToPoint:xys[i]];
            [path moveToPoint:xys[i]];
        }
    }
    
    CAShapeLayer *shaper = [CAShapeLayer layer];
    shaper.path=path.CGPath;
    shaper.frame=_censusView.bounds;
    shaper.lineWidth=1;
    shaper.strokeColor=color.CGColor;
    
    CABasicAnimation *basic=[CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    basic.fromValue=@0;
    basic.toValue=@1;
    basic.duration=1;
    basic.delegate=self;
    [shaper addAnimation:basic forKey:@"stokentoend"];
    [_censusView.layer addSublayer:shaper];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGPoint xy1[]={CGPointZero,CGPointZero,CGPointZero,CGPointZero,CGPointZero,CGPointZero,CGPointZero};
        for (int i=0;i<a.count;i++){
            xy1[i]=[a[i] CGPointValue];
        }
        [self drawCircle:xy1 count:a.count color:color];
    });
}
- (void)drawCircle:(CGPoint [])xys count:(NSInteger)count color:(UIColor *)color
{
    for (int i=0;i<count;i++){
        CALayer *layer=[CALayer layer];
        layer.frame=CGRectMake(0,0,6,6);
        layer.position=xys[i];
        layer.cornerRadius=3;
        layer.backgroundColor=kColorffffff.CGColor;
        layer.borderWidth=1;
        layer.borderColor=color.CGColor;
        [_censusView.layer addSublayer:layer];
    }
}
@end
