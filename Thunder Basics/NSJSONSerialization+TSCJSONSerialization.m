//
//  NSJSONSerialization+TSCJSONSerialization.m
//  ThunderBasics
//
//  Created by Phillip Caudell on 19/02/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import "NSJSONSerialization+TSCJSONSerialization.h"

@implementation NSJSONSerialization (TSCJSONSerialization)

+ (id)JSONObjectWithResource:(NSString *)name ofType:(NSString *)type options:(NSJSONReadingOptions)opt error:(NSError *__autoreleasing *)error
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    
    return [self JSONObjectWithFile:path options:opt error:error];
}

+ (id)JSONObjectWithFile:(NSString *)path options:(NSJSONReadingOptions)opt error:(NSError **)error
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    return [self JSONObjectWithData:data options:opt error:error];
}

@end
