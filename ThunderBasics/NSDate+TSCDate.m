//
//  NSDate+TSCDate.m
//  Thunder Alert
//
//  Created by Phillip Caudell on 10/06/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import "NSDate+TSCDate.h"

@implementation NSDate (TSCDate)

- (NSString *)ISO8601String
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    
    return [dateFormatter stringFromDate:self];
}

- (NSString *)ISO8601StringWithOutLocal
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    
    return [dateFormatter stringFromDate:self];
}

+ (instancetype)dateWithISO8601String:(NSString *)string
{
    return [NSDate dateWithISO8601String:string considerLocale:YES];
}

+ (instancetype)dateWithISO8601String:(NSString *)string considerLocale:(BOOL)considerLocale
{
    NSString *dateFormatString;
    
    if (considerLocale) {
        
        dateFormatString = @"yyyy-MM-dd'T'HH:mm:ssZZZ";
        
    } else {
        
        dateFormatString = @"yyyy-MM-dd";
    }
    
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:dateFormatString];
    
    if ([dateFormat dateFromString:string]) {
        return [dateFormat dateFromString:string];
    }
    
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    return [dateFormat dateFromString:string];
}

- (BOOL)isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([self compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([self compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

- (NSDictionary *)dateRangeForCalendarUnit:(NSCalendarUnit)calendarUnit withOptions:(NSDateRangeOptions)options
{
    NSMutableDictionary *dateRange = [NSMutableDictionary new];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:self];
    
    if (options && options & NSDateRangeOptionWeekStartsOnSunday) {
        
    } else {
        
        if (dateComponents.weekday == 1) {
            dateComponents.weekday = [self daysInWeek];
        } else {
            dateComponents.weekday = dateComponents.weekday - 1;
        }
    }
    
    NSDateComponents *endComponents = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:self];
    NSDateComponents *startComponents = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:self];
    NSDateComponents *startDateComponentsToSubtract;
    NSDateComponents *endDateComponentsToSubtract;
    
    NSDate *startDate;
    NSDate *endDate;
    
    // At the moment we will always set the start date and end date hour and minute to the beginning/end of the day
    startComponents.hour = 0;
    startComponents.minute = 0;
    endComponents.hour = 23;
    endComponents.minute = 59;
    
    switch (calendarUnit) {
        case NSCalendarUnitWeekOfYear:
        case NSCalendarUnitWeekOfMonth:
            
            if (options && options & NSDateRangeOptionDirectionFuture) {
                
                // Calculate the difference in days between the current day and the beginning of the week
                endDateComponentsToSubtract = [NSDateComponents new];
                endDateComponentsToSubtract.day = ([self daysInWeek] - dateComponents.weekday);
            } else {
                
                // Calculate the difference in days between the current day and the beginning of the week
                startDateComponentsToSubtract = [NSDateComponents new];
                startDateComponentsToSubtract.day = - (dateComponents.weekday - calendar.firstWeekday);
            }
            
            if (options && options & NSDateRangeOptionIncludeOriginalDay) {
                
            } else {
                
                if (options & NSDateRangeOptionDirectionFuture) {
                    
                    // As long as we're not already the last day in the week then set start date to day after self
                    if ([dateComponents weekday] != [self daysInWeek]) {
                        
                        startDateComponentsToSubtract = [NSDateComponents new];
                        startDateComponentsToSubtract.day = 1;
                    }
                } else {
                    
                    // If we're asking for the last week without today and it's the first day in the week make sure to also reduce the start date to the start of said week.
                    endDateComponentsToSubtract = [NSDateComponents new];
                    endDateComponentsToSubtract.day = -1;
                    if (dateComponents.weekday == 1) {
                        
                        startDateComponentsToSubtract.day = startDateComponentsToSubtract.day - [self daysInWeek];
                    }
                }
            }
            break;
        case NSCalendarUnitMonth:
            
            if (options && options & NSDateRangeOptionDirectionFuture) {
                
                endComponents.day = [self daysInMonth];
                
                if ((options & NSDateRangeOptionIncludeOriginalWeek && options & NSDateRangeOptionIncludeOriginalDay) || options & NSDateRangeOptionIncludeOriginalDay) {
                    
                } else if (options & NSDateRangeOptionIncludeOriginalWeek) {
                    
                    NSInteger daysFromNowUntilEndOfWeek = ([self daysInWeek] - [dateComponents weekday]); // Make sure we won't be going beyond end of month (This would result in a start date later than begin date.)
                    
                    if (dateComponents.day + daysFromNowUntilEndOfWeek < [self daysInMonth]) {
                        
                        endDateComponentsToSubtract = [NSDateComponents new];
                        endDateComponentsToSubtract.day = ([self daysInWeek] - [dateComponents weekday]);
                    }
                } else {
                    
                    if (dateComponents.day < [self daysInMonth]) { // Make sure we don't go beyond the end of the month (This would result in a start date later than begin date.)
                        
                        startDateComponentsToSubtract = [NSDateComponents new];
                        startDateComponentsToSubtract.day = 1;
                    }
                }
                
            } else {
                startComponents.day = 1;
                
                if ((options & NSDateRangeOptionIncludeOriginalDay && options & NSDateRangeOptionIncludeOriginalWeek) || (options & NSDateRangeOptionIncludeOriginalDay)) { // End date should be the end of self
                    
                } else if (options & NSDateRangeOptionIncludeOriginalWeek) { // End date should be the end of yesterday
                    
                    if (dateComponents.day != 1) {
                        
                        endDateComponentsToSubtract = [NSDateComponents new];
                        endDateComponentsToSubtract.day = -1;
                    }
                } else {
                    
                    endDateComponentsToSubtract = [NSDateComponents new];
                    endDateComponentsToSubtract.day = - ([dateComponents weekday] - [calendar firstWeekday] + 1);
                    if (endDateComponentsToSubtract.day >= dateComponents.day) { // If we would be going to the previous month, let's stop ourselves
                        endDateComponentsToSubtract.day = (dateComponents.day - 1);
                    }
                }
            }
            break;
            
        case NSCalendarUnitYear:
            
            if (options && options & NSDateRangeOptionDirectionFuture) {
                
                
            } else {
                
                startComponents.day = 1;
                startComponents.month = 1;
                
                if (options && (options & NSDateRangeOptionIncludeOriginalMonth || options & NSDateRangeOptionIncludeOriginalWeek || options & NSDateRangeOptionIncludeOriginalDay)) {
                    
                } else {
                    
                    if (dateComponents.month == 1) {
                        
                        startComponents.year = dateComponents.year - 1;
                        endComponents.month = [self monthsInYear];
                        endComponents.year = dateComponents.year - 1;
                    } else {
                        endComponents.month = dateComponents.month - 1;
                    }
                    
                    NSDate *dateInPreviousMonth = [calendar dateFromComponents:endComponents];
                    endComponents.day = [dateInPreviousMonth daysInMonth];
                }
            }
        default:
            break;
    }
    
    if (!startDate) {
        startDate = [calendar dateFromComponents:startComponents];
    }
    
    if (!endDate) {
        endDate = [calendar dateFromComponents:endComponents];
    }
    
    if (startDateComponentsToSubtract) {
        startDate = [calendar dateByAddingComponents:startDateComponentsToSubtract toDate:startDate options:kNilOptions];
    }
    
    if (endDateComponentsToSubtract) {
        endDate = [calendar dateByAddingComponents:endDateComponentsToSubtract toDate:endDate options:kNilOptions];
    }
    
    if (startDate) {
        [dateRange setObject:startDate forKey:kDateRangeStartKey];
    }
    
    if (endDate) {
        [dateRange setObject:endDate forKey:kDateRangeEndKey];
    }
    
    return dateRange;
}

- (NSInteger)daysInMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
    return days.length;
}

- (NSInteger)daysInWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange days = [calendar maximumRangeOfUnit:NSCalendarUnitWeekday];
    return days.length;
}

- (NSInteger)monthsInYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange months = [calendar maximumRangeOfUnit:NSCalendarUnitMonth];
    return months.length;
}

@end
