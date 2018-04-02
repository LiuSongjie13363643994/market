//
//  AuthBaseViewController.m
//  market
//
//  Created by Lipeng on 2017/8/19.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "AuthBaseViewController.h"
#import "AuthPhoneViewController.h"
#import "SysService.h"
#import "UserService.h"

@interface AuthBaseViewController ()<UITextFieldDelegate>
@property(nonatomic) UITableView *tableView;
@property(nonatomic) UITextField *nameTextFiled;
@property(nonatomic) UITextField *icTextFiled;
@property(nonatomic) UITextField *zimaTextFiled;
@property(nonatomic) UITextField *amountTextFiled;
@property(nonatomic) UITextField *periodTextFiled;
@property(nonatomic) UITextField *cityTextFiled;
@property(nonatomic) UITextField *yeeTextFiled;
@property(nonatomic) UITextField *incomeTextFiled;

@property(nonatomic,strong) NSArray *amounts;
@property(nonatomic,strong) NSArray *periods;
@property(nonatomic,strong) NSArray *yees;
@property(nonatomic,strong) NSArray *incomes;
@property(nonatomic,strong) NSMutableArray *supplies;

@property(nonatomic,strong) User *user;

@property(nonatomic,strong) User *editUser;
@end

@implementation AuthBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"个人资料";
    
    _amounts=@[@"￥3000以下",@"￥3000-￥10000",@"￥10000-￥50000",@"￥50000-￥100000",@"￥100000以上"];
    _periods=@[@"1个月以下",@"1个月-3个月",@"3个月-6个月",@"6个月-12个月",@"12个月以上"];
    _yees=@[@"上班族",@"做生意",@"学生党",@"其他职业"];
    _incomes=@[@"￥3000以下",@"￥3000-￥5000",@"￥5000-￥10000",@"￥10000-￥20000",@"￥20000以上"];

    _user=[UserService shared].user;
    _editUser=[[User alloc] initWithUser:_user];
    _supplies=[NSMutableArray array];
    if (0!=_user.supplies.length){
        _supplies=[NSMutableArray arrayWithArray:[_user.supplies componentsSeparatedByString:@","]];
    }
    _tableView=LPAddPlainTableView(self.contentView,UITableView,NO,self.contentView.bounds);
    _tableView.tableHeaderView=self.headerView;
    __weak typeof(self) wself=self;
    
    void (^block)(void)=^{
        wself.editUser.name=wself.nameTextFiled.text;
        wself.editUser.id_card=wself.icTextFiled.text;
        wself.editUser.loan_amount=[wself amountValue];
        wself.editUser.loan_period=[wself periodValue];
        wself.editUser.city=wself.cityTextFiled.text;
        wself.editUser.occupation=wself.yeeTextFiled.text;
        wself.editUser.income=[wself incomeValue];
        NSString *txt=nil;
        for (NSString *supply in wself.supplies) {
            if (nil==txt){
                txt=supply;
            } else {
                txt=[NSString stringWithFormat:@"%@,%@",txt,supply];
            }
        }
        wself.editUser.supplies=txt;
        
        __weak LPLoadingView *loading=[LPLoadingView showAsModal];
        [[UserService shared] update:wself.editUser block:^(BOOL result, NSString *msg) {
            [loading stop:NO];
            if (result){
                AuthPhoneViewController *apvc=[[AuthPhoneViewController alloc] init];
                apvc.grade=wself.grade;
                [wself pushViewController:apvc];
            } else {
                [LPAlertView know:msg block:nil];
            }
        }];
    };
    
    [[self addRightNavigationTextButton:@"提交"] addActionBlock:^(UIButton *button){
        [wself resign];
        if (![wself textFiled:_nameTextFiled length:1 tip:@"请输入姓名！"]){
            return;
        }
        if (![wself textFiled:_icTextFiled length:18 tip:@"请输入18位身份证号码！"]){
            return;
        }
        if (![wself textFiled:_amountTextFiled length:1 tip:@"请选择贷款金额！"]){
            return;
        }
        if (![wself textFiled:_periodTextFiled length:1 tip:@"请选择贷款期限！"]){
            return;
        }
        wself.cityTextFiled.text=@"枣庄";
        if (![wself textFiled:_cityTextFiled length:1 tip:@"请选择所在城市！"]){
            return;
        }
        if (![wself textFiled:_yeeTextFiled length:1 tip:@"请选择职业信息！"]){
            return;
        }
        if (![wself textFiled:_incomeTextFiled length:1 tip:@"请选择收入范围！"]){
            return;
        }
        if (0==wself.supplies.count){
            [LPAlertView confirm:@"提交补充信息能够提高贷款通过率；确定不选择补充信息吗？" block:block];
        } else {
            block();
        }
    }];
}

