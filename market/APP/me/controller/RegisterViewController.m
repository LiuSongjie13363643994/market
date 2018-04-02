//
//  RegisterViewController.m
//  market
//
//  Created by 刘松杰 on 2018/3/24.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserProtocolViewController.h"
#import "SysService.h"
#import "UserService.h"

@interface RegisterViewController ()<UITextFieldDelegate, UIScrollViewDelegate>
@property(nonatomic) UITextField *textFiled;
@property(nonatomic) CALayer *layer1;
@property(nonatomic) CALayer *layer2;
@property(nonatomic) CALayer *layer3;
@end

@implementation RegisterViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setBackgroundColor:[UIColor clearColor]];
    self.barLineLayer.backgroundColor = [UIColor clearColor].CGColor;
    __weak typeof(self) wself = self;
    [[self addLeftNavigationTextButton:@"取消"] addActionBlock:^(UIButton *button){
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        [wself.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UITableView *tv = LPAddPlainTableView(self.contentView, UITableView, YES, self.contentView.bounds);
    [tv addTapGestureBlock:^(UITapGestureRecognizer *gesture) {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    }];
    tv.tableHeaderView = self.headView;
}

- (UIView *)headView
{
    __weak typeof(self) wself = self;
    UIView *hv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.w, self.contentView.h)];
    CGFloat x = LP_X_GAP, w = hv.w - LP_X_2GAP;
    UILabel *la = (UILabel *)hv.lp_av(UILabel.class, x, 39, w, LPFontHeight(25));
    [la setFont:LPFont(25) color:kColor000000 alignment:NSTextAlignmentLeft];
    la.text = @"手机号码登录";
    
    __block UITextField *mobile_tf = (UITextField *)hv.lp_av(UITextField.class, x, la.y2 + 30, w, 54);
    mobile_tf.tag = 1;
    mobile_tf.delegate = self;
    mobile_tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [mobile_tf setFont:LPFont(18) color:kColor000000 alignment:NSTextAlignmentLeft];
    _layer1 = [mobile_tf drawBottomLine:kColor000000];
    [mobile_tf setPlaceholder:@"请填写手机号码" keyboardType:UIKeyboardTypePhonePad returnKeyType:UIReturnKeyDefault];
    
    __block UITextField *captcha_tf = (UITextField *)hv.lp_av(UITextField.class, x, mobile_tf.y2, w, 54);
    captcha_tf.tag = 2;
    captcha_tf.delegate = self;
    captcha_tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [captcha_tf setFont:LPFont(18) color:kColor000000 alignment:NSTextAlignmentLeft];
    _layer2 = [captcha_tf drawBottomLine:kColor000000];
    [captcha_tf setPlaceholder:@"请输入验证码" keyboardType:UIKeyboardTypeNumberPad returnKeyType:UIReturnKeyDefault];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 54)];
    btn.fitWidth = YES;
    [btn setTitleFont:captcha_tf.font color:kColor000000 text:@"获取验证码"];
    [btn addActionBlock:^(UIButton *button) {
        if ([wself checkTelNumber:mobile_tf.text]) {
            [[UserService shared] getCaptcha:mobile_tf.text block:^(BOOL result, NSString *captcha, NSString *msg) {
                [LPAlertView tip:msg];
            }];
        } else {
            [LPAlertView know:@"您输入电话号码格式不对" block:nil];
        }
    }];
    captcha_tf.rightView = btn;
    captcha_tf.rightViewMode = UITextFieldViewModeAlways;
    
    UIButton* checkBtn = (UIButton *)hv.lp_av(UIButton.class, captcha_tf.x, captcha_tf.y2+15, 20, 20);
    [checkBtn setImage:[UIImage imageNamed:@"login_check_n"] forState:UIControlStateNormal];
    [checkBtn setImage:[UIImage imageNamed:@"login_check_y"] forState:UIControlStateSelected];
    checkBtn.selected = YES;
    [checkBtn addActionBlock:^(UIButton *button) {
        button.selected = !button.selected;
    }];
    
    btn = (UIButton *)hv.lp_av(UIButton.class, checkBtn.x2+10, checkBtn.y, 0, 20);
    btn.fitWidth = YES;
    [btn setTitleFont:LPFont(15) color:[UIColor redColor] text:@"阅读并同意《用户使用协议》"];
    [btn addActionBlock:^(UIButton *button) {
        UserProtocolViewController *uvc = [[UserProtocolViewController alloc] init];
        uvc.url = [SysService shared].configure.protocol_url;
        [wself pushViewController:uvc];
    }];
    
    btn = (UIButton *)hv.lp_av(UIButton.class, x, checkBtn.y2 + 47, w, 47);
    btn.cornerRadius = 4;
    btn.backgroundColor = [UIColor redColor];
    [btn setTitleFont:LPFont(17) color:kColorffffff text:@"现在登录"];
    [btn addActionBlock:^(UIButton *button) {
        [[UserService shared] login:mobile_tf.text captcha:captcha_tf.text block:^(BOOL result, NSString *msg) {
            if (result) {
                [wself.navigationController dismissViewControllerAnimated:YES completion:^{
                    if (wself.loginBlock) {
                        wself.loginBlock();
                    }
                }];
            }
        }];
    }];
    
    la = (UILabel *)hv.lp_av(UILabel.class, 0, 0, hv.w, 10);
    [la setFont:LPFont(15) color:kColor000000 alignment:NSTextAlignmentCenter];
    la.lp_iny1(30);
    la.text = [SysService shared].configure.register_tip;
    return hv;
}

//改变输入框底部线条的颜色
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (1 == textField.tag) {
        _layer1.backgroundColor = [UIColor redColor].CGColor;
        _layer2.backgroundColor = kColor000000.CGColor;
        _layer3.backgroundColor = kColor000000.CGColor;
    } else if (2 == textField.tag) {
        _layer1.backgroundColor = kColor000000.CGColor;
        _layer2.backgroundColor = [UIColor redColor].CGColor;
        _layer3.backgroundColor = kColor000000.CGColor;
    } else if (3 == textField.tag) {
        _layer1.backgroundColor = kColor000000.CGColor;
        _layer2.backgroundColor = kColor000000.CGColor;
        _layer3.backgroundColor = [UIColor redColor].CGColor;
    }
}

#pragma 正则匹配手机号
- (BOOL)checkTelNumber:(NSString *) telNumber
{
    NSString *pattern = @"^1+[3578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

@end
