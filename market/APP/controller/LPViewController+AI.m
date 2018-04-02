//
//  LPViewController+AI.m
//  market
//
//  Created by Lipeng on 2017/8/18.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "LPViewController+AI.h"
#import "AuthBaseViewController.h"
#import "PersonInfoViewController.h"
#import "LSNavigationController.h"

#import "RegisterViewController.h"
#import "LoginView.h"

#import "UserService.h"
#import "SysService.h"

#define kMax_free_times_Key @"kMax_free_times_Key"

@implementation LPViewController(AI)
- (BOOL)checkLogin:(void (^)(void))block 
{
    __weak typeof (self) wself = self;
    RegisterViewController *rvc = [[RegisterViewController alloc] init];
    rvc.loginBlock = ^{
        [wself completeUserInfo];
    };
    if (YES == [SysService shared].configure.has_user) {
        if ([SysService shared].configure.need_login) {
            if (![UserService shared].logined){
                if (self.navigationController) {
                    [self.navigationController presentViewController:[[LSNavigationController alloc] initWithRootViewController:rvc] animated:YES completion:nil];
                } else {
                    [self presentViewController:rvc animated:YES completion:nil];
                }
                return NO;
            } else {
                block();
                return YES;
            }
        } else {
            if ([UserService shared].logined) {
                block();
                return YES;
            } else {
                int max_free_times = [LP_ReadUserDefault(kMax_free_times_Key) intValue];
                if ([SysService shared].configure.max_free_times != 0 && 0 == max_free_times) {
                    if (self.navigationController) {
                        [self.navigationController presentViewController:[[LSNavigationController alloc] initWithRootViewController:rvc] animated:YES completion:nil];
                    } else {
                        [self presentViewController:rvc animated:YES completion:nil];
                    }
                }
                if (max_free_times > 0) {
                    max_free_times--;
                    LP_WriteUserDefault(kMax_free_times_Key, @(max_free_times));
                    block();
                }
                return NO;
            }
        }
    } else {
        block();
        return YES;
    }
}

- (BOOL)instantCheckLogin:(void (^)(void))block
{
    __weak typeof (self) wself = self;
    RegisterViewController *rvc = [[RegisterViewController alloc] init];
    rvc.loginBlock = ^{
        [wself completeUserInfo];
    };
    if (![UserService shared].logined) {
        if (self.navigationController) {
            [self.navigationController presentViewController:[[LSNavigationController alloc] initWithRootViewController:rvc] animated:YES completion:nil];
        } else {
            [self presentViewController:[[LSNavigationController alloc] initWithRootViewController:rvc] animated:YES completion:nil];
        }
        return NO;
    } else {
        block();
        return YES;
    }
}

- (void)completeUserInfo
{
    if (0 == [SysService shared].configure.project && 0 == [UserService shared].user.name.length) {
        [self pushViewController:[[AuthBaseViewController alloc] init]];
//        [self presentViewController:[[AuthBaseViewController alloc] init] animated:YES completion:nil];
    } else if (![UserService shared].user.user_info){
        [self pushViewController:[[PersonInfoViewController alloc] init]];
//         [self presentViewController:[[PersonInfoViewController alloc] init] animated:YES completion:nil];
    }
}

//是否填写个人资料
- (BOOL)checkAuthed:(void (^)(void))block
{
    if ([UserService shared].authed){
        block();
        return YES;
    }
    [self pushViewController:[[AuthBaseViewController alloc] init]];
    return NO;
}
- (void)b_viewDidLoad
{
    [self b_viewDidLoad];
    self.view.backgroundColor=kColorf4f5f6;
    self.titleLabel.textColor=kColorffffff;
    self.titleLabel.font=LPBoldFont(19.f);
    self.navigationBar.backgroundColor=kColore13f3c;
    self.barLineLayer.backgroundColor=kColore13f3c.CGColor;
    
    CGFloat w=LP_Screen_Width/5;
    for (int i=0;i<5;i++){
        [self addMoney:w*i max:w view:self.navigationBar];
    }
    
    UILabel *la=(UILabel *)self.contentView.lp_av(UILabel.class,0,0,-1,34);
    ((UILabel *)la.lp_inx1(0).lp_iny1(0)).text=@"全网速贷";
    la.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [la setFont:LPFont(14) color:kColore7e7e7 alignment:NSTextAlignmentCenter];
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
- (UIButton *)b_addRightNavigationTextButton:(NSString *)text
{
    UIButton *btn=[self b_addRightNavigationTextButton:text];
    [btn setTitleFont:LPFont(17) color:kColorffffff text:text];
    btn.lp_w(btn.titleLabel.w).lp_inx1(LP_X_GAP);
    return btn;
}
+ (void)loadSwizzling
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SwizzleSelector(class, @selector(viewDidLoad), @selector(b_viewDidLoad));
        SwizzleSelector(class, @selector(addRightNavigationTextButton:), @selector(b_addRightNavigationTextButton:));
//        SwizzleSelector(class, @selector(addLeftNavigationTextButton:), @selector(b_addLeftNavigationTextButton:));
    });
}
@end
