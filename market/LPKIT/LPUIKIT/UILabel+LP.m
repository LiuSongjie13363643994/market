//
//  UILabel+LP.m
//
//
//  Created by Lipeng on 15/11/15.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import "UILabel+LP.h"
#import <objc/runtime.h>
static char kFitWidthKey;
static char kFitHeightKey;

@implementation UILabel(LP)

- (UILabel *)setFont:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment
{
    self.font = font;
    self.textColor = color;
    self.textAlignment = alignment;
    return self;
}

- (void)lp_setText:(NSString *)text
{
    [self lp_setText:text];
    if (self.fitWidth && 1==self.numberOfLines) {
        CGViewChangeWidth(self, (0 == text.length) ? 0 : self.textWidthWhen1Line);
    }
    if (self.fitHeight && 0 == self.numberOfLines) {
        CGViewChangeHeight(self,(0 == text.length) ? 0 : self.textHeightWhen0Line);
    }
}

//- (void)lp_setAttributedText:(NSAttributedString *)attributedText
//{
//    [self lp_setAttributedText:attributedText];
//    if (self.fitHeight&&0==self.numberOfLines) {
//        CGViewChangeHeight(self,(0==attributedText.length)?0:[attributedText lpHeightWithMaxWidth:CGViewGetWidth(self)]);
//    }
//}

- (CGFloat)textWidthWhen1Line
{
    return [self.text lpSizeWithFont:self.font].width;
}

- (CGFloat)textHeightWhen0Line
{
    return [self.text lpSizeWithFont:self.font maxWidth:CGViewGetWidth(self)].height;
}

- (CGFloat)attributedTextHeightWhen0Line
{
    return [self.attributedText lpHeightWithMaxWidth:CGViewGetWidth(self)];
}

- (BOOL)fitWidth
{
    return [objc_getAssociatedObject(self, &kFitWidthKey) boolValue];
}

- (void)setFitWidth:(BOOL)fitWidth
{
    objc_setAssociatedObject(self,&kFitWidthKey,[NSNumber numberWithBool:fitWidth], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)fitHeight
{
    return [objc_getAssociatedObject(self, &kFitHeightKey) boolValue];
}

- (void)setFitHeight:(BOOL)fitHeight
{
    objc_setAssociatedObject(self,&kFitHeightKey,[NSNumber numberWithBool:fitHeight], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)loadSwizzling
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SwizzleSelector(class, @selector(setText:), @selector(lp_setText:));
//        SwizzleSelector(class, @selector(setAttributedText:), @selector(lp_setAttributedText:));
    });
}
@end
