//
//  NSArray+TSCArray.m
//  Roboto Lite
//
//  Created by Phillip Caudell on 24/01/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import "NSArray+TSCArray.h"
#import "TSCObject.h"

@implementation NSArray (TSCArray)

- (NSArray *)serialisableRepresentation
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (id object in self){
        
        if ([TSCObject isSerialisable:object]) {
            [array addObject:object];
        }
        
        if ([object respondsToSelector:@selector(serialisableRepresentation)]) {
            [array addObject:[(TSCObject *)object serialisableRepresentation]];
        }
    }
    
    return array;
}

- (NSData *)JSONRepresentation
{
    NSData *json = [NSJSONSerialization dataWithJSONObject:[self serialisableRepresentation] options:NSJSONWritingPrettyPrinted error:nil];
    return json;
}

@end
