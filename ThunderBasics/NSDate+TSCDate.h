//
//  NSDate+TSCDate.h
//  Thunder Alert
//
//  Created by Phillip Caudell on 10/06/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TSCDate)

- (NSString *)ISO8601String;
- (NSString *)ISO8601StringWithOutLocal;
+ (instancetype)dateWithISO8601String:(NSString *)string;
+ (instancetype)dateWithISO8601String:(NSString *)string considerLocale:(BOOL)considerLocale;
- (BOOL)isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;

@end
