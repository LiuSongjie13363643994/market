//
//  UIScrollView+LP.m
//  DU365
//
//  Created by Lipeng on 16/7/1.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import "UIScrollView+LP.h"
#import <objc/runtime.h>

static char kPreOffsetKey;

@implementation UIScrollView(LP)
- (void)setPreContentOffset:(CGPoint)preContentOffset
{
    objc_setAssociatedObject(self,&kPreOffsetKey,[NSValue valueWithCGPoint:preContentOffset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGPoint)preContentOffset
{
    NSValue *v=objc_getAssociatedObject(self, &kPreOffsetKey);
    return nil==v ? CGPointZero : v.CGPointValue;
}
- (void)stopScrolling
{
    CGPoint offset = self.contentOffset;
    offset.x -= 1.0;
    offset.y -= 1.0;
    [self setContentOffset:offset animated:NO];
    offset.x += 1.0;
    offset.y += 1.0;
    [self setContentOffset:offset animated:NO];
}

- (UIImage *)snapshotY:(NSArray *)cgrects
{
    CGFloat maxH=0,scale=[UIScreen mainScreen].scale;
    CGRect *rects=malloc(sizeof(CGRect)*cgrects.count);
    
    for (int i=0;i<cgrects.count;i++) {
        CGRect rect=[(NSValue *)cgrects[i] CGRectValue];
        rect.origin.x*=scale;
        rect.origin.y*=scale;
        rect.size.width*=scale;
        rect.size.height*=scale;
        rects[i]=rect;
        if (CGRectGetMaxY(rect)>maxH) {
            maxH=CGRectGetMaxY(rect);
        }
    }
    
    //保存scrollview的offset和frame
    CGPoint offset=self.contentOffset;
    CGRect frame=self.frame;
    self.contentOffset=CGPointZero;
    self.frame=CGRectMake(0,0,CGViewGetWidth(self), maxH/scale);
    
    //截图
    UIImage* image=nil;
    UIGraphicsBeginImageContextWithOptions(CGViewGetSize(self),NO,scale);
    [self drawViewHierarchyInRect:CGViewGetBounds(self) afterScreenUpdates:YES];
    image = UIGraphicsGetImageFromCurrentImageContext();
    //恢复scrollview的offset和frame
    self.contentOffset = offset;
    self.frame = frame;
    
    UIGraphicsEndImageContext();
    
    UIImage *resultImage=nil;
    if (nil!=image) {
        for (NSInteger i=0;i<cgrects.count;i++) {
            if (!CGRectEqualToRect(rects[i],CGRectZero)) {
                UIImage *image1=[image cropImageInRect:rects[i]];
                if (i == 0) {
                    resultImage=image1;
                } else {
                    resultImage=[resultImage appendImageAtBottom:image1];
                }
            }
        }
    }
    free(rects);
    return resultImage;
}
- (UIImage *)snapshotX:(NSArray *)cgrects
{
    CGFloat maxW=0,scale=[UIScreen mainScreen].scale;
    CGRect *rects=malloc(sizeof(CGRect)*cgrects.count);
    
    for (int i=0;i<cgrects.count;i++) {
        CGRect rect=[(NSValue *)cgrects[i] CGRectValue];
        rect.origin.x*=scale;
        rect.origin.y*=scale;
        rect.size.width*=scale;
        rect.size.height*=scale;
        rects[i]=rect;
        if (CGRectGetMaxY(rect)>maxW) {
            maxW=CGRectGetMaxX(rect);
        }
    }

    //保存scrollview的offset和frame
    CGPoint offset=self.contentOffset;
    CGRect frame=self.frame;
    self.contentOffset=CGPointZero;
    self.frame=CGRectMake(0,0,maxW/scale,CGViewGetHeight(self));
    
    //截图
    UIImage* image=nil;
    UIGraphicsBeginImageContextWithOptions(CGViewGetSize(self),NO,scale);
    [self drawViewHierarchyInRect:CGViewGetBounds(self) afterScreenUpdates:YES];
    image = UIGraphicsGetImageFromCurrentImageContext();
    //恢复scrollview的offset和frame
    self.contentOffset = offset;
    self.frame = frame;
    
    UIGraphicsEndImageContext();
    
    UIImage *resultImage=nil;
    if (nil!=image) {
        for (NSInteger i=0;i<cgrects.count;i++) {
            if (!CGRectEqualToRect(rects[i],CGRectZero)) {
                UIImage *image1=[image cropImageInRect:rects[i]];
                if (i == 0) {
                    resultImage=image1;
                } else {
                    resultImage=[resultImage appendImageAtRight:image1];
                }
            }
        }        
    }
    free(rects);
    return resultImage;
}
@end
