//
//  NSDate+TSCDate.h
//  Thunder Alert
//
//  Created by Phillip Caudell on 10/06/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDateRangeStartKey @"start"
#define kDateRangeEndKey @"end"

/** Options available when calculating a date range*/
typedef NS_OPTIONS(NSInteger, NSDateRangeOptions) {
    /** Include the original day in the date calculation*/
    NSDateRangeOptionIncludeOriginalDay = 1 << 1,
    /** Include the original week in the date calculation*/
    NSDateRangeOptionIncludeOriginalWeek = 1 << 2,
    /** Include the original month in the date calculation*/
    NSDateRangeOptionIncludeOriginalMonth = 1 << 3,
    /** Unknown */
    NSDateRangeOptionDirectionFuture = 1 << 6,
    /** Specifies that the week starts on a Sunday, not a Monday */
    NSDateRangeOptionWeekStartsOnSunday = 1 << 7
};

/**
 A wrapper on `NSDate` which allows useful methods for moving between `NSString` and `NSDate` representations of dates.
 */
@interface NSDate (TSCDate)

///---------------------------------------------------------------------------------------
/// @name String Representation
///---------------------------------------------------------------------------------------

/**
 Returns a date string formatted in the ISO8601 format.
 */
- (NSString *)ISO8601String;

/**
 Returns a date string formatted in the ISO8601 format without time zone information.
 */
- (NSString *)ISO8601StringWithOutLocal;

///---------------------------------------------------------------------------------------
/// @name NSDate Representation
///---------------------------------------------------------------------------------------

/**
 Returns an `NSDate` instance from a ISO6601 format date.
 @param string The date string to instantiate the `NSDate` from.
 */
+ (instancetype)dateWithISO8601String:(NSString *)string;

/**
 Returns an `NSDate` instance from a ISO6601 format date.
 @param string The date string to instantiate the `NSDate` from.
 @param considerLocale Whether time zone information should be considered while initialising.
 */
+ (instancetype)dateWithISO8601String:(NSString *)string considerLocale:(BOOL)considerLocale;

///---------------------------------------------------------------------------------------
/// @name Comparison
///---------------------------------------------------------------------------------------

/**
 Returns whether the instance of `NSDate` lies between two other `NSDates`.
 @param beginDate The lower bound on the test date range.
 @param endDate The higher bound on the test date range.
 */
- (BOOL)isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;

///---------------------------------------------------------------------------------------
/// @name Getting date ranges relative to date
///---------------------------------------------------------------------------------------

/**
 Returns a dictionary with a start and finish date for the specified range either before or after the date with the specified options
 
 the options parameter includes options such as including the current day in a week range e.t.c. or saying you want dates in the future.
 @param calendarUnit The calendar unit for which a date range should be returned for.
 @param options The options to be used when calculating the date range.
 */
- (NSDictionary <NSString *, NSDate *> *)dateRangeForCalendarUnit:(NSCalendarUnit)calendarUnit withOptions:(NSDateRangeOptions)options;

///---------------------------------------------------------------------------------------
/// @name Getting information about a date
///---------------------------------------------------------------------------------------

/**
 Returns the number of days in the week for the date
 */
- (NSInteger)daysInWeek;

/**
 Returns the number of days on the month for the date
 */
- (NSInteger)daysInMonth;

@end
