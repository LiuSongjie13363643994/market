//
//  TextInputTableViewCell.m
//  market
//
//  Created by 刘松杰 on 2018/3/25.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import "TextInputTableViewCell.h"
#import "UserService.h"

@implementation TextInputTableViewCell

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
    _textfield = (UITextField *)self.contentView.lp_av(UITextField.class, 60, 0, LP_Screen_Width-60-15, 55);
    if ([UserService shared].user.user_info) {
       _textfield.text = [UserService shared].user.user_info.nick;
    }
    _textfield.placeholder = @"输入昵称";
    [_textfield setFont:LPFont(16) color:kColor717171 alignment:NSTextAlignmentRight];
}

@end
