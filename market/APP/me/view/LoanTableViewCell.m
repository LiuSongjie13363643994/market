//
//  LoanTableViewCell.m
//  market
//
//  Created by Lipeng on 2017/8/20.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "LoanTableViewCell.h"

@interface LoanTableViewCell()
@property(nonatomic) UIImageView *iconImageView;
@property(nonatomic) UILabel *titleLabel;
@property(nonatomic) UILabel *stateLabel;
@property(nonatomic) UILabel *scoreLabel;
@property(nonatomic) UILabel *timeLabel;
@end

@implementation LoanTableViewCell

- (void)invokeLayoutSubviews
{
    self.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-next"]];
    
    UIView *cv=self.contentView;
    CGFloat x=LP_X_GAP,y=10;
    _iconImageView=(UIImageView *)cv.lp_av(UIImageView.class,x,y,34,34);
    _iconImageView.contentMode=UIViewContentModeScaleAspectFill;
    _iconImageView.cornerRadius=4;
    x=_iconImageView.x2+10;
    _titleLabel=(UILabel *)cv.lp_av(UILabel.class,x,y,0,17);
    [_titleLabel setFont:LPFont(17) color:kColor23232b alignment:NSTextAlignmentLeft];
    _titleLabel.fitWidth=YES;
    
    _stateLabel=(UILabel *)cv.lp_av(UILabel.class,0,y,50,17);
    [_stateLabel setFont:LPFont(12) color:kColor999999 alignment:NSTextAlignmentCenter];
    _stateLabel.cornerRadius=8.5;
    _stateLabel.borderWidth=1;
    _stateLabel.borderColor=kColor999999;
    
    _scoreLabel=(UILabel *)cv.lp_av(UILabel.class,0,5,0,17);
    [_scoreLabel setFont:LPFont(12) color:kColore13f3c alignment:NSTextAlignmentCenter];
    _scoreLabel.fitWidth=YES;
    
    x=_titleLabel.x,y=_titleLabel.y2;
    _timeLabel=(UILabel *)cv.lp_av(UILabel.class,x,y,LP_Screen_Width-x-LP_X_GAP,20);
    [_timeLabel setFont:LPFont(13) color:kColor999999 alignment:NSTextAlignmentLeft];
}

- (void)invokeFillSubviews
{
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_loan.icon_url]];
    _titleLabel.text=_loan.title;
    _stateLabel.text=_loan.state_txt;
    _stateLabel.textColor=(kLoan_State_Overdue==_loan.state)?kColorff0000:kColor999999;
    _stateLabel.borderColor=(kLoan_State_Overdue==_loan.state)?kColorff0000:kColor999999;
    if (kLoan_State_Apply==_loan.state){
        _timeLabel.text=[NSString stringWithFormat:@"申请日 %@",[_loan.apply_date stringWithFormat:yyyyMMdd]];
    } else if (kLoan_State_Loan==_loan.state){
        _timeLabel.text=[NSString stringWithFormat:@"放款日 %@ 还款日 %@",
                         [_loan.apply_date stringWithFormat:yyyyMMdd],[_loan.repay_date stringWithFormat:yyyyMMdd]];
    } else if (kLoan_State_Repay==_loan.state){
        _timeLabel.text=[NSString stringWithFormat:@"还款日 %@",[_loan.repaid_date stringWithFormat:yyyyMMdd]];
    } else if (kLoan_State_Overdue==_loan.state){
        _timeLabel.text=[NSString stringWithFormat:@"放款日 %@ 还款日 %@",
                         [_loan.apply_date stringWithFormat:yyyyMMdd],[_loan.repay_date stringWithFormat:yyyyMMdd]];
    }
    
    _scoreLabel.hidden=(_loan.score==0);
    _scoreLabel.text=[NSString stringWithFormat:@"%@分",@(_loan.score)];
    _scoreLabel.lp_inx1(5);
    
    _stateLabel.lp_atx(_titleLabel,5);
}

- (void)setLoan:(Loan *)loan
{
    _loan=loan;
    [self layoutIfNeeded];
}
+ (CGFloat)height
{
    return 54;
}
@end
