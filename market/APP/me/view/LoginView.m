//
//  LoginView.m
//  market
//
//  Created by Lipeng on 2017/8/18.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "LoginView.h"
#import "AuthBaseViewController.h"
#import "NavigationProxy.h"
#import "UserService.h"

@interface LoginView()
@end

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=kColor0000006;
        [self setup];
    }
    return self;
}
- (void)setup
{
    UIView *v=self.lp_av(UIView.class,LP_X_GAP,0,self.w-LP_X_2GAP,240).lp_midy();
    v.cornerRadius=8;
    v.backgroundColor=kColorffffff;
    
    CGFloat x=LP_X_GAP,w=v.w-LP_X_2GAP;
    
    UITextField *tf=(UITextField *)v.lp_av(UITextField.class,x,LP_X_GAP,w,56);
    [tf drawBottomLine:kColordedede];
    [tf setPlaceholder:@"输入手机号" keyboardType:UIKeyboardTypePhonePad returnKeyType:UIReturnKeyDefault];
    [tf setFont:LPFont(16) color:kColor23232b alignment:NSTextAlignmentLeft];
    [tf setClearButtonMode:UITextFieldViewModeWhileEditing leftViewMode:UITextFieldViewModeAlways];
    __weak UITextField *wmbtf=tf;
    
    tf=(UITextField *)v.lp_av(UITextField.class,x,tf.y2,w,56);
    [tf drawBottomLine:kColordedede];
    [tf setPlaceholder:@"请输入验证码" keyboardType:UIKeyboardTypeNumberPad returnKeyType:UIReturnKeyDefault];
    [tf setFont:LPFont(16) color:kColor23232b alignment:NSTextAlignmentLeft];
    [tf setClearButtonMode:UITextFieldViewModeWhileEditing leftViewMode:UITextFieldViewModeAlways];
    __weak UITextField *wcptf=tf;
    
    __weak typeof(self) wself=self;
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0,0,0,56)];
    btn.fitWidth=YES;
    [btn setTitleFont:LPFont(16) color:kColor5f4f38 text:@"获取验证码"];
    [btn addActionBlock:^(UIButton *button) {
//        [wself onCaptcha:button];
        [wmbtf resignFirstResponder];
        [wcptf resignFirstResponder];
        if (wmbtf.text.length<11){
            [LPAlertView know:@"请输入正确的手机号！" block:^{
                [wmbtf becomeFirstResponder];
            }];
            return;
        }
        [[UserService shared] getCaptcha:wmbtf.text block:^(BOOL result,NSString *captcha,NSString *msg) {
            if (result){
                wcptf.text=captcha;
            } else {
                [LPAlertView know:msg block:nil];
            }
        }];
    }];
    tf.rightView=btn;
    tf.rightViewMode=UITextFieldViewModeAlways;
    
    btn=(UIButton *)v.lp_av(UIButton.class,0,tf.y2,-1,54);
//    btn.backgroundColor=kColore13f3c;
    [btn setTitleFont:LPFont(16) color:kColore13f3c text:@"现在登录"];
    [btn addActionBlock:^(UIButton *button) {
        [wmbtf resignFirstResponder];
        [wcptf resignFirstResponder];
        if (wmbtf.text.length<11){
            [LPAlertView know:@"请输入正确的手机号！" block:^{
                [wmbtf becomeFirstResponder];
            }];
            return;
        }
        if (wcptf.text.length<4){
            [LPAlertView know:@"请输入验证码！" block:^{
                [wcptf becomeFirstResponder];
            }];
            return;
        }
        __weak LPLoadingView *loading=[LPLoadingView showAsModal];
        [[UserService shared] login:wmbtf.text captcha:wcptf.text block:^(BOOL result, NSString *msg) {
            [loading stop:NO];
            if (!result){
                [LPAlertView know:msg block:nil];
                return;
            }
            [wself removeFromSuperview];
            AuthBaseViewController *abvc=[[AuthBaseViewController alloc] init];
            [[NavigationProxy shared].navigationController pushViewController:abvc animated:YES];
        }];
    }];
    
    UILabel *la=(UILabel *)v.lp_av(UILabel.class,0,btn.y2,-1,v.h-btn.y2);
    la.backgroundColor=kColore13f3c;
    [la setFont:LPFont(16) color:kColorffffff alignment:NSTextAlignmentCenter];
    la.numberOfLines=0;
    la.text=@"首次注册认证可得100积分\n积分可兑话费";
    
    
    btn=(UIButton *)self.lp_av(UIButton.class,self.w-LP_X_GAP-44,v.y-30-44,44,44);
    [btn addActionBlock:^(UIButton *button) {
        [wself removeFromSuperview];
    }];
    UIImageView *iv=(UIImageView *)btn.lp_av(UIImageView.class,10,10,24,24);
    [iv asRoundStlye:kColorffffff];
    CGPoint xy=[btn convertPoint:iv.center toView:self];
    self.lp_av(UIView.class,xy.x-LPWidthOfPx,xy.y,LPWidthOfPx*3,82).backgroundColor=kColorffffff;
    
}
@end
