//
//  ScoreItmeTableViewCell.m
//  market
//
//  Created by 刘松杰 on 2018/3/31.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import "ScoreItmeTableViewCell.h"

@interface ScoreItmeTableViewCell()
@property(nonatomic) UIImageView *ppimageView;
@property(nonatomic) UILabel *titleLabel;
@property(nonatomic) UILabel *priceLabel;
@property(nonatomic) UILabel *countLabel;
@end

@implementation ScoreItmeTableViewCell

- (void)invokeLayoutSubviews
{
    [super invokeLayoutSubviews];
    __weak typeof (self) wself = self;
    _ppimageView = (UIImageView *)self.contentView.lp_av(UIImageView.class, 15, 10, self.contentView.w * 0.45f, 100);
    CGFloat w = self.contentView.w * 0.65f - 15 * 2 - 10;
    CGFloat x = 15 + self.contentView.w * 0.45f + 10;
    CGFloat y = 8;
    _titleLabel = (UILabel *)self.contentView.lp_av(UILabel.class, x, y, w, LPFontHeight(18));
    [_titleLabel setFont:LPFont(18) color:kColor000000 alignment:NSTextAlignmentLeft];
    y += LPFontHeight(18) + 10;
    _priceLabel = (UILabel *)self.contentView.lp_av(UILabel.class, x, y, w, LPFontHeight(10));
    [_titleLabel setFont:LPFont(10) color:kColor717171 alignment:NSTextAlignmentLeft];
    y += LPFontHeight(12) + 10;
    _countLabel = (UILabel *)self.contentView.lp_av(UILabel.class, x, y, w, LPFontHeight(10));
    [_countLabel setFont:LPFont(10) color:kColor717171 alignment:NSTextAlignmentLeft];
    y += LPFontHeight(12) + 10;
    UILabel *la = (UILabel *)self.contentView.lp_av(UILabel.class, x, y, 0, 20);
    [la setFont:LPFont(15) color:kColor6d9ff8 alignment:NSTextAlignmentCenter];
    la.fitWidth = YES;
    la.text = @"点击兑换";
}

- (void)invokeFillSubviews
{
    [super invokeFillSubviews];
    [_ppimageView sd_setImageWithURL:[NSURL URLWithString:_item.image_url]];
    _titleLabel.text = _item.title;
    _priceLabel.text = _item.price_txt;
    _countLabel.text = _item.count_txt;
}

- (void)setItem:(ScoreItem *)item
{
    _item = item;
    [self layoutIfNeeded];
}

+ (CGFloat)cellHeight
{
    return 120;
}

@end