- (BOOL)textFiled:(UITextField *)textField length:(NSInteger)length tip:(NSString *)tip
{
    if (textField.text.length<length) {
        [LPAlertView know:tip block:^{
            [textField becomeFirstResponder];
        }];
        return NO;
    }
    return YES;
}

- (UIView *)headerView
{
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0,0,LP_Screen_Width,0)];
    
    UILabel *la=(UILabel *)v.lp_av(UILabel.class,0,0,v.w,34);
    [la setFont:LPFont(14) color:kColor666666 alignment:NSTextAlignmentCenter];
    la.text=@"将根据填写的信息，为您推荐合适的贷款产品";
    
    CALayer *layer=[CALayer layer];
    layer.frame=CGRectMake(0,la.y2,v.w,54*4);
    layer.backgroundColor=kColorffffff.CGColor;
    [v.layer addSublayer:layer];
    
    v.lp_av(UIView.class,0,la.y2,v.w,LPWidthOfPx).backgroundColor=kColordedede;
    UITextField *tf=(UITextField *)v.lp_av(UITextField.class,LP_X_GAP,la.y2,v.w-LP_X_2GAP,54);
    tf.userInteractionEnabled=NO;
    [tf setPlaceholder:@"输入手机号" keyboardType:UIKeyboardTypePhonePad returnKeyType:UIReturnKeyDefault];
    [self textfiled:tf prefix:@"手机号码" access:NO];
    tf.text=_user.mobile;
    v.lp_av(UIView.class,LP_X_GAP,tf.y2,v.w-LP_X_2GAP,LPWidthOfPx).backgroundColor=kColordedede;
    
    tf=(UITextField *)v.lp_av(UITextField.class,LP_X_GAP,tf.y2,v.w-LP_X_2GAP,54);
    [tf setPlaceholder:@"输入本人姓名" keyboardType:UIKeyboardTypeDefault returnKeyType:UIReturnKeyDefault];
    [self textfiled:tf prefix:@"本人姓名" access:NO];
    _nameTextFiled=tf;
    tf.text=_user.name;
    v.lp_av(UIView.class,LP_X_GAP,tf.y2,v.w-LP_X_2GAP,LPWidthOfPx).backgroundColor=kColordedede;
    
    tf=(UITextField *)v.lp_av(UITextField.class,LP_X_GAP,tf.y2,v.w-LP_X_2GAP,54);
    [tf setPlaceholder:@"输入本人身份证号" keyboardType:UIKeyboardTypeAlphabet returnKeyType:UIReturnKeyDefault];
    [self textfiled:tf prefix:@"身份证号" access:NO];
    tf.autocapitalizationType=UITextAutocapitalizationTypeNone;
    _icTextFiled=tf;
    tf.text=_user.id_card;
    v.lp_av(UIView.class,LP_X_GAP,tf.y2,v.w-LP_X_2GAP,LPWidthOfPx).backgroundColor=kColordedede;
    
    tf=(UITextField *)v.lp_av(UITextField.class,LP_X_GAP,tf.y2,v.w-LP_X_2GAP,54);
    [tf setPlaceholder:@"输入您的芝麻分" keyboardType:UIKeyboardTypeNumberPad returnKeyType:UIReturnKeyDefault];
    [self textfiled:tf prefix:@"芝麻分" access:NO];
    tf.autocapitalizationType=UITextAutocapitalizationTypeNone;
    _zimaTextFiled=tf;
    tf.text=@(_user.zhima).stringValue;
    v.lp_av(UIView.class,0,tf.y2,v.w,LPWidthOfPx).backgroundColor=kColordedede;
    
    layer=[CALayer layer];
    layer.frame=CGRectMake(0,tf.y2+10,v.w,54*3);
    layer.backgroundColor=kColorffffff.CGColor;
    [v.layer addSublayer:layer];
    
    v.lp_av(UIView.class,0,tf.y2+10,v.w,LPWidthOfPx).backgroundColor=kColordedede;
    tf=(UITextField *)v.lp_av(UITextField.class,LP_X_GAP,tf.y2+10,v.w-LP_X_2GAP,54);
    [tf setPlaceholder:@"请选择贷款金额" keyboardType:UIKeyboardTypePhonePad returnKeyType:UIReturnKeyDefault];
    [self textfiled:tf prefix:@"贷款金额" access:YES];
    tf.text=[self amountTxt];
    _amountTextFiled=tf;
    v.lp_av(UIView.class,LP_X_GAP,tf.y2,v.w-LP_X_2GAP,LPWidthOfPx).backgroundColor=kColordedede;
    
    tf=(UITextField *)v.lp_av(UITextField.class,LP_X_GAP,tf.y2,v.w-LP_X_2GAP,54);
    [tf setPlaceholder:@"请选择贷款期限" keyboardType:UIKeyboardTypePhonePad returnKeyType:UIReturnKeyDefault];
    [self textfiled:tf prefix:@"贷款期限" access:YES];
    tf.text=[self periodTxt];
    _periodTextFiled=tf;
    v.lp_av(UIView.class,LP_X_GAP,tf.y2,v.w-LP_X_2GAP,LPWidthOfPx).backgroundColor=kColordedede;
    
    tf=(UITextField *)v.lp_av(UITextField.class,LP_X_GAP,tf.y2,v.w-LP_X_2GAP,54);
    [tf setPlaceholder:@"请选择所在城市" keyboardType:UIKeyboardTypePhonePad returnKeyType:UIReturnKeyDefault];
    [self textfiled:tf prefix:@"所在城市" access:YES];
    tf.text=_user.city;
    _cityTextFiled=tf;
    v.lp_av(UIView.class,0,tf.y2,v.w,LPWidthOfPx).backgroundColor=kColordedede;
    
    layer=[CALayer layer];
    layer.frame=CGRectMake(0,tf.y2+10,v.w,54*2);
    layer.backgroundColor=kColorffffff.CGColor;
    [v.layer addSublayer:layer];
    
    v.lp_av(UIView.class,0,tf.y2+10,v.w,LPWidthOfPx).backgroundColor=kColordedede;
    tf=(UITextField *)v.lp_av(UITextField.class,LP_X_GAP,tf.y2+10,v.w-LP_X_2GAP,54);
    [tf setPlaceholder:@"请选择职业信息" keyboardType:UIKeyboardTypePhonePad returnKeyType:UIReturnKeyDefault];
    [self textfiled:tf prefix:@"职业信息" access:YES];
    tf.text=_user.occupation;
    _yeeTextFiled=tf;
    v.lp_av(UIView.class,LP_X_GAP,tf.y2,v.w-LP_X_2GAP,LPWidthOfPx).backgroundColor=kColordedede;
    
    tf=(UITextField *)v.lp_av(UITextField.class,LP_X_GAP,tf.y2,v.w-LP_X_2GAP,54);
    [tf setPlaceholder:@"请选择收入范围" keyboardType:UIKeyboardTypePhonePad returnKeyType:UIReturnKeyDefault];
    [self textfiled:tf prefix:@"收入范围" access:YES];
    tf.text=[self incomeTxt];
    _incomeTextFiled=tf;
    v.lp_av(UIView.class,0,tf.y2,v.w,LPWidthOfPx).backgroundColor=kColordedede;
    
    layer=[CALayer layer];
    layer.backgroundColor=kColorffffff.CGColor;
    [v.layer addSublayer:layer];
    
    v.lp_av(UIView.class,0,tf.y2+10,v.w,LPWidthOfPx).backgroundColor=kColordedede;
    la=(UILabel *)v.lp_av(UILabel.class,LP_X_GAP,tf.y2+10,0,34);
    [la setFont:LPFont(16) color:kColor666666 alignment:NSTextAlignmentLeft];
    la.fitWidth=YES;
    la.text=@"补充信息（可多选）";
    
    void (^block)(UIButton *button)=^(UIButton *button){
        button.borderWidth=button.selected?0:1;
        [button asRoundStlye:button.selected?kColore13f3c:[UIColor clearColor]];
        [button setTitleColor:button.selected?kColorffffff:kColor999999 forState:UIControlStateNormal];
    };
    __weak typeof(self) wself=self;
    NSArray *bu=[SysService shared].configure.supplies;
    CGFloat x=LP_X_GAP,y=la.y2;
    for (int i=0;i<bu.count;i++){
        UIButton *btn=(UIButton *)v.lp_av(UIButton.class,x,y,0,28);
        btn.fitWidth=YES;
        btn.borderColor=kColor999999;
        [btn setTitleFont:LPFont(14) color:kColor999999 text:bu[i]];
        btn.lp_w(btn.w+30);
        btn.selected=([_user.supplies rangeOfString:bu[i]].length>0);
        block(btn);
        
        [btn addActionBlock:^(UIButton *button) {
            button.selected=!button.selected;
            block(button);
            NSString *txt=[button titleForState:UIControlStateNormal];
            if (button.selected){
                [wself.supplies addObject:txt];
            } else {
                [wself.supplies removeObject:txt];
            }
        }];
        if (i==bu.count-1){
            y=btn.y2;
            break;
        }
        x=btn.x2+10;
        if (x+[bu[i+1] lpSizeWithFont:LPFont(14)].width+30>v.w-LP_X_GAP){
            x=LP_X_GAP;
            y+=33;
        }
    }
    v.lp_av(UIView.class,0,y+5,v.w,LPWidthOfPx).backgroundColor=kColordedede;
    layer.frame=CGRectMake(0,tf.y2+10,LP_Screen_Width,y+5-tf.y2-10);
    
    la=(UILabel *)v.lp_av(UILabel.class,0,y+5,-1,34);
    [la setFont:LPFont(14) color:kColor666666 alignment:NSTextAlignmentCenter];
    la.text=@"全网速贷将保证您的信息安全";
    
    v.lp_h(la.y2);
    
    return v;
}

