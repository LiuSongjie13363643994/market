//
//  LPPictureScrollView.m
//  DU365
//
//  Created by Lipeng on 16/7/5.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import "LPPictureScrollView.h"

@interface LPPictureScrollView()<UIScrollViewDelegate>

@end

@implementation LPPictureScrollView
- (void)dealloc
{
    self.reach_block=nil;
    self.reach0_block=nil;
}
- (id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator=NO;
        self.pagingEnabled=YES;
        self.delegate=self;
        self.bounces=YES;
        _currentIndex=-1;
    }
    return self;
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.bounces){
        if (self.reach0_block && self.reach0_block()) {
            return nil;
        } else {
            [NSTimer scheduledTimerWithTimeInterval:.001f target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
        }
        return nil;
    }else{
        return [super hitTest:point withEvent:event];
    }
}
- (void)onTimer:(id)timer
{
    self.bounces=YES;
}
- (void)setImageURLs:(NSArray<NSString *> *)imageURLs
{
    _imageURLs=imageURLs;
    
    CGFloat x=0,y=0,w=CGViewGetWidth(self),h=CGViewGetHeight(self);
    for (NSString *URL in _imageURLs) {
        UIImageView *iv=LPAddClearBGSubView(self,UIImageView,CGRectMake(x,y,w,h));
        iv.clipsToBounds=YES;
        iv.contentMode=UIViewContentModeScaleAspectFit;
//        [iv sd_setImageWithURL:[NSURL URLWithString:URL]];
        x+=w;
    }
    self.contentSize=CGSizeMake(x,h);
    self.currentIndex=0;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (_reach_block){
        _reach_block(_currentIndex,currentIndex);
    }
    _currentIndex=currentIndex;
}

- (void)gotoPageAtIndex:(NSInteger)index
{
    self.contentOffset=CGPointMake(CGViewGetWidth(self)*index,0);
    self.currentIndex=index;
}

#pragma mark
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x<0.f){
        scrollView.bounces=NO;
        scrollView.contentOffset=CGPointZero;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentIndex=scrollView.contentOffset.x/CGViewGetWidth(scrollView);
}
@end
