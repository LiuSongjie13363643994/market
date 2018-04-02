//
//  LPViewController.m
//
//
//  Created by Lipeng on 15/11/15.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import "LPViewController.h"
#import "LPFDKit.h"
#import "LPContentView.h"

@interface LPViewController ()
@property(nonatomic, assign) CGFloat navHieght;
@property(nonatomic, assign) BOOL spliting;
@end

@implementation LPViewController

- (void)dealloc
{
    LP_RemoveObserver(self);
}

- (void)loadView
{
    [super loadView];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    CGFloat h = (iPhoneX ? 84 : 64);
    _navigationBar = (LPNavigationBar *)self.view.lp_av(LPNavigationBar.class, 0, 0, -1, h);
    _barLineLayer = [self.navigationBar.barView drawBottomLine:[UIColor clearColor]];
    
    _contentView = self.view.lp_av(LPContentView.class, 0, h, -1, -1);
    _contentView.clipsToBounds = NO;
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    [self.view sendSubviewToBack:_contentView];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    self.view.backgroundColor = nil;
    self.view.clipsToBounds = YES;
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem  = [self leftNavigationItem];
    self.navigationItem.rightBarButtonItem = [self rightNavigationItem];
    
    UIView *barView = self.navigationBar.barView;
    _titleLabel = (UILabel *)barView.lp_av(UILabel.class, 44, 0, barView.w - 88, -1);
    [_titleLabel setFont:LPFont(19.f) color:LPColor(0xff,0xff,0xff,1) alignment:NSTextAlignmentCenter];
}

- (UIBarButtonItem *)leftNavigationItem
{
    return nil;
}

- (UIBarButtonItem *)rightNavigationItem
{
    return nil;
}

- (void)hideNavigationBar
{
    _navigationBar.hidden = YES;
    _contentView.frame = CGViewGetBounds(self.view);
}

- (void)showNavigationBar
{
    _spliting = NO;
    _navigationBar.hidden = NO;
    _navigationBar.alpha = 1;
    if (_leftButton){
        [_navigationBar addSubview:_leftButton];
    }
    if (_rightButton){
        [_navigationBar addSubview:_rightButton];
    }
    _contentView.lp_iny(_navHieght).lp_h(self.view.h - _navHieght);
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text=title;
}
- (void)setTitleColor:(UIColor *)titleColor
{
    _titleLabel.textColor=titleColor;
}
- (UIColor *)titleColor
{
    return _titleLabel.textColor;
}
- (UIButton *)addLeftNavigationTextButton:(NSString *)text
{
    [_leftButton removeFromSuperview];
    UIView *barview=self.navigationBar.barView;
    UIButton *btn=(UIButton *)barview.lp_av(UIButton.class,LP_X_GAP,0,0,44);
    btn.fitWidth=YES;
    [btn setTitleFont:LPFont(17) color:LPColor(0x33,0x33,0x33,1) text:text];
    _leftButton=btn;
    return btn;
}
- (UIButton *)addLeftNavigationImageButton:(UIImage *)image
{
    [_leftButton removeFromSuperview];
    UIView *barview = self.navigationBar.barView;
    UIButton *btn = (UIButton *)barview.lp_av(UIButton.class, 0, 0, 44, 44);
    btn.lp_inx(LP_X_GAP - (22 - image.size.width / 2));
    [btn setImage:image forState:UIControlStateNormal];
    _leftButton = btn;
    return btn;
}
- (UIButton *)addRightNavigationTextButton:(NSString *)text
{
    [_rightButton removeFromSuperview];
    UIView *barview=self.navigationBar.barView;
    UIButton *btn=(UIButton *)barview.lp_av(UIButton.class,0,0,0,44);
    btn.fitWidth=YES;
    [btn setTitleFont:LPFont(17) color:LPColor(0x33,0x33,0x33,1) text:text];
    btn.lp_inx1(LP_X_GAP);
    _rightButton=btn;
    return btn;
}
- (UIButton *)addRightNavigationImageButton:(UIImage *)image
{
    [_rightButton removeFromSuperview];
    UIView *barview = self.navigationBar.barView;
    UIButton *btn = (UIButton *)barview.lp_av(UIButton.class, 0, 0, 44, 44);
    btn.lp_inx1(LP_X_GAP - (22 - image.size.width / 2));
    [btn setImage:image forState:UIControlStateNormal];
    _rightButton = btn;
    return btn;
}
- (void)splitNavigationBar
{
    _spliting=YES;
    self.navigationBar.hidden=NO;
    self.navigationBar.alpha=0;
    if (nil!=_rightButton){
        [self.view addSubview:_rightButton];
    }
    if (nil!=_leftButton){
        [self.view addSubview:_leftButton];
    }
}
- (void)alphaNavigationBar:(CGFloat)h oy:(CGFloat)oy
{
    if (_spliting){
        CGFloat ay=h-self.navigationBar.h;
        if (oy>=ay) {
            self.navigationBar.alpha=1;
        } else if (oy>0){
            self.navigationBar.alpha=oy/ay;
        } else {
            self.navigationBar.alpha=0;
        }
    }
}
- (CGRect)bounds
{
    return CGViewGetBounds(self.contentView);
}
- (CGSize)size
{
    return self.bounds.size;
}
@end