- (NSString *)amountTxt
{
    if (0==_user.loan_amount){
        return nil;
    }
    int xx[]={3000,10000,50000,100000,-1};
    for (int i=0;i<5;i++){
        if (xx[i]==_user.loan_amount){
            return _amounts[i];
        }
    }
    return nil;
}
- (NSInteger)amountValue
{
    if (0==_amountTextFiled.text.length){
        return 0;
    }
    int xx[]={3000,10000,50000,100000,-1};
    return xx[[_amounts indexOfObject:_amountTextFiled.text]];
}

- (NSString *)periodTxt
{
    if (0==_user.loan_period){
        return nil;
    }
    int xx[]={1,3,6,12,-1};
    for (int i=0;i<5;i++){
        if (xx[i]==_user.loan_period){
            return _periods[i];
        }
    }
    return nil;
}
- (NSInteger)periodValue
{
    if (0==_periodTextFiled.text.length){
        return 0;
    }
    int xx[]={1,3,6,12,-1};
    return xx[[_periods indexOfObject:_periodTextFiled.text]];
}

- (NSString *)incomeTxt
{
    if (0==_user.income){
        return nil;
    }
    int xx[]={3000,5000,10000,20000,-1};
    for (int i=0;i<5;i++){
        if (xx[i]==_user.income){
            return _incomes[i];
        }
    }
    return nil;
}

