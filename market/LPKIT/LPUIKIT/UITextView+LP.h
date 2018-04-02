//
//  UITextView+LP.h
//  MDT
//
//  Created by Lipeng on 15/11/24.
//  Copyright (c) 2015年 West. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView(LP)

- (void)setFont:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment;
- (UILabel *)setPlaceHolder:(NSString *)placeHolder;
@end
