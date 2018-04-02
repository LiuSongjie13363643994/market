//
//  UITextField+LP.m
//
//
//  Created by Lipeng on 15/11/21.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import "UITextField+LP.h"

@implementation UITextField(LP)


- (void)setClearButtonMode:(UITextFieldViewMode)clearButtonMode leftViewMode:(UITextFieldViewMode)leftViewMode
{
    self.clearButtonMode = clearButtonMode;
    self.leftViewMode    = leftViewMode;
}

- (void)setFont:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment
{
    self.font = font;
    self.textColor = color;
    self.textAlignment = alignment;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
}


- (void)setPlaceholder:(NSString *)placeholder
          keyboardType:(UIKeyboardType)keyboardType
         returnKeyType:(UIReturnKeyType)returnkeyType
{
    self.placeholder = placeholder;
    self.keyboardType = keyboardType;
    self.returnKeyType = returnkeyType;
}
@end
