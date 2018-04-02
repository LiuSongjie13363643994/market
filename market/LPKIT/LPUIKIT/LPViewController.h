//
//  LPViewController.h
//
//
//  Created by Lipeng on 15/11/15.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPNavigationBar.h"

@interface LPViewController : UIViewController

- (UIBarButtonItem *)leftNavigationItem;
- (UIBarButtonItem *)rightNavigationItem;
@property(nonatomic,readonly) LPNavigationBar *navigationBar;
@property(nonatomic,readonly) UIView *contentView;
@property(nonatomic,readonly) CALayer *barLineLayer;
@property(nonatomic,readonly) UILabel *titleLabel;

@property(nonatomic,readonly) UIButton *leftButton;
@property(nonatomic,readonly) UIButton *rightButton;
- (CGRect)bounds;
- (CGSize)size;

//隐藏导航栏
- (void)hideNavigationBar;
- (void)showNavigationBar;
- (UIButton *)addRightNavigationTextButton:(NSString *)text;
- (UIButton *)addRightNavigationImageButton:(UIImage *)image;

- (UIButton *)addLeftNavigationTextButton:(NSString *)text;
- (UIButton *)addLeftNavigationImageButton:(UIImage *)image;

- (void)splitNavigationBar;
- (void)alphaNavigationBar:(CGFloat)h oy:(CGFloat)oy;
@end
