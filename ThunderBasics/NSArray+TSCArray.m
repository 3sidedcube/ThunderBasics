//
//  NSArray+TSCArray.m
//  Roboto Lite
//
//  Created by Phillip Caudell on 24/01/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import "NSArray+TSCArray.h"
#import "TSCObject.h"

@import os.log;

static os_log_t ui_log;

@implementation NSArray (TSCArray)

// Set up the logging component before it's used.
+ (void)initialize {
    ui_log = os_log_create("com.threesidedcube.ThunderCloud", "NSArray+TSCArray");
}

- (NSArray *)serialisableRepresentation
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (id object in self){
        
        if ([TSCObject isSerialisable:object]) {
            [array addObject:object];
        }
        
        if ([object respondsToSelector:@selector(serialisableRepresentation)]) {
            id tscObject = [(TSCObject *)object serialisableRepresentation];
            
            if (tscObject) {
                [array addObject:tscObject];
            } else {
                os_log_debug(ui_log, "failed to serialize object : %@. Some required data may not be being sent to the server.",object);
            }
        }
    }
    
    return array;
}

- (NSData *)JSONRepresentation
{
    NSData *json = [NSJSONSerialization dataWithJSONObject:[self serialisableRepresentation] options:NSJSONWritingPrettyPrinted error:nil];
    return json;
}

+ (NSArray *)arrayWithArrayOfDictionaries:(NSArray *)dictionaries rootInstanceType:(Class)classType
{
    if (![classType instancesRespondToSelector:@selector(initWithDictionary:)]) {
        return nil;
    }
    
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:dictionaries.count];
    
    for (NSDictionary *dictionary in dictionaries) {
        
        id object = [[classType alloc] initWithDictionary:dictionary];
        [objects addObject:object];
    }
    
    return objects;
}

- (NSArray *)reverse
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    
    for (id element in enumerator) {
        [array addObject:element];
    }
    
    return [NSArray arrayWithArray:array];
}

@end
