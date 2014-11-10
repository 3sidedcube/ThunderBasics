//
//  NSDate+TSCDate.h
//  Thunder Alert
//
//  Created by Phillip Caudell on 10/06/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@end
