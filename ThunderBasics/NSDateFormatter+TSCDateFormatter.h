//
//  NSDateFormatter+TSCDateFormatter.h
//  ThunderBasics
//
//  Created by Simon Mitchell on 20/03/2015.
//  Copyright (c) 2015 threesidedcube. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Adds additional date formatting methods to NSDateFormatter
 */
@interface NSDateFormatter (TSCDateFormatter)

/**
 Returns a string from an NSDate using a strftime format string
 @param date The date to return the string representation for
 @param format The strftime format to return the string in
 @discussion This calls `-stringFromDate:withStrftimeFormat:usingBufferSize:` with a pre-defined buffer size of 256
 */
+ (NSString *)stringFromDate:(NSDate *)date withStrftimeFormat:(NSString *)format;

/**
 Returns a string from an NSDate using a strftime format string
 @param date The date to return the string representation for
 @param format The strftime format to return the string in
 @param bufferSize The buffer size used to create the returned string
 @discussion The buffer is used to create a char array for the string returned from the strftime method
 */
+ (NSString *)stringFromDate:(NSDate *)date withStrftimeFormat:(NSString *)format usingBufferSize:(NSInteger)bufferSize;

@end
