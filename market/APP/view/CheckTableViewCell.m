//
//  CheckTableViewCell.m
//  market
//
//  Created by Lipeng on 2017/8/26.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "CheckTableViewCell.h"

@interface CheckTableViewCell()
@property(nonatomic) CheckStateView *stateView;
@end

@implementation CheckTableViewCell

- (void)invokeLayoutSubviews
{
    [super invokeLayoutSubviews];
    _stateView=(CheckStateView *)self.contentView.lp_av(CheckStateView.class,0,0,0,0);
}

- (void)invokeFillSubviews
{
    [super invokeFillSubviews];
    _stateView.lp_atx1(self.accessoryView,10).lp_midy();
    _stateView.state=_check_state;
}

- (void)setCheck_state:(NSInteger)check_state
{
    _check_state=check_state;
    [self layoutIfNeeded];
}
@end
