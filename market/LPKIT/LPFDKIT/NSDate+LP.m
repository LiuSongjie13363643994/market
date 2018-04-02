//
//  NSDate+LP.m
//  Wall
//
//  Created by Lipeng on 16/9/6.
//  Copyright © 2016年 Lipeng. All rights reserved.
//

#import "NSDate+LP.h"

@implementation NSDate(LP)
- (NSString *)stringWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    dateFormatter.locale=[[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:self];
    return destDateString;
}
- (BOOL)isToday
{
    NSDate *now=[NSDate date];
    NSInteger unit=NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekOfYear;
    NSDateComponents *now_coms=[[NSCalendar currentCalendar] components:unit fromDate:now];
    NSDateComponents *coms=[[NSCalendar currentCalendar] components:unit fromDate:self];
    
    return (now_coms.year==coms.year && now_coms.month==coms.month && now_coms.day==coms.day);
}
- (BOOL)isYesterday
{
    NSDate *yesterday=[NSDate dateWithTimeIntervalSince1970:[NSDate date].timeIntervalSince1970-24*60*60];
    
    NSInteger unit=NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekOfYear;
    NSDateComponents *ystd_coms=[[NSCalendar currentCalendar] components:unit fromDate:yesterday];
    NSDateComponents *coms=[[NSCalendar currentCalendar] components:unit fromDate:self];
    return (ystd_coms.year==coms.year && ystd_coms.month==coms.month && ystd_coms.day==coms.day);
}
- (NSInteger)year
{
    NSDateComponents *coms=[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
    return coms.year;
}
- (NSInteger)month
{
    NSDateComponents *coms=[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self];
    return coms.month;
}
- (NSInteger)day
{
    NSDateComponents *coms=[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self];
    return coms.day;
}
- (NSInteger)weekOfYear
{
    NSDateComponents *coms=[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self];
    return coms.weekOfYear;
}
- (NSInteger)weekday
{
    NSDateComponents *coms=[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    return coms.weekday;
}
- (NSInteger)hour
{
    NSDateComponents *coms=[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self];
    return coms.hour;
}
- (NSInteger)monthIntervals:(NSDate *)date
{
    return (self.year*12+self.month)-(date.year*12+date.month);
}
- (NSDate *)dateWithMonthInterval:(NSInteger)month
{
    NSInteger unit=NSCalendarUnitYear|NSCalendarUnitMonth;
    NSDateComponents *coms=[[NSCalendar currentCalendar] components:unit fromDate:self];
    coms.month+=month;
    return [[NSCalendar currentCalendar] dateFromComponents:coms];
}
- (NSDate *)nextDay
{
    NSInteger unit=NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *coms=[[NSCalendar currentCalendar] components:unit fromDate:self];
    coms.day+=1;
    return [[NSCalendar currentCalendar] dateFromComponents:coms];
}
- (NSDate *)yesterday
{
    NSInteger unit=NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *coms=[[NSCalendar currentCalendar] components:unit fromDate:self];
    coms.day-=1;
    return [[NSCalendar currentCalendar] dateFromComponents:coms];
}
- (NSDate *)thedaybeforeyesterday
{
    NSInteger unit=NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *coms=[[NSCalendar currentCalendar] components:unit fromDate:self];
    coms.day-=2;
    return [[NSCalendar currentCalendar] dateFromComponents:coms];
}
- (NSDate *)nextMonth
{
    NSInteger unit=NSCalendarUnitYear|NSCalendarUnitMonth;
    NSDateComponents *coms=[[NSCalendar currentCalendar] components:unit fromDate:self];
    coms.month+=1;
    NSDate *date=[[NSCalendar currentCalendar] dateFromComponents:coms];
    return date;
}
- (NSDate *)nextWeek
{
    return [self dateByAddingTimeInterval:7*24*60*60];
}
- (NSString *)yyyyMMddHHmmssString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [df stringFromDate:self];
}


- (NSString *)dateString:(NSString *)md ymd:(NSString *)ymd
{
    NSDate *now = [NSDate date];
    NSString *txt = nil;
    if (self.isToday) {
        txt = @"今天";
    } else if (self.isYesterday){
        txt = @"昨天";
    } else if (self.year == now.year && self.weekOfYear == now.weekOfYear) {
        NSArray *a = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
        txt = a[self.weekday - 1];
    } else if (self.year == now.year){
        txt = [self stringWithFormat:md];
    } else {
        txt = [self stringWithFormat:(ymd.length > 0) ? ymd : md];
    }
    
    return txt;

}
@end
