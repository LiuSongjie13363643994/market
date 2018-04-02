//
//  UITableViewCell+LP.m
//
//
//  Created by Lipeng on 15/11/15.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import "UITableViewCell+LP.h"
#import "LPKit.h"
#import <objc/runtime.h>

static char kLayoutDoneKey;
static char kSeparatorView;

@implementation UITableViewCell(LP)
//初始化显示样式
- (void)initAppearanceStyles
{
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    self.accessoryType   = UITableViewCellAccessoryNone;
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView  = nil;
    self.selectedBackgroundView = nil;
    self.contentView.backgroundColor = [UIColor clearColor];
    if ([self respondsToSelector:@selector(setSeparatorInset:)]){
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]){
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [self setPreservesSuperviewLayoutMargins:NO];
    }
    self.backgroundColor = [UIColor clearColor];
}

- (UIColor *)separatorColor
{
    return nil;
}
//重写布局方法
- (void)lp_layoutSubviews
{
    [self lp_layoutSubviews];
    UIView *sv = objc_getAssociatedObject(self,&kSeparatorView);
    if (nil == sv) {
        for (UIView *v in self.contentView.superview.subviews) {
            if (0 != [NSStringFromClass(v.class) rangeOfString:@"SeparatorView"].length) {
                sv = v;
                objc_setAssociatedObject(self,&kSeparatorView,v,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                break;
            }
        }
    }
    
    if (nil!=self.separatorColor){
        sv.backgroundColor=self.separatorColor;
        sv.hidden = NO;
    } else {
        sv.hidden=YES;
    }
    
    id did = objc_getAssociatedObject(self, &kLayoutDoneKey);
    if (![did boolValue]){
        [self initAppearanceStyles];
        [self invokeLayoutSubviews];
        objc_setAssociatedObject(self, &kLayoutDoneKey, @(YES), OBJC_ASSOCIATION_COPY_NONATOMIC);
    } else {
        [self invokeFillSubviews];
    }
}
- (UIView *)separatorView
{
    return objc_getAssociatedObject(self, &kSeparatorView);
}
- (CGSize)contentSize
{
    return CGViewGetSize(self.contentView);
}
//生成控件
- (void)invokeLayoutSubviews
{
    
}
//重新布局
- (void)invokeFillSubviews
{
    
}

+ (void)loadSwizzling
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SwizzleSelector(class, @selector(layoutSubviews), @selector(lp_layoutSubviews));
    });
}
@end
