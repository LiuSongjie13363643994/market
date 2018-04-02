//
//  AboutTableViewCell.m
//  market
//
//  Created by 刘松杰 on 2018/3/24.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import "AboutTableViewCell.h"
@interface AboutTableViewCell()
@property(nonatomic) UILabel *tailLabel;
@end

@implementation AboutTableViewCell

- (void)invokeLayoutSubviews
{
    [super invokeLayoutSubviews];
    self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-next"]];
    _tailLabel = (UILabel *)self.contentView.lp_av(UILabel.class, 0, 0, 100, LPFontHeight(15));
    [_tailLabel setFont:LPFont(15) color:kColor000000 alignment:NSTextAlignmentRight];
    _tailLabel.text = _tailText;
}

- (void)invokeFillSubviews
{   [super invokeFillSubviews];
    _tailLabel.lp_atx1(self.accessoryView, 10).lp_midy();
}

- (void)setTailText:(NSString *)tailText
{
    _tailText = tailText;
    _tailLabel.text = tailText;
    [self layoutIfNeeded];
}
@end
