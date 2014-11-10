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

@end
