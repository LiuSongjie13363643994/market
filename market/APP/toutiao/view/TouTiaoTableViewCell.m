//
//  TouTiaoTableViewCell.m
//  market
//
//  Created by 刘松杰 on 2018/3/24.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import "TouTiaoTableViewCell.h"
#import "NSDate+LP.h"
@interface TouTiaoTableViewCell()
@property(nonatomic) UIImageView *iconImageView;
@property(nonatomic) UILabel *infoLabel;
@property(nonatomic) UILabel *timeLabel;
@property(nonatomic) UILabel *readCount;
@end

@implementation TouTiaoTableViewCell

- (void)invokeLayoutSubviews
{
    UIView *cv=self.contentView;
    _iconImageView=(UIImageView *)cv.lp_av(UIImageView.class,15,10,100,76);
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.clipsToBounds = YES;
    _iconImageView.backgroundColor=kColorf2f2f2;
    
    _infoLabel = (UILabel *)cv.lp_av(UILabel.class, 0, 10, 0, 45);
    [_infoLabel setFont:LPFont(18) color:kColor000000 alignment:NSTextAlignmentLeft];
    _infoLabel.numberOfLines = 2;
    
    _timeLabel = (UILabel *)cv.lp_av(UILabel.class, 0, 0, 0, 8);
    _timeLabel.fitWidth = YES;
    [_timeLabel setFont:LPFont(12) color:kColor000000 alignment:NSTextAlignmentLeft];
    
    _readCount = (UILabel *)cv.lp_av(UILabel.class, 0, 0, 0, 8);
    _readCount.fitWidth = YES;
    [_readCount setFont:LPFont(12) color:kColor000000 alignment:NSTextAlignmentRight];
}

- (void)invokeFillSubviews
{
    CGFloat x = 15;
    CGFloat w = LP_Screen_Width - x - 15;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_toutiao.image_url]];
    if (0 != _toutiao.image_url.length) {
        _iconImageView.hidden = NO;
        x = 130;
        w = LP_Screen_Width - x - 15;
    } else {
        _iconImageView.hidden = YES;
    }
    
    _infoLabel.text = _toutiao.title;
    NSString *time = nil;
    if (_toutiao.source) {
        time = [NSString stringWithFormat:@"%@  %@", _toutiao.source, [_toutiao.date dateString:@"M月d日" ymd:@"yyyy年M月d日"]];
    } else {
        time = [NSString stringWithFormat:@"%@", [_toutiao.date dateString:@"M月d日" ymd:@"yyyy年M月d日"]];
    }
    _timeLabel.text = time;
    _readCount.text = _toutiao.read_counts;
    _infoLabel.lp_inx(x).lp_w(w);
    _timeLabel.lp_inx(x).lp_iny1(13).lp_w(w);
    _readCount.lp_inx1(15).lp_iny1(13);
}

- (void)setProduct:(TouTiao *)toutiao
{
    _toutiao=toutiao;
    [self layoutIfNeeded];
}
+ (CGFloat)height
{
    return 96;
}

@end