- (NSInteger)incomeValue
{
    if (0==_incomeTextFiled.text.length){
        return 0;
    }
    int xx[]={3000,5000,10000,20000,-1};
    return xx[[_incomes indexOfObject:_incomeTextFiled.text]];
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
- (void)resign
{
    [_nameTextFiled resignFirstResponder];
    [_icTextFiled resignFirstResponder];
    [_zimaTextFiled resignFirstResponder];
}
#pragma mark
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self resign];
    __weak typeof(self) wself=self;
    if (textField==_amountTextFiled){
        [[LPActionSheet sheetWithTitle:nil buttonTitles:_amounts completionBlock:^(NSUInteger buttonIndex) {
            if (buttonIndex<wself.amounts.count){
                wself.amountTextFiled.text=wself.amounts[buttonIndex];
            }
        } ] showInView:self.view];
        return NO;
    }
    if (textField==_periodTextFiled){
        [[LPActionSheet sheetWithTitle:nil buttonTitles:_periods completionBlock:^(NSUInteger buttonIndex) {
            if (buttonIndex<wself.periods.count){
                wself.periodTextFiled.text=wself.periods[buttonIndex];
            }
        } ] showInView:self.view];
        return NO;
    }
    if (textField==_cityTextFiled){
        return NO;
    }
    if (textField==_yeeTextFiled){
        [[LPActionSheet sheetWithTitle:nil buttonTitles:_yees completionBlock:^(NSUInteger buttonIndex) {
            if (buttonIndex<wself.yees.count){
                wself.yeeTextFiled.text=wself.yees[buttonIndex];
            }
        } ] showInView:self.view];
        return NO;
    }
    if (textField==_incomeTextFiled){
        [[LPActionSheet sheetWithTitle:nil buttonTitles:_incomes completionBlock:^(NSUInteger buttonIndex) {
            if (buttonIndex<wself.incomes.count){
                wself.incomeTextFiled.text=wself.incomes[buttonIndex];
            }
        } ] showInView:self.view];
        return NO;
    }
    return YES;
}
@end
