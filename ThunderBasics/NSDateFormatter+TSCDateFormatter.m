//
//  NSDateFormatter+TSCDateFormatter.m
//  ThunderBasics
//
//  Created by Simon Mitchell on 20/03/2015.
//  Copyright (c) 2015 threesidedcube. All rights reserved.
//

#import "NSDateFormatter+TSCDateFormatter.h"


@implementation NSDateFormatter (TSCDateFormatter)

+ (NSString *)stringFromDate:(NSDate *)date withStrftimeFormat:(NSString *)format
{
    return [NSDateFormatter stringFromDate:date withStrftimeFormat:format usingBufferSize:256];
}

+ (NSString *)stringFromDate:(NSDate *)date withStrftimeFormat:(NSString *)format usingBufferSize:(NSInteger)bufferSize
{
    if (![date isKindOfClass:[NSDate class]]) {
        return nil;
    }
    
    time_t time = [date timeIntervalSince1970];
    struct tm timeStruct;
    localtime_r(&time, &timeStruct);
    char buffer[bufferSize];
    strftime(buffer, bufferSize, [format UTF8String], &timeStruct);
    return [NSString stringWithCString:buffer encoding:NSASCIIStringEncoding];
}

@end
