//
//  TSCObject.m
//  ThunderBasics
//
//  Created by Phillip Caudell on 18/02/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import "TSCObject.h"
#import <objc/runtime.h>

@implementation TSCObject

- (id)init
{
    if (self = [super init]) {
        
        self.identifier = [[NSUUID UUID] UUIDString];
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [self init]) {
        
        [self TSC_setPropertiesWithDictionary:dictionary];
    }
    
    return self;
}

- (void)TSC_setPropertiesWithDictionary:(NSDictionary *)dictionary
{
    for (NSString *key in dictionary.allKeys) {
        
        if ([self respondsToSelector:NSSelectorFromString(key)]) {
            [self setValue:dictionary[key] forKey:key];
        }
    }
}

- (NSDictionary *)serialisableRepresentation
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
    
    for (NSUInteger i = 0; i < numberOfProperties; i++) {
        
        objc_property_t property = propertyArray[i];
        NSString *propertyName = [[NSString alloc] initWithUTF8String:property_getName(property)];
        id object = [self valueForKey:propertyName];
        
        if ([object isKindOfClass:[NSDate class]]) {
            NSNumber *timestamp = @([(NSDate *)object timeIntervalSince1970]);
            [dictionary setObject:timestamp forKey:propertyName];
        }
        
        if ([TSCObject isSerialisable:object]) {
            [dictionary setObject:object forKey:propertyName];
        }
        
        if ([object respondsToSelector:@selector(dictionaryRepresentation)]) {
            [dictionary setObject:[(TSCObject *)object serialisableRepresentation] forKey:propertyName];
        }
    }
    
    // Because we've dipped down to the run time, looping through properties won't return this on classes that inherit from it, and quite frankly; fuck knows why.
    if (self.identifier) {
        [dictionary setObject:self.identifier forKey:@"identifier"];
    }
    
    free(propertyArray);
    
    return dictionary;
}

- (NSData *)JSONRepresentation
{
    return [NSJSONSerialization dataWithJSONObject:[self serialisableRepresentation] options:NSJSONWritingPrettyPrinted error:nil];
}

+ (BOOL)isSerialisable:(id)object
{
    if ([object isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if ([object isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    
    return NO;
}

@end
