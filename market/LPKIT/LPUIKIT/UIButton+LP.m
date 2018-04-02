//
//  UIButton+LP.m
//  DU365
//
//  Created by Lipeng on 16/6/21.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import "UIButton+LP.h"
#import <objc/runtime.h>

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;
static char kFitWidthKey;
static char kBlockKey;

@implementation UIButton(LP)

- (void)setFitWidth:(BOOL)fitWidth
{
    self.titleLabel.fitWidth=fitWidth;
    objc_setAssociatedObject(self,&kFitWidthKey,[NSNumber numberWithBool:fitWidth], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)fitWidth
{
    return [objc_getAssociatedObject(self, &kFitWidthKey) boolValue];
}

- (void)setTitleFont:(UIFont *)font
{
    self.titleLabel.font=font;
    if (self.fitWidth){
        CGViewChangeWidth(self,CGViewGetWidth(self.titleLabel));
    }
}

- (void)setTitleFont:(UIFont *)font color:(UIColor *)color text:(NSString *)title 
{
    [self setTitleFont:font];
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateNormal];
    if (self.fitWidth){
        CGViewChangeWidth(self,CGViewGetWidth(self.titleLabel));
    }
}
//

- (void) setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect) enlargedRect
{
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else
    {
        return self.bounds;
    }
}

- (UIView*)hitTest:(CGPoint) point withEvent:(UIEvent*) event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}
- (void)maskColor:(UIColor *)color
{
    CALayer *ml=[CALayer layer];
    [self.layer addSublayer:ml];
    ml.frame=self.imageView.bounds;
    ml.mask=self.imageView.layer;
    ml.backgroundColor=color.CGColor;
}
- (UIButton *)addActionBlock:(void (^)(UIButton *button))block
{
    objc_setAssociatedObject(self,&kBlockKey,block,OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(onSelf:) forControlEvents:UIControlEventTouchUpInside];
    return self;
}
- (void)onSelf:(id)button
{
    void (^block)(UIButton *)=objc_getAssociatedObject(self,&kBlockKey);
    if (nil!=block){
        block(self);
    }
}
@end
