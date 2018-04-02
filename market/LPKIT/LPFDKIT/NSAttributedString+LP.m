//
//  NSAttributedString+LP.m
//
//
//  Created by Lipeng on 15/11/16.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import "NSAttributedString+LP.h"

@implementation NSAttributedString(LP)
- (CGSize)lpSizeWithMaxWidth:(CGFloat)width
{
    
    CGSize size = [self boundingRectWithSize:CGSizeMake(width,MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine
                                     context:nil].size;
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

- (CGFloat)lpHeightWithMaxWidth:(CGFloat)width
{
    return [self lpSizeWithMaxWidth:width].height;
}

+ (NSAttributedString *)string:(NSArray *)strings
                        colors:(NSArray *)colors
                         fonts:(NSArray *)fonts
{
    return [self string:strings colors:colors fonts:fonts lineHeight:0];
}

+ (NSAttributedString *)string:(NSArray *)strings
                        colors:(NSArray *)colors
                         fonts:(NSArray *)fonts
                    lineHeight:(CGFloat)lineHeight
{
    NSAssert(strings.count == colors.count && strings.count == fonts.count, @"string");
    
    return [self.class string:strings colors:colors fonts:fonts alignment:NSTextAlignmentCenter lineHeight:lineHeight breakMode:NSLineBreakByTruncatingTail];
}

+ (NSAttributedString *)attributedStrings:(NSArray *)strings
                        colors:(NSArray *)colors
                         fonts:(NSArray *)fonts
                    lineHeight:(CGFloat)lineHeight
{
    NSAssert(strings.count == colors.count && strings.count == fonts.count, @"string");
    return [self.class attributedStrings:strings colors:colors fonts:fonts lineHeight:lineHeight breakMode:NSLineBreakByTruncatingTail];
}


+ (NSAttributedString *)string:(NSArray *)strings
                        colors:(NSArray *)colors
                         fonts:(NSArray *)fonts
                     alignment:(NSTextAlignment)alignment
                    lineHeight:(CGFloat)lineHeight
                     breakMode:(NSLineBreakMode)breakMode
{
    NSAssert(strings.count == colors.count && strings.count == fonts.count, @"string");
    
    NSString *text = [NSString string];
    for (NSString *s in strings) {
        text = [text stringByAppendingString:s];
    }
    NSMutableAttributedString *atext = [[NSMutableAttributedString alloc] initWithString:text];
    CGFloat x = 0;
    for (int i = 0; i < strings.count; i++) {
        NSString *s = strings[i];
        [atext addAttributes:@{NSForegroundColorAttributeName:colors[i], NSFontAttributeName:fonts[i]}
                       range:NSMakeRange(x, s.length)];
        x += s.length;
    }
    NSMutableParagraphStyle * ps = [[NSMutableParagraphStyle alloc] init];
    ps.alignment = alignment;
    if (0 != lineHeight) {
        CGFloat fh = 0.f;
        for (UIFont *font in fonts) {
            fh = MAX(fh,font.lineHeight);
        }
        ps.lineSpacing = lineHeight-fh;
        ps.lineBreakMode = NSLineBreakByWordWrapping|breakMode;
    }
    [atext addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, atext.length)];
    return atext;
}

+ (NSAttributedString *)attributedStrings:(NSArray *)strings
                        colors:(NSArray *)colors
                         fonts:(NSArray *)fonts
                    lineHeight:(CGFloat)lineHeight
                     breakMode:(NSLineBreakMode)breakMode
{
    NSAssert(strings.count == colors.count && strings.count == fonts.count, @"string");
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    for (NSAttributedString *s in strings) {
        [text appendAttributedString:s];
    }
    CGFloat x = 0;
    for (int i = 0; i < strings.count; i++) {
        NSAttributedString *s = strings[i];
        [text addAttributes:@{NSForegroundColorAttributeName:colors[i], NSFontAttributeName:fonts[i]}
                       range:NSMakeRange(x, s.length)];
        x += s.length;
    }
    if (0 != lineHeight) {
        CGFloat fh=0.f;
        for (UIFont *font in fonts) {
            fh=MAX(fh,font.lineHeight);
        }
        NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
        ps.lineSpacing = lineHeight - fh;
        ps.lineBreakMode = NSLineBreakByWordWrapping|breakMode;
        [text addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, text.length)];
    }
    return text;
}
@end
