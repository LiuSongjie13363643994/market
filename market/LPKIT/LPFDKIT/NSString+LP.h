//
//  NSString+LP.h
//
//
//  Created by Lipeng on 15/11/16.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(LP)
- (CGSize)lpSizeWithFont:(UIFont *)font;
- (CGSize)lpSizeWithFont:(UIFont *)font maxWidth:(CGFloat)width;
- (CGFloat)lpHeightWithFont:(UIFont *)font maxWidth:(CGFloat)width lineHeight:(CGFloat)lineHeight;
- (NSInteger)lpRowsWithFont:(UIFont *)font maxWidth:(CGFloat)width;
- (NSString *)URLEncodedString:(NSStringEncoding)encoding;
- (NSString *)URLDecodedString:(NSStringEncoding)encoding;
//过滤html转义
- (NSString *)testHTMLEscape;
- (NSNumber *)toNumber;
- (NSString *)getTimeFromTimeStamp;
- (NSString *)MD5String:(NSStringEncoding)encoding;

@end

#define LPStringRowsFontMaxWidthLineHeight(STRING,FONT,MAXWIDTH) [STRING lpRowsWithFont:FONT maxWidth:MAXWIDTH]
#define LPStringHeightFontMaxWidthLineHeight(STRING,FONT,MAXWIDTH,LINEHEIGHT) [STRING lpHeightWithFont:FONT maxWidth:MAXWIDTH lineHeight:LINEHEIGHT]
