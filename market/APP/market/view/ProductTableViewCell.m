//
//  ProductTableViewCell.m
//  market
//
//  Created by Lipeng on 2017/8/18.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "ProductTableViewCell.h"

@interface ProductTableViewCell()
@property(nonatomic) UIImageView *iconImageView;
@property(nonatomic) UILabel *titleLabel;
@property(nonatomic) UILabel *infoLabel;
@property(nonatomic) UILabel *sloganLabel;
@property(nonatomic) UILabel *authLabel;
@property(nonatomic) UILabel *numberLabel;
@end

@implementation ProductTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)invokeLayoutSubviews
{
    UIView *cv=self.contentView;
    CGFloat x=64,w=LP_Screen_Width-x;
    _titleLabel=(UILabel *)cv.lp_av(UILabel.class,x,8,w,26);
    [_titleLabel setFont:LPFont(18) color:kColor23232b alignment:NSTextAlignmentLeft];
    _infoLabel=(UILabel *)cv.lp_av(UILabel.class,x,_titleLabel.y2,w,16);
//    cv.lp_av(UIView.class,x,_slognLabel.y2,w-LP_X_GAP,LPWidthOfPx).backgroundColor=kColordddddd06;
    _authLabel=(UILabel *)cv.lp_av(UILabel.class,x,_infoLabel.y2,w,16);
    [_authLabel setFont:LPFont(12) color:kColor999999 alignment:NSTextAlignmentLeft];
    _sloganLabel=(UILabel *)cv.lp_av(UILabel.class,x,_authLabel.y2,w,20);
    [_sloganLabel setFont:LPFont(12) color:kColore13f3c alignment:NSTextAlignmentLeft];
    _numberLabel=(UILabel *)cv.lp_av(UILabel.class,x,0,w-LP_X_GAP,26);
    [_numberLabel setFont:LPFont(12) color:kColor999999 alignment:NSTextAlignmentRight];
    
    UIImageView *iv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-next"]];
    [cv addSubview:iv];
    iv.lp_inx(LP_Screen_Width-LP_X_GAP-iv.w).lp_iny((88-iv.h)/2);
    
    _iconImageView=(UIImageView *)cv.lp_av(UIImageView.class,10,14,44,44);
    _iconImageView.cornerRadius=8;
    _iconImageView.borderWidth=LPWidthOfPx;
    _iconImageView.borderColor=kColorcccccc;
    _iconImageView.backgroundColor=kColorf2f2f2;
}

- (void)invokeFillSubviews
{
    _titleLabel.text=_product.title;
    NSArray *strings=@[@"最高 ",_product.max_amount_txt,
                       @"  放款 ",_product.loan_time_txt,
                       @"  利率 ",_product.interest_txt];
    NSArray *colors=@[kColor999999,kColor23232b,kColor999999,kColor23232b,kColor999999,kColor23232b];
    NSArray *fonts=@[LPFont(12),LPFont(12),LPFont(12),LPFont(12),LPFont(12),LPFont(12)];
    _infoLabel.attributedText=[NSAttributedString string:strings colors:colors fonts:fonts];
    _authLabel.text=[NSString stringWithFormat:@"认证 %@",_product.auth_txt];
    _sloganLabel.text=_product.slogan;
    _numberLabel.text=_product.tip_txt;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_product.icon_url]];
}

- (void)setProduct:(Product *)product
{
    _product=product;
    [self layoutIfNeeded];
}
+ (CGFloat)height
{
    return 88;
}
@end
