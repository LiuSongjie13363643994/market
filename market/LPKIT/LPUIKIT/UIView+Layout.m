//
//  UIView+Layout.m
//  JamGo
//
//  Created by Lipeng on 2017/6/27.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "UIView+Layout.h"

static char kAtX;
static char kAtY;
static char kAtX1;
static char kAtY1;
static char kInX;
static char kInY;
static char kInX1;
static char kInY1;
static char kMidX;
static char kMidY;
static char kW;
static char kH;
static char kAV;

@implementation UIView(Layout)

- (instancetype)lp_initWithFrame:(CGRect)frame
{
    [self lp_initWithFrame:frame];
    [self associate];
    
    return self;
}

- (void)lpp_removeFromSuperview
{
    [self unassociate];
    [self lpp_removeFromSuperview];
}

- (void)lpp_didMoveToSuperview
{
    [self lpp_didMoveToSuperview];
    if (nil != self.superview){
        [self associate];
    }
}

- (void)unassociate
{
    objc_setAssociatedObject(self, &kAtX, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self, &kAtY, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self, &kAtX1, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self, &kAtY1, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self, &kInX, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self, &kInY, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self, &kInX1, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self, &kInY1, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self, &kMidX, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self, &kMidY, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self, &kW, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self, &kH, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self, &kAV, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
//- (instancetype)lp_initWithFrame:(CGRect)frame
//{
//    [self lp_initWithFrame:frame];
//    [self associate];
//
//    return self;
//}

- (void)associate
{
    __weak typeof(self) wself=self;
    objc_setAssociatedObject(self,&kAtX,^(UIView *view, CGFloat x){
        CGViewTransX(wself,CGViewGetX2(view)+x);
        return wself;
    },OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self,&kAtY,^(UIView *view, CGFloat y){
        CGViewTransY(wself,CGViewGetY2(view)+y);
        return wself;
    },OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self,&kAtX1,^(UIView *view, CGFloat x){
        CGViewTransX(wself,CGViewGetX1(view)-x-CGViewGetWidth(self));
        return wself;
    },OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self,&kAtY1,^(UIView *view, CGFloat y){
        CGViewTransY(wself,CGViewGetY1(view)-y-CGViewGetWidth(self));
        return wself;
    },OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self,&kInX,^(CGFloat x){
        CGViewTransX(wself,x);
        return wself;
    },OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self,&kInY,^(CGFloat y){
        CGViewTransY(wself,y);
        return wself;
    },OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self,&kInX1,^(CGFloat x){
        CGViewTransX(wself,CGViewGetWidth(wself.superview)-x-CGViewGetWidth(wself));
        return wself;
    },OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self,&kInY1,^(CGFloat y){
        CGViewTransY(wself,CGViewGetHeight(wself.superview)-y-CGViewGetHeight(wself));
        return wself;
    },OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self,&kMidX,^(){
        CGViewTransX1ToMidOfView(wself,wself.superview);
        return wself;
    },OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self,&kMidY,^(){
        CGViewTransY1ToMidOfView(wself,wself.superview);
        return wself;
    },OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self,&kW,^(CGFloat w){
        CGViewChangeWidth(wself,-1==w?self.superview.w:w);
        return wself;
    },OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self,&kH,^(CGFloat h){
        CGViewChangeHeight(wself,-1==h?self.superview.h:h);
        return wself;
    },OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self,&kAV,^(Class class,CGFloat x,CGFloat y,CGFloat w,CGFloat h){
        if (-1 == w){
            w = wself.frame.size.width - x;
        }
        if (-1 == h){
            h = wself.frame.size.height - y;
        }
        UIView *xx = [[class alloc] initWithFrame:CGRectMake(x,y,w,h)];
        [wself addSubview:xx];
        return xx;
    },OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (lp_at_block)lp_atx
{
    return objc_getAssociatedObject(self,&kAtX);
}

- (lp_at_block)lp_aty
{
    return objc_getAssociatedObject(self,&kAtY);
}
- (lp_at1_block)lp_atx1
{
    return objc_getAssociatedObject(self,&kAtX1);
}

- (lp_at1_block)lp_aty1
{
    return objc_getAssociatedObject(self,&kAtY1);
}

- (lp_in_block)lp_inx
{
    return objc_getAssociatedObject(self,&kInX);
}
- (lp_in_block)lp_iny
{
    return objc_getAssociatedObject(self,&kInY);
}

- (lp_in1_block)lp_inx1
{
    return objc_getAssociatedObject(self,&kInX1);
}
- (lp_in1_block)lp_iny1
{
    return objc_getAssociatedObject(self,&kInY1);
}
- (lp_mid_block)lp_midx
{
    return objc_getAssociatedObject(self,&kMidX);
}
- (lp_mid_block)lp_midy
{
    return objc_getAssociatedObject(self,&kMidY);
}
- (lp_wh_block)lp_w
{
    return objc_getAssociatedObject(self,&kW);
}
- (lp_wh_block)lp_h
{
    return objc_getAssociatedObject(self,&kH);
}
- (lp_av_block)lp_av
{
    return objc_getAssociatedObject(self,&kAV);
}
- (CGFloat)x
{
    return CGViewGetX1(self);
}
- (CGFloat)y
{
    return CGViewGetY1(self);
}
- (CGFloat)x2
{
    return CGViewGetX2(self);
}
- (CGFloat)y2
{
    return CGViewGetY2(self);
}
- (CGFloat)w
{
    return CGViewGetWidth(self);
}
- (CGFloat)h
{
    return CGViewGetHeight(self);
}
- (CGSize)s
{
    return CGViewGetSize(self);
}
+ (void)loadSwizzling
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SwizzleSelector(class, @selector(initWithFrame:), @selector(lp_initWithFrame:));
        SwizzleSelector(class, @selector(removeFromSuperview), @selector(lpp_removeFromSuperview));
        SwizzleSelector(class, @selector(didMoveToSuperview), @selector(lpp_didMoveToSuperview));
    });
}
@end
