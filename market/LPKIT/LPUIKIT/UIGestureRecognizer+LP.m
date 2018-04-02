//
//  UIPanGestureRecognizer+LP.m
//  DU365
//
//  Created by Lipeng on 16/7/1.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import "UIGestureRecognizer+LP.h"
#import <objc/runtime.h>

static char kPreTranslationKey;

@implementation UIGestureRecognizer(LP)
- (void)setPreTranslation:(CGPoint)preTranslation
{
    objc_setAssociatedObject(self,&kPreTranslationKey,[NSValue valueWithCGPoint:preTranslation], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGPoint)preTranslation
{
    NSValue *v=objc_getAssociatedObject(self, &kPreTranslationKey);
    return nil==v ? CGPointZero : v.CGPointValue;
}
@end
