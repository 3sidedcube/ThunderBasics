//
//  NSDictionary+TSCDictionary.m
//  Roboto Lite
//
//  Created by Phillip Caudell on 31/01/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import "NSDictionary+TSCDictionary.h"
#import "TSCObject.h"

@implementation NSDictionary (TSCDictionary)

- (NSDictionary *)serialisableRepresentation
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for (NSString *key in self.allKeys) {
        
        id object = self[key];
        
        if ([TSCObject isSerialisable:object]) {
            dictionary[key] = object;
        }
        
        if ([object respondsToSelector:@selector(serialisableRepresentation)]) {
            dictionary[key] = [(TSCObject *)object serialisableRepresentation];
        }
    }
    
    return dictionary;
}

- (NSData *)JSONRepresentation
{
    NSData *json = [NSJSONSerialization dataWithJSONObject:[self serialisableRepresentation] options:NSJSONWritingPrettyPrinted error:nil];
    return json;
}

@end
