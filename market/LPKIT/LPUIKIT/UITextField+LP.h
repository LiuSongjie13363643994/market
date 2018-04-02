//
//  UITextField+LP.h
//
//
//  Created by Lipeng on 15/11/21.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField(LP)
- (void)setClearButtonMode:(UITextFieldViewMode)clearButtonMode leftViewMode:(UITextFieldViewMode)leftViewMode;
- (void)setFont:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment;
- (void)setPlaceholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType returnKeyType:(UIReturnKeyType)returnkeyType;
@end
