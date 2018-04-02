//
//  UIView+LP.m
//
//
//  Created by Lipeng on 15/11/21.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import "UIView+LP.h"


static char kTapBlock;
static char kLongBlock;

@implementation UIView(LP)

- (void)setCornerRadius:(CGFloat)radius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

- (void)setBorderWidth:(CGFloat)width
{
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = width;
}

- (void)setBorderColor:(UIColor *)color
{
    self.layer.masksToBounds = YES;
    self.layer.borderColor = color.CGColor;
}


- (CGFloat)cornerRadius
{
    return 0;
}

- (CGFloat)borderWidth
{
    return 0;
}

- (UIColor *)borderColor
{
    return nil;
}

- (UIView *)addSubViewWithClass:(Class)class clearBackground:(BOOL)clearBackground atFrame:(CGRect)frame
{
    UIView *v = [[class alloc] initWithFrame:frame];
    if (clearBackground) {
        v.backgroundColor=[UIColor clearColor];
    }
    [self addSubview:v];
    return v;
}

- (UITableView *)addTableViewWithClass:(Class)class style:(UITableViewStyle)style clearSperator:(BOOL)clearSperator atFrame:(CGRect)frame
{
    UITableView *v = [[class alloc] initWithFrame:frame style:style];
    v.clearSeparator = clearSperator;
    [self addSubview:v];
    return v;
}

- (CALayer *)drawLineAsLayer:(CGRect)frame color:(UIColor *)color
{
    CALayer *layer = [CALayer layer];
    layer.frame = frame;
    layer.backgroundColor = color.CGColor;
    [self.layer addSublayer:layer];
    return layer;
}

- (UIView *)drawLineAsView:(CGRect)frame color:(UIColor *)color
{
    UIView *v = LPAddSubView(self, UIView, frame);
    v.backgroundColor = color;
    return v;
}

- (CALayer *)drawBottomLine:(UIColor *)color
{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0,CGViewGetHeight(self)-LPWidthOfPx,CGViewGetWidth(self),LPWidthOfPx);
    layer.backgroundColor = color.CGColor;
    [self.layer addSublayer:layer];
    return layer;
}

- (UIView *)drawBottomLineAsView:(UIColor *)color
{
    UIView *v = LPAddSubView(self, UIView, CGRectMake(0,CGViewGetHeight(self)-LPWidthOfPx,CGViewGetWidth(self),LPWidthOfPx));
    v.backgroundColor = color;
    v.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    return v;
}

- (CALayer *)drawTopLine:(UIColor *)color
{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0,0,CGViewGetWidth(self),LPWidthOfPx);
    layer.backgroundColor = color.CGColor;
    [self.layer addSublayer:layer];
    return layer;
}

- (void)callNumber:(NSString *)number
{
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", number]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self addSubview:callWebview];
}

- (UITapGestureRecognizer *)addTapGestureWithTarget:(nullable id)target action:(nullable SEL)action
{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
    return tap;
}

- (UITapGestureRecognizer *)addTapGestureBlock:(void (^)(UITapGestureRecognizer *))block
{
    UITapGestureRecognizer * gesture = nil;
    if (nil == objc_getAssociatedObject(self, &kTapBlock)){
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blockTapGesture:)];
        [self addGestureRecognizer:gesture];
    }
    objc_setAssociatedObject(self, &kTapBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return gesture;
}

- (void)blockTapGesture:(UITapGestureRecognizer *)ges
{
    void (^block)(UITapGestureRecognizer *) = objc_getAssociatedObject(self, &kTapBlock);
    if (nil != block){
        block(ges);
    }
}

- (void)addLongGestureBlock:(void (^)(UILongPressGestureRecognizer *))block
{
    if (nil == objc_getAssociatedObject(self, &kLongBlock)){
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(blockLongGesture:)];
//        gesture.minimumPressDuration = 1;
        [self addGestureRecognizer:gesture];
    }
    objc_setAssociatedObject(self, &kLongBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)blockLongGesture:(UILongPressGestureRecognizer *)ges
{
    void (^block)(UILongPressGestureRecognizer *) = objc_getAssociatedObject(self, &kLongBlock);
    if (nil != block){
        block(ges);
    }
}


- (UIImage *)myimage
{
    UIImage *image;
    UIGraphicsBeginImageContextWithOptions(CGViewGetSize(self),NO,[UIScreen mainScreen].scale);
    [self drawViewHierarchyInRect:CGViewGetBounds(self) afterScreenUpdates:YES];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIView *)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    return nil;
}
- (void)asRoundStlye:(UIColor *)color
{
    self.cornerRadius=LP_Float_2(CGViewGetHeight(self));
    self.backgroundColor=color;
}
- (void)addMaskLayer:(UIColor *)color
{
    CAShapeLayer *maskLayer=[[CAShapeLayer alloc] init];
    CGRect maskRect=CGViewGetBounds(self);
    
    CGMutablePathRef path=CGPathCreateMutable();
    CGPathAddRect(path,nil,maskRect);
    [maskLayer setPath:path];
    CGPathRelease(path);
    maskLayer.frame=maskRect;
    maskLayer.backgroundColor=color.CGColor;
    
    // Set the mask of the view.
    self.layer.mask = maskLayer;
}
@end
