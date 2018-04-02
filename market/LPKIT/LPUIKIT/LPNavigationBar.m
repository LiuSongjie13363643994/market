//
//  LPNavigationBar.m
//  
//
//  Created by Lipeng on 16/4/6.
//
//

#import "LPNavigationBar.h"

@interface LPNavigationBar()

@end

@implementation LPNavigationBar
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (nil != newSuperview && nil == _barView){
        _barView = self.lp_av(UIView.class, 0, 0, -1, 44).lp_iny1(0);
    }
}
@end
