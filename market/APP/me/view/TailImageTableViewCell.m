//
//  TailImageTableViewCell.m
//  market
//
//  Created by 刘松杰 on 2018/3/25.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import "TailImageTableViewCell.h"

@implementation TailImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)invokeLayoutSubviews
{
    [super invokeLayoutSubviews];
    _kimageView = (UIImageView *)self.contentView.lp_av(UIImageView.class, 0, 0, 80, 80);
    _kimageView.cornerRadius = _kimageView.h/2;
}

- (void)invokeFillSubviews
{
    [super invokeFillSubviews];
    [_kimageView sd_setImageWithURL:[NSURL URLWithString:_image_url] placeholderImage:[UIImage imageNamed:@"ic_head_default"]];
    [self.contentView bringSubviewToFront:_kimageView];
    _kimageView.lp_inx1(15).lp_midy();
}

- (void)setImage_url:(NSString *)image_url
{
    _image_url = image_url;
    [self layoutIfNeeded];
}

@end
