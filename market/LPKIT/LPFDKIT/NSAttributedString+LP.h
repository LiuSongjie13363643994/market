//
//  NSAttributedString+LP.h
//
//
//  Created by Lipeng on 15/11/16.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString(LP)

- (CGSize)lpSizeWithMaxWidth:(CGFloat)width;

- (CGFloat)lpHeightWithMaxWidth:(CGFloat)width;

+ (NSAttributedString *)string:(NSArray *)strings
                        colors:(NSArray *)colors
                         fonts:(NSArray *)fonts;

+ (NSAttributedString *)string:(NSArray *)strings
                        colors:(NSArray *)colors
                         fonts:(NSArray *)fonts
                    lineHeight:(CGFloat)lineHeight;
+ (NSAttributedString *)string:(NSArray *)strings
                        colors:(NSArray *)colors
                         fonts:(NSArray *)fonts
                     alignment:(NSTextAlignment)alignment
                    lineHeight:(CGFloat)lineHeight
                     breakMode:(NSLineBreakMode)breakMode;

+ (NSAttributedString *)attributedStrings:(NSArray *)strings
                                   colors:(NSArray *)colors
                                    fonts:(NSArray *)fonts
                               lineHeight:(CGFloat)lineHeight;
@end
