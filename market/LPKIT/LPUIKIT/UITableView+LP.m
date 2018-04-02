//
//  UITableView+LP.m
//
//
//  Created by Lipeng on 15/11/15.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import "UITableView+LP.h"
#import <objc/runtime.h>

static char kClearSeparatorKey;

@implementation UITableView(LP)

//初始化显示样式
- (void)initAppearanceStyles:(BOOL)clearSeparator
{
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    self.showsVerticalScrollIndicator = NO;
    if ([self respondsToSelector:@selector(separatorInset)]){
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]){
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    if (clearSeparator){
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.sectionIndexColor = [UIColor clearColor];
        if ([self respondsToSelector:@selector(setSectionIndexBackgroundColor:)]) {
            self.sectionIndexBackgroundColor = [UIColor clearColor];
        }
        if ([self respondsToSelector:@selector(setSectionIndexTrackingBackgroundColor:)]) {
            self.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        }
    }
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,CGFLOAT_MIN)];
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,CGFLOAT_MIN)];
}

- (id)cellWithClass:(Class)class style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier
{
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell){
        cell = [[class alloc] initWithStyle:style reuseIdentifier:identifier];
    }
    return cell;
}

- (void)setClearSeparator:(BOOL)clearSeparator
{
    objc_setAssociatedObject(self, &kClearSeparatorKey, @(clearSeparator), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)clearSeparator
{
    return [objc_getAssociatedObject(self, &kClearSeparatorKey) boolValue];
}

- (void)lp_didMoveToSuperview
{
    [self lp_didMoveToSuperview];
    if (nil != self.superview) {
        [self initAppearanceStyles:self.clearSeparator];
    }
}
- (void)lp_reloadData
{
    [UIView performWithoutAnimation:^{
        self.hidden = YES;
        CGPoint offset = self.contentOffset;
        [self reloadData];
        self.contentOffset = offset;
        self.hidden = NO;
    }];
}

- (void)scrollToTop:(BOOL)animated
{
    [self setContentOffset:CGPointMake(0, 0) animated:animated];
}

- (void)scrollBottom:(BOOL)animated
{
    CGFloat h1=self.contentSize.height;
    CGFloat h2=CGViewGetHeight(self);
    if (h1>h2){
        [self setContentOffset:CGPointMake(0,h1-h2) animated:animated];
    }
}

+ (void)loadSwizzling
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SwizzleSelector(class, @selector(didMoveToSuperview), @selector(lp_didMoveToSuperview));
    });
}
@end
