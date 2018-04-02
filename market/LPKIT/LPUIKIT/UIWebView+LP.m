//
//  UIWebView+LP.m
//  Beauty
//
//  Created by Lipeng on 2017/6/7.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "UIWebView+LP.h"

@implementation UIWebView(LP)

- (void)lp_sizeToFit
{
    [self lp_sizeToFit];
    self.scrollView.bounces=NO;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.scrollEnabled=NO;
}
+ (void)loadSwizzling
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SwizzleSelector(class, @selector(sizeToFit), @selector(lp_sizeToFit));
    });
}
@end
