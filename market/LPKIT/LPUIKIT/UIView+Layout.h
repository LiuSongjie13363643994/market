//
//  UIView+Layout.h
//  JamGo
//
//  Created by Lipeng on 2017/6/27.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIView *(^lp_av_block)(Class xclass,CGFloat x,CGFloat y,CGFloat w,CGFloat h);
typedef UIView *(^lp_wh_block)(CGFloat wh);
typedef UIView *(^lp_in_block)(CGFloat xy);
typedef UIView *(^lp_in1_block)(CGFloat xy);
typedef UIView *(^lp_at_block)(UIView *view,CGFloat xy);
typedef UIView *(^lp_at1_block)(UIView *view,CGFloat xy);
typedef UIView *(^lp_mid_block)(void);

@interface UIView(Layout)
//addsubview
@property(nonatomic,copy,readonly) lp_av_block lp_av;
//
@property(nonatomic,copy,readonly) lp_wh_block lp_w;
//
@property(nonatomic,copy,readonly) lp_wh_block lp_h;
//
@property(nonatomic,copy,readonly) lp_in_block lp_inx;
//
@property(nonatomic,copy,readonly) lp_in_block lp_iny;
//
@property(nonatomic,copy,readonly) lp_in1_block lp_inx1;
//
@property(nonatomic,copy,readonly) lp_in1_block lp_iny1;
//
@property(nonatomic,copy,readonly) lp_mid_block lp_midx;
//
@property(nonatomic,copy,readonly) lp_mid_block lp_midy;
//
@property(nonatomic,copy,readonly) lp_at_block lp_atx;
//
@property(nonatomic,copy,readonly) lp_at_block lp_aty;
//
@property(nonatomic,copy,readonly) lp_at1_block lp_atx1;
//
@property(nonatomic,copy,readonly) lp_at1_block lp_aty1;

- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)x2;
- (CGFloat)y2;
- (CGFloat)w;
- (CGFloat)h;
- (CGSize)s;

- (void)unassociate;
+ (void)loadSwizzling;
@end
