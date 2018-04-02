//
//  LPAlertEditView.h
//  MDT
//
//  Created by Lipeng on 15/11/28.
//  Copyright (c) 2015年 West. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPAlertEditView : UIView
@property(nonatomic, readonly) UITextView *textView;
//最大字数
@property(nonatomic) NSInteger maxLength;
//提交时执行
@property(nonatomic, copy) void (^block)(NSString *text);
//添加提示语
- (void)addTipLabel:(UILabel *)tipLabel;

- (void)resetBackgroundColor;
@end
