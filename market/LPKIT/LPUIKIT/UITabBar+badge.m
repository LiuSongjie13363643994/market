//
//  UITabBar+badge.m
//  DU365
//
//  Created by xuyuqiang on 16/7/15.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import "UITabBar+badge.h"
#define TabbarItemNums 3.0    //tabbar的数量 如果是5个设置为5.0

@implementation UITabBar (badge)
//显示小红点
- (void)showBadgeOnItemIndex:(int)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    //新建小红点
    UIImageView *badgeView = [[UIImageView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.image = [UIImage imageNamed:@"ic_tip_red"];
//    badgeView.layer.cornerRadius = 5.f;//圆形
//    badgeView.layer.borderColor=[UIColor whiteColor].CGColor;
//    badgeView.layer.borderWidth=1.f;
    badgeView.layer.masksToBounds=YES;
//    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    CGFloat x =tabFrame.size.width/(TabbarItemNums*2.f) + 25.f/4.f;
//    float percentX = (index +0.6) / TabbarItemNums;
//    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10, 10);//圆形大小为10
    [self addSubview:badgeView];
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}
@end
