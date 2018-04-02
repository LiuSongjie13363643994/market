//
//  FavTableViewCell.m
//  market
//
//  Created by Lipeng on 2017/8/20.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "FavTableViewCell.h"

@interface FavTableViewCell()
@property(nonatomic) UIImageView *iconImageView;
@property(nonatomic) UILabel *titleLabel;
@end

@implementation FavTableViewCell

- (void)invokeLayoutSubviews
{
    self.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-next"]];
    
    UIView *cv=self.contentView;
    CGFloat x=LP_X_GAP;
    _iconImageView=(UIImageView *)cv.lp_av(UIImageView.class,x,10,34,34);
    _iconImageView.contentMode=UIViewContentModeScaleAspectFill;
    _iconImageView.cornerRadius=4;
    x=_iconImageView.x2+10;
    _titleLabel=(UILabel *)cv.lp_av(UILabel.class,x,10,0,34);
    [_titleLabel setFont:LPFont(17) color:kColor23232b alignment:NSTextAlignmentLeft];
    _titleLabel.fitWidth=YES;
}

- (void)invokeFillSubviews
{
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_fav.icon_url]];
    _titleLabel.text=_fav.title;
}
- (void)setFav:(Product *)fav
{
    _fav=fav;
    [self layoutIfNeeded];
}
+ (CGFloat)height
{
    return 54;
}
@end
