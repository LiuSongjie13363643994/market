//
//  ApplyView.m
//  market
//
//  Created by Lipeng on 2017/8/25.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "ApplyView.h"

@interface ApplyView()
@property(nonatomic) UITextField *amountTextField;
@end

@implementation ApplyView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]){
        self.backgroundColor=kColorffffff;
        
        __weak typeof(self) wself=self;
        __weak UITextField *tf=(UITextField *)self.lp_av(UITextField.class,LP_X_GAP,0,self.w-LP_X_2GAP,44);
        [tf setPlaceholder:@"输入申请金额" keyboardType:UIKeyboardTypeNumberPad returnKeyType:UIReturnKeyDefault];
        [self textfiled:tf prefix:@"申请金额" access:NO];
        self.lp_av(UIView.class,LP_X_GAP,tf.y2,self.w-LP_X_2GAP,LPWidthOfPx).backgroundColor=kColordedede;
        
        CGFloat w=(self.w-LP_X_GAP*3)/2;
        UIButton *btn=(UIButton *)self.lp_av(UIButton.class,LP_X_GAP,tf.y2+10,w,34);
        btn.backgroundColor=kColorff0000;
        btn.cornerRadius=4;
        [btn setTitleFont:LPFont(16) color:kColorffffff text:@"取消"];
        [btn addActionBlock:^(UIButton *button) {
            wself.cancel_block();
        }];
        
        btn=(UIButton *)self.lp_av(UIButton.class,0,tf.y2+10,w,34).lp_inx1(LP_X_GAP);
        btn.backgroundColor=kColore13f3c;
        btn.cornerRadius=4;
        [btn setTitleFont:LPFont(16) color:kColorffffff text:@"提交"];
        [btn addActionBlock:^(UIButton *button) {
            [tf resignFirstResponder];
            wself.done_block(tf.text.integerValue);
        }];
        
        [self addTapGestureBlock:^(UITapGestureRecognizer *gesture) {
            [tf resignFirstResponder];
        }];
    }
    return self;
}

- (void)textfiled:(UITextField *)textfiled prefix:(NSString *)prefix access:(BOOL)access
{
    [textfiled setFont:LPFont(16) color:kColor23232b alignment:NSTextAlignmentRight];
    [textfiled setClearButtonMode:UITextFieldViewModeWhileEditing leftViewMode:UITextFieldViewModeAlways];
    UILabel *la=[[UILabel alloc] initWithFrame:CGRectMake(0,0,0,textfiled.h)];
    [la setFont:textfiled.font color:kColor666666 alignment:NSTextAlignmentCenter];
    la.fitWidth=YES;
    la.text=prefix;
    textfiled.leftView=la;
    if (access){
        UIImage *img=[UIImage imageNamed:@"ic-next"];
        UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0,0,LP_X_GAP+img.size.width,textfiled.h)];
        UIImageView *iv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-next"]];
        [v addSubview:iv];
        iv.lp_inx1(0).lp_midy();
        textfiled.rightView=v;
        textfiled.rightViewMode=UITextFieldViewModeAlways;
    }
}

@end
