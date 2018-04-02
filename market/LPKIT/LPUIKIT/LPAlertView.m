//
//  LPAlertView.m
//  MDT
//
//  Created by Lipeng on 15/11/28.
//  Copyright (c) 2015年 West. All rights reserved.
//

#import "LPAlertView.h"
#import <objc/runtime.h>

@interface LPAlertView ()<UIAlertViewDelegate>

@end

@implementation LPAlertView
- (void)dealloc
{
    objc_setAssociatedObject(self, "blockCallback", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
    completionBlock:(void (^)(NSUInteger buttonIndex))block
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... {
    objc_setAssociatedObject(self, "blockCallback", [block copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self = [self initWithTitle:title
                           message:message
                          delegate:self
                 cancelButtonTitle:nil
                 otherButtonTitles:nil]) {
        
        if (cancelButtonTitle) {
            [self addButtonWithTitle:cancelButtonTitle];
            self.cancelButtonIndex = [self numberOfButtons] - 1;
        }
        
        id eachObject;
        va_list argumentList;
        if (nil != otherButtonTitles) {
            [self addButtonWithTitle:otherButtonTitles];
            va_start(argumentList, otherButtonTitles);
            while ((eachObject = va_arg(argumentList, id))) {
                [self addButtonWithTitle:eachObject];
            }
            va_end(argumentList);
        }
    }
    return self;
}

#pragma mark

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^block)(NSUInteger buttonIndex) = objc_getAssociatedObject(self, "blockCallback");
    if (block) {
        block(buttonIndex);
    }
}

+ (id)alertViewWithTitle:(NSString *)title
                 message:(NSString *)message
         completionBlock:(void (^)(NSUInteger buttonIndex))block
       cancelButtonTitle:(NSString *)cancelButtonTitle
       otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (!cancelButtonTitle && !otherButtonTitles) {
        return nil;
    }
    LPAlertView *av = [[self alloc] initWithTitle:title
                                          message:message
                                  completionBlock:block
                                cancelButtonTitle:cancelButtonTitle
                                otherButtonTitles:nil];
    
    id eachObject;
    va_list argumentList;
    if (nil != otherButtonTitles) {
        [av addButtonWithTitle:otherButtonTitles];
        va_start(argumentList, otherButtonTitles);
        while ((eachObject = va_arg(argumentList, id))) {
            [av addButtonWithTitle:eachObject];
        }
        va_end(argumentList);
    }
    [av show];
    return av;
}

+ (void)know:(NSString *)txt block:(void (^)(void))block
{
    [LPAlertView alertViewWithTitle:nil message:txt completionBlock:^(NSUInteger buttonIndex) {
        if (nil != block){
            block();
        }
    } cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
}
+ (void)sure:(NSString *)txt block:(void (^)(void))block
{
    [LPAlertView alertViewWithTitle:nil message:txt completionBlock:^(NSUInteger buttonIndex) {
        if (nil != block){
            block();
        }
    } cancelButtonTitle:@"确定" otherButtonTitles:nil];
}
+ (void)confirm:(NSString *)txt block:(void (^)(void))block
{
    [LPAlertView alertViewWithTitle:nil message:txt completionBlock:^(NSUInteger buttonIndex) {
        if (1==buttonIndex){
            if (nil != block){
                block();
            }
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
}

+ (void)tip:(NSString *)txt{
    CGFloat continueTime = 0.6f;
    UIColor *alertBG = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f];
    //提示框
    UIView *alerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 35)];
    alerView.layer.cornerRadius = 5.0f;
    alerView.backgroundColor = alertBG;
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:alerView.bounds];
    [tipLabel setFont:LPFont(15) color:kColorf0f0f0 alignment:NSTextAlignmentCenter];
    tipLabel.text = txt;
    [alerView addSubview:tipLabel];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:alerView];
    alerView.lp_midx();
    alerView.lp_midy();
    alerView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.1f animations:^{
        alerView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(continueTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3f animations:^{
                alerView.alpha = 0;
            } completion:^(BOOL finished) {
                [alerView removeFromSuperview];
            }];
        });
        
    }];
}


@end
