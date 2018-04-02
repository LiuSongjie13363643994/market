//
//  LoanView.m
//  market
//
//  Created by Lipeng on 2017/8/25.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "LoanView.h"

@interface LoanView()<UITextFieldDelegate>
@property(nonatomic) UITextField *amountTextField;
@property(nonatomic) UITextField *loanDateTextField;
@property(nonatomic) UITextField *repayDateTextField;
@property(nonatomic,strong) NSDate *loanDate;
@property(nonatomic,strong) NSDate *repayDate;
@end

@implementation LoanView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]){
        self.backgroundColor=kColorffffff;
        
        __weak typeof(self) wself=self;
        __weak UITextField *tf=(UITextField *)self.lp_av(UITextField.class,LP_X_GAP,0,self.w-LP_X_2GAP,44);
        [tf setPlaceholder:@"请输入放款金额" keyboardType:UIKeyboardTypeNumberPad returnKeyType:UIReturnKeyDefault];
        [self textfiled:tf prefix:@"放款金额" access:NO];
        _amountTextField=tf;
        self.lp_av(UIView.class,LP_X_GAP,tf.y2,self.w-LP_X_2GAP,LPWidthOfPx).backgroundColor=kColordedede;
        
        tf=(UITextField *)self.lp_av(UITextField.class,LP_X_GAP,tf.y2,self.w-LP_X_2GAP,44);
        [tf setPlaceholder:@"请选择放款日期" keyboardType:UIKeyboardTypeNumberPad returnKeyType:UIReturnKeyDefault];
        [self textfiled:tf prefix:@"放款日期" access:YES];
        _loanDateTextField=tf;
        self.lp_av(UIView.class,LP_X_GAP,tf.y2,self.w-LP_X_2GAP,LPWidthOfPx).backgroundColor=kColordedede;
        
        tf=(UITextField *)self.lp_av(UITextField.class,LP_X_GAP,tf.y2,self.w-LP_X_2GAP,44);
        [tf setPlaceholder:@"请选择约定还款日期" keyboardType:UIKeyboardTypeNumberPad returnKeyType:UIReturnKeyDefault];
        [self textfiled:tf prefix:@"还款日期" access:YES];
        _repayDateTextField=tf;
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
            wself.done_block(wself.amountTextField.text.integerValue,wself.loanDate,wself.repayDate);
        }];
        
        [self addTapGestureBlock:^(UITapGestureRecognizer *gesture) {
            [tf resignFirstResponder];
        }];
    }
    return self;
}

- (void)textfiled:(UITextField *)textfiled prefix:(NSString *)prefix access:(BOOL)access
{
    textfiled.delegate=self;
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

- (void)setLoan:(Loan *)loan
{
    _amountTextField.text=@(loan.apply_amount).stringValue;
}
- (void)resign
{
    [_amountTextField resignFirstResponder];
    [_loanDateTextField resignFirstResponder];
    [_repayDateTextField resignFirstResponder];
}
#pragma mark
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self resign];
    __weak typeof(self) wself=self;
    if (textField==_loanDateTextField){
//        LPDatePicker *picker=(LPDatePicker *)self.lp_av(LPDatePicker.class,0,0,-1,-1);
//        picker.picker.datePickerMode=UIDatePickerModeDate;
//        picker.picker.minimumDate=[NSDate dateWithTimeIntervalSinceNow:-60*60*24*7];
//        picker.done_block=^(NSDate *date){
//            wself.loanDate=date;
//            wself.loanDateTextField.text=[date stringWithFormat:yyyyMMdd];
//        };
        return NO;
    }
    if (textField==_repayDateTextField){
//        LPDatePicker *picker=(LPDatePicker *)self.lp_av(LPDatePicker.class,0,0,-1,-1);
//        picker.picker.datePickerMode=UIDatePickerModeDate;
//        picker.picker.minimumDate=[NSDate dateWithTimeIntervalSinceNow:-60*60*24*7];
//        picker.done_block=^(NSDate *date){
//            wself.repayDate=date;
//            wself.repayDateTextField.text=[date stringWithFormat:yyyyMMdd];
//        };
        return NO;
    }
    return YES;
}
@end
