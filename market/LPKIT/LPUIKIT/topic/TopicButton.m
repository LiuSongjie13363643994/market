//
//  TopicButton.m
//  PPAlbum
//
//  Created by Lipeng on 2017/10/24.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "TopicButton.h"

@implementation TopicStyle



@end

const NSString *kNotifySetTopicBadge = @"kNotifySetTopicBadge";
const NSString *kNotifyClearTopicBadge = @"kNotifyClearTopicBadge";

@interface TopicButton()
@property(nonatomic) UIView *lineView;
@property(nonatomic) CALayer *pointLayer;
@end

@implementation TopicButton

- (void)dealloc
{
    LP_RemoveObserver(self);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        LP_AddObserver((NSString *)kNotifySetTopicBadge, self,@selector(onBadge:));
        LP_AddObserver((NSString *)kNotifyClearTopicBadge, self,@selector(onRereshed:));
        
        _lineView = self.lp_av(UIView.class, 0, 0, 0, 2).lp_iny1(10);
        _lineView.cornerRadius = 1;
        self.titleLabel.font = LPFont(18);
        _lineView.hidden = self.enabled;
        
        _pointLayer = [CALayer layer];
        _pointLayer.backgroundColor = [UIColor redColor].CGColor;
        CGFloat w = 6;
        _pointLayer.frame = CGRectMake(0, 0, w, w);
        _pointLayer.cornerRadius = 3;
        [self.layer addSublayer:_pointLayer];
        [self setNotify:NO];
        _lineView.lp_w(CGRectGetWidth(frame) - 14);
        _lineView.lp_midx();
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    super.frame = frame;
    if (nil != _lineView){
        _lineView.lp_w(CGRectGetWidth(frame) - 14);
        _lineView.lp_midx();
    }
}
- (void)onBadge:(NSNotification *)notify
{
    if ([((NSString *)notify.object) isEqualToString:_topic.code]) {
        [self setNotify:YES];
    }
}

- (void)onRereshed:(NSNotification *)notify
{
    if ([((NSString *)notify.object) isEqualToString:_topic.code]) {
        [self setNotify:NO];
    }
}

- (void)setNotify:(BOOL)notify
{
    _pointLayer.opacity = notify?1:0;
    CGFloat tw = [[self titleForState:UIControlStateNormal] lpSizeWithFont:self.titleLabel.font].width;
    _pointLayer.position = CGPointMake(LP_Float_2(self.w - tw) + tw,LP_Float_2(self.h - 19));
}

- (void)setTopic:(id<TopicObject>)topic
{
    _topic = topic;
    [self setTitle:topic.title forState:UIControlStateNormal];
    self.selected = self.selected;
}

- (void)setStyle:(TopicStyle *)style
{
    _style = style;
    _lineView.backgroundColor = style.lineColor;
    [self setTitleColor:style.normalColor forState:UIControlStateNormal];
    [self setTitleColor:style.selectedColor forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected
{
    super.selected = selected;
    _lineView.hidden = !selected;
    self.titleLabel.font = !selected ? _style.normalFont : _style.selectedFont;
    if (0 == self.topic.title.length){
        self.lp_w(0);
    } else {
        self.lp_w([_topic.title lpSizeWithFont:self.titleLabel.font].width + 35.f);
    }
}
@end
