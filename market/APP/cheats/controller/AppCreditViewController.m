//
//  AppCreditViewController.m
//  market
//
//  Created by Lipeng on 2017/8/23.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "AppCreditViewController.h"
#import "ProductWebViewController.h"

#import "AppCreditView.h"

#import "ProductService.h"

@interface AppCreditViewController ()<UITextFieldDelegate>

@end

@implementation AppCreditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"App征信检测";
    self.contentView.backgroundColor=[UIColor colorWithHexString:@"0xf4fcff"];
    UIImage *img=[UIImage imageNamed:@"app_auth.png"];
    UIImageView *iv=[[UIImageView alloc] initWithImage:img];
    iv.lp_w(LP_Screen_Width).lp_h(LP_Screen_Width*img.size.height/img.size.width);
    [self.contentView addSubview:iv];
    
    __weak UITextField *tf=(UITextField *)self.contentView.lp_av(UITextField.class,LP_X_GAP,iv.y2-40,iv.w-LP_X_2GAP,34);
    [tf asRoundStlye:kColorffffff6];
    tf.borderColor=[UIColor colorWithHexString:@"0xbad8e3"];
    tf.borderWidth=1;
    [tf setPlaceholder:@"输入APP名称" keyboardType:UIKeyboardTypeDefault returnKeyType:UIReturnKeySearch];
    [tf setFont:LPFont(16) color:kColor23232b alignment:NSTextAlignmentCenter];
    [tf setClearButtonMode:UITextFieldViewModeWhileEditing leftViewMode:UITextFieldViewModeAlways];
    tf.delegate=self;
    
    __weak typeof(self) wself=self;
    UIButton *btn=(UIButton *)self.contentView.lp_av(UIButton.class,LP_X_GAP,tf.y2+10,iv.w-LP_X_2GAP,34);
    [btn asRoundStlye:kColore13f3c];
    [btn setTitleFont:LPFont(16) color:kColorffffff text:@"点击查询"];
    [btn addActionBlock:^(UIButton *button) {
        [wself search:tf];
    }];
    
    [self.contentView addTapGestureBlock:^(UITapGestureRecognizer *gesture) {
        [tf resignFirstResponder];
    }];
}
- (void)search:(UITextField *)tf
{
    [tf resignFirstResponder];
    if (0==tf.text.length){
        [LPAlertView know:@"请输入要查询的APP名称！" block:^{
            [tf becomeFirstResponder];
        }];
        return;
    }
    __weak typeof(self) wself=self;
    __weak LPLoadingView *loading=[LPLoadingView showAsModal];
    [[ProductService shared] find:tf.text block:^(BOOL result, Product *product, NSString *msg) {
        [loading stop:NO];
        if (result && nil!=product){
            AppCreditView *cv=(AppCreditView *)wself.contentView.lp_av(AppCreditView.class,0,0,-1,-1);
            cv.product=product;
            cv.apply_block=^(Product *product){
                [wself checkLogin:^{
                    ProductWebViewController *pwvc=[[ProductWebViewController alloc] init];
                    pwvc.product=product;
                    [wself pushViewController:pwvc];
                }];
            };
        } else {
            [LPAlertView know:msg block:nil];
        }
    }];
}
#pragma mark

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self search:textField];
    return YES;
}
@end
