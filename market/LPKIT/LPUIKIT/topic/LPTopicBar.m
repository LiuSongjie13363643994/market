//
//  LPTopicBar.m
//  PPAlbum
//
//  Created by Lipeng on 2017/10/24.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "LPTopicBar.h"

@interface LPTopicBar()<UIScrollViewDelegate>
@property(nonatomic) TopicButton *selectedButton;
@property(nonatomic, strong) NSMutableArray<TopicButton *> *buttons;
@end

@implementation LPTopicBar
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        _buttons = [NSMutableArray array];
        _index = -1;
    }
    return self;
}

- (void)setTopics:(NSArray<id<TopicObject>> *)topics
{
    [_buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_buttons removeAllObjects];
    _topics = topics;
    __weak typeof(self) wself = self;
    CGFloat x = 0;
    for (int i = 0; i < topics.count; i++) {
        TopicButton *btn = (TopicButton *)self.lp_av(TopicButton.class, x, 0, 0, self.h);
        btn.tag = i;
        btn.style = _style;
        btn.topic = topics[i];
        
        [btn addActionBlock:^(UIButton *button) {
            [wself onTopic:(TopicButton *)button];
        }];
        x = btn.x2;
        [_buttons addObject:btn];
    }
    self.contentSize = CGSizeMake(x, self.h);
    _width = x;
}

- (void)onTopic:(TopicButton *)button
{
    if (nil != _selected_block){
        if (_selected_block(button.tag, _index != button.tag)){
            _index = button.tag;
            _selectedButton.selected = NO;
            _selectedButton = button;
            _selectedButton.selected = YES;
            [UIView animateWithDuration:.2f animations:^{
                [self adjust:_selectedButton.x width:_selectedButton.w];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}
- (void)offset:(NSInteger)index scale:(CGFloat)scale
{
    if (index < _topics.count){
        if (index != _index){
            _selectedButton.selected = NO;
            _selectedButton = _buttons[index];
            _selectedButton.selected = YES;
            _index = index;
        }
        CGFloat dx = 0.f;
        if (index < _index){
            dx = (_buttons[index].w - _buttons[_index].w) * (1 - scale);
        } else if (index + 1 < _buttons.count){
            dx = (_buttons[index+1].w - _buttons[index].w) * scale;
        }
        
        CGFloat x1 = _buttons[index].x + scale*_buttons[index].w;
        CGFloat width = _buttons[_index].w + dx;
        
        [self adjust:x1 width:width];
    }
}

- (void)adjust:(CGFloat)x1 width:(CGFloat)width
{
    CGFloat mx = x1 + LP_Float_2(width);
    CGFloat ox = mx - LP_Float_2(self.w);
    CGFloat minx = 0, maxx = self.contentSize.width - self.w;
    if (maxx < 0) maxx = 0;
    if (ox < minx) ox = minx;
    if (ox > maxx) ox = maxx;
    self.contentOffset = CGPointMake(ox, 0);
}

- (void)setIndex:(NSInteger)index
{
    if (-1 == index){
        _selectedButton.selected = NO;
        _selectedButton = nil;
        _index = -1;
    } else if (index != _index){
        [self onTopic:_buttons[index]];
    }
}

- (id<TopicObject>)topic
{
    return _selectedButton.topic;
}

#pragma mark

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}
@end
