//
//  NSDate+LP.h
//  Wall
//
//  Created by Lipeng on 16/9/6.
//  Copyright © 2016年 Lipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(LP)
- (NSString *)stringWithFormat:(NSString *)format;
- (BOOL)isToday;
- (BOOL)isYesterday;
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)weekOfYear;
- (NSInteger)weekday;
- (NSInteger)monthIntervals:(NSDate *)date;
- (NSDate *)dateWithMonthInterval:(NSInteger)month;
- (NSDate *)nextDay;
- (NSDate *)yesterday;
- (NSDate *)thedaybeforeyesterday;
- (NSDate *)nextMonth;
- (NSDate *)nextWeek;
- (NSString *)yyyyMMddHHmmssString;
- (NSString *)dateString:(NSString *)md ymd:(NSString *)ymd;
@end

#define kDUDateFormatyyyyMMdd @"yyyy-MM-dd"
#define kDUDateFormatyyyyMMddhhmmss @"yyyy-MM-dd hh:mm:ss"
#define kDUDateFormatyyyyMMddHHmmss @"yyyy-MM-dd HH:mm:ss"
#define kDUDateFormatyyyyMMddhhmm @"yyyy-MM-dd hh:mm"
#define kDUDateFormatyyyyMMddHHmm @"yyyy-MM-dd HH:mm"

#define kDUyyyyMMddString(DATE) [DATE stringWithFormat:kDUDateFormatyyyyMMdd]
#define kDUyyyyMMddhhMMssString(DATE) [DATE stringWithFormat:kDUDateFormatyyyyMMddhhmmss]
#define kDUyyyyMMddHHMMssString(DATE) [DATE stringWithFormat:kDUDateFormatyyyyMMddHHmmss]

#define kDUyyyyMMddhhMMString(DATE) [DATE stringWithFormat:kDUDateFormatyyyyMMddhhmm]
#define kDUyyyyMMddHHMMString(DATE) [DATE stringWithFormat:kDUDateFormatyyyyMMddHHmm]

#define kHHmmString(DATE) [DATE stringWithFormat:@"HH:mm"]
#define kMMYUEddRIString(DATE) [DATE stringWithFormat:@"M月d日"]

#define yyyyMMdd @"yyyyMMdd"
