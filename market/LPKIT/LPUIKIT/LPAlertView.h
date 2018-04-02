//
//  LPAlertView.h
//  MDT
//
//  Created by Lipeng on 15/11/28.
//  Copyright (c) 2015年 West. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPAlertView : UIAlertView
//
+ (id)alertViewWithTitle:(NSString *)title
             message:(NSString *)message
     completionBlock:(void (^)(NSUInteger buttonIndex))block
   cancelButtonTitle:(NSString *)cancelButtonTitle
   otherButtonTitles:(NSString *)otherButtonTitles, ...;

+ (void)know:(NSString *)txt block:(void (^)(void))block;
+ (void)sure:(NSString *)txt block:(void (^)(void))block;
+ (void)confirm:(NSString *)txt block:(void (^)(void))block;
+ (void)tip:(NSString *)txt;
@end
