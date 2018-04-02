//
//  TailTextTableViewCell.m
//  market
//
//  Created by 刘松杰 on 2018/3/25.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import "TailTextTableViewCell.h"

@interface TailTextTableViewCell()
@property(nonatomic) UILabel *tailLabel;
@end

@implementation TailTextTableViewCell

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
    _tailLabel = (UILabel *)self.contentView.lp_av(UILabel.class, 0, 0, 100, 55);
    [_tailLabel setFont:LPFont(16) color:kColor717171 alignment:NSTextAlignmentRight];
}

- (void)invokeFillSubviews
{
    [super invokeFillSubviews];
    if (!_tailText) {
        _tailText = @"美女or帅哥";
    }
    _tailLabel.text = _tailText;
    _tailLabel.lp_inx1(15);
    [self.contentView bringSubviewToFront:_tailLabel];
}

- (void)setTailText:(NSString *)tailText
{
    _tailText = tailText;
    _tailLabel.text = tailText;
}

@end
