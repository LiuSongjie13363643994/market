//
//  UITextView+LP.m
//  MDT
//
//  Created by Lipeng on 15/11/24.
//  Copyright (c) 2015年 West. All rights reserved.
//

#import "UITextView+LP.h"
#import <objc/runtime.h>
static char kPlaceHoderKey;

@implementation UITextView(LP)

- (UILabel *)setPlaceHolder:(NSString *)placeHolder
{
    if (0 == placeHolder.length) {
        if (nil != objc_getAssociatedObject(self, &kPlaceHoderKey)){
            objc_setAssociatedObject(self, &kPlaceHoderKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self removeObserver:self forKeyPath:@"text" context:NULL];
            [self removeObserver:self forKeyPath:@"attributedText" context:NULL];
            LP_RemoveObserver(self);
        }
        return nil;
    }
    
    UILabel *label = objc_getAssociatedObject(self, &kPlaceHoderKey);
    if (nil == label){
        label = LPAddClearBGSubView(self, UILabel, CGRectInset(self.bounds,0,10));
        [label setFont:self.font color:LPColor(0x99,0x99,0x99,1) alignment:NSTextAlignmentLeft];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.numberOfLines = 0;
        LP_AddObserver(UITextViewTextDidChangeNotification,self,@selector(onTextDidchanged:));
        [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew context:NULL];
        objc_setAssociatedObject(self, &kPlaceHoderKey, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    label.text = placeHolder;
    
    CGFloat height = [placeHolder lpSizeWithFont:self.font maxWidth:CGViewGetWidth(label)].height;
    CGViewChangeHeight(label, height);
    [self checkZeroLength];
    return label;
}

- (NSString *)placeHolder
{
    UILabel *label = objc_getAssociatedObject(self, &kPlaceHoderKey);
    return label.text;
}

- (void)checkZeroLength
{
    if (0 != self.text.length || 0 != self.attributedText.string.length) {
        [objc_getAssociatedObject(self, &kPlaceHoderKey) setHidden:YES];
    } else {
        [objc_getAssociatedObject(self, &kPlaceHoderKey) setHidden:NO];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self checkZeroLength];
}

- (void)onTextDidchanged:(NSNotification *)notify
{
    if (notify.object == self) {
        [self checkZeroLength];
    }
}

- (void)setFont:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment
{
    self.font = font;
    self.textColor = color;
    self.textAlignment = alignment;
}
@end
