//
//  NSString+LP.m
//
//
//  Created by Lipeng on 15/11/16.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import "NSString+LP.h"
#import "NSAttributedString+LP.h"
#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

@implementation NSString(LP)
- (CGSize)lpSizeWithFont:(UIFont *)font
{
    CGSize size = CGSizeZero;
    if ([self respondsToSelector:@selector(sizeWithFont:)]){
        size = [self sizeWithFont:font];
    }
    if ([self respondsToSelector:@selector(sizeWithAttributes:)]){
        size = [self sizeWithAttributes:@{NSFontAttributeName:font}];
    }
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

- (CGSize)lpSizeWithFont:(UIFont *)font maxWidth:(CGFloat)width
{
    CGSize size = CGSizeZero;
    if ([self respondsToSelector:@selector(sizeWithFont:constrainedToSize:lineBreakMode:)]){
        size = [self sizeWithFont:font constrainedToSize:CGSizeMake(width,CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    } else {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self];
        [text addAttributes:@{NSFontAttributeName:font} range:NSMakeRange(0,self.length)];
        return [text lpSizeWithMaxWidth:width];
    }
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

- (NSInteger)lpRowsWithFont:(UIFont *)font maxWidth:(CGFloat)width
{
    return ceilf([self lpSizeWithFont:font maxWidth:width].height/[UIUtil testHeightWithFont:font]);
}

- (CGFloat)lpHeightWithFont:(UIFont *)font maxWidth:(CGFloat)width lineHeight:(CGFloat)lineHeight
{
    return (ceilf([self lpRowsWithFont:font maxWidth:width]*lineHeight));
}

- (NSString *)URLEncodedString:(NSStringEncoding)encoding
{
    static NSString * const kAFLegalCharactersToBeEscaped = @"?!@#$^&%*+=,:;'\"`<>()[]{}/\\|~ ";
    
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, (CFStringRef)kAFLegalCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding)));
}

- (NSString *)URLDecodedString:(NSStringEncoding)encoding
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(encoding));
    
    return decodedString;
}
//过滤html转义
- (NSString *)testHTMLEscape
{
    if (NSNotFound==[self rangeOfString:@"\\&.*\\;" options:NSRegularExpressionSearch].location) {
        return self;
    }
    NSString *str=[self stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    str=[str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    str=[str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    str=[str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    str=[str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"="];
    
    return [str stringByReplacingOccurrencesOfString:@"\\&.*\\;" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0,str.length)];
}
- (NSNumber *)toNumber
{
    return [[[NSNumberFormatter alloc] init] numberFromString:self];
}

- (NSString *)getTimeFromTimeStamp
{
    //时间戳
    if (self.length<=0) {
        return @"";
    }
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval createTime = [self floatValue]/1000.f;
    // 时间差
    NSTimeInterval timeInterval = currentTime - createTime;
    
    int temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"一分钟内"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%d分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%d小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        NSDateFormatter *dataFromatter = [[NSDateFormatter alloc] init];
        [dataFromatter setDateFormat:@"MM-dd"];
        NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:createTime];
        result = [dataFromatter stringFromDate:fromDate];
    }
    return  result;
}
- (NSString *)MD5String:(NSStringEncoding)encoding
{
    const char *cString = [self cStringUsingEncoding:encoding];
    unsigned char result[16];
    CC_MD5(cString, strlen(cString), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}
@end
