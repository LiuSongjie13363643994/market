//
//  CheatTableViewCell.m
//  market
//
//  Created by Lipeng on 2017/8/19.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "CheatTableViewCell.h"
#import "CheatBackgroundView.h"

@interface CheatTableViewCell()
@property(nonatomic) CheatBackgroundView *bgView;
@property(nonatomic) UILabel *titleLabel;
@property(nonatomic) UILabel *infoLabel;
@end

@implementation CheatTableViewCell
- (void)dealloc
{
    [_cheat removeObserver:self forKeyPath:@"tip"];
}
- (void)invokeLayoutSubviews
{
    UIView *cv=self.contentView;
    _bgView=(CheatBackgroundView*)cv.lp_av(CheatBackgroundView.class,10,0,LP_Screen_Width-20,74);
    _bgView.cornerRadius=4;
    _titleLabel=(UILabel *)_bgView.lp_av(UILabel.class,LP_X_GAP,0,_bgView.w-LP_X_2GAP,50).lp_midy();
    _titleLabel.numberOfLines=0;
}

- (void)invokeFillSubviews
{
    _bgView.backgroundColor=[UIColor colorWithHexString:_cheat.color];
    _titleLabel.attributedText=[NSAttributedString string:@[_cheat.title,@"\n\n",_cheat.tip]
                                                   colors:@[kColorffffff9,kColorffffff8,kColorffffff8]
                                                    fonts:@[LPFont(18),LPFont(5),LPFont(12)] alignment:NSTextAlignmentLeft lineHeight:0 breakMode:NSLineBreakByWordWrapping];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    _titleLabel.attributedText=[NSAttributedString string:@[_cheat.title,@"\n\n",_cheat.tip]
                                                   colors:@[kColorffffff9,kColorffffff8,kColorffffff8]
                                                    fonts:@[LPFont(18),LPFont(5),LPFont(12)]];
}
- (void)setCheat:(Cheat *)cheat
{
    [_cheat removeObserver:self forKeyPath:@"tip"];
    [cheat addObserver:self forKeyPath:@"tip" options:0 context:NULL];
    _cheat=cheat;
    [self layoutIfNeeded];
}
+ (CGFloat)height
{
    return 84;
}
@end
