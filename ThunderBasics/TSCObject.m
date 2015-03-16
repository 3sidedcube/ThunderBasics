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

- (instancetype)init
{
    if (self = [super init]) {
        
        self.identifier = [[NSUUID UUID] UUIDString];
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [self init]) {
        
        [self TSC_setPropertiesWithDictionary:dictionary];
    }
    
    return self;
}

- (void)TSC_setPropertiesWithDictionary:(NSDictionary *)dictionary
{
    for (NSString *key in dictionary.allKeys) {
        
        NSString *keyName = nil;
        
        if ([key isEqualToString:@"class"]) {
            keyName = @"className";
        } else if ([key isEqualToString:@"hash"]) {
            keyName = @"objectHash";
        } else if ([key isEqualToString:@"debugDescription"]) {
            keyName = @"objectDebugDescription";
        } else if ([key isEqualToString:@"description"]) {
            keyName = @"objectDescription";
        } else {
            keyName = key;
        }
        
        if ([self respondsToSelector:NSSelectorFromString(keyName)]) {
            [self setValue:dictionary[key] forKey:keyName];
        } else {
            
            NSString *firstLetter = [[keyName substringToIndex:1] lowercaseString];
            NSString *lowercaseKey = [keyName substringFromIndex:1];
            lowercaseKey = [NSString stringWithFormat:@"%@%@",firstLetter,lowercaseKey];
            
            if ([self respondsToSelector:NSSelectorFromString(lowercaseKey)]) {
                [self setValue:dictionary[key] forKey:lowercaseKey];
            }
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
        
        if ([propertyName isEqualToString:@"className"]) {
            propertyName = @"class";
        } else if ([propertyName isEqualToString:@"objectHash"]) {
            propertyName = @"hash";
        } else if ([propertyName isEqualToString:@"objectDebugDescription"]) {
            propertyName = @"debugDescription";
        } else if ([propertyName isEqualToString:@"objectDescription"]) {
            propertyName = @"description";
        }
        
        if ([object isKindOfClass:[NSDate class]]) {
            NSNumber *timestamp = @([(NSDate *)object timeIntervalSince1970]);
            [dictionary setObject:timestamp forKey:propertyName];
        }
        
        if ([TSCObject isSerialisable:object]) {
            [dictionary setObject:object forKey:propertyName];
        }
        
        if ([object respondsToSelector:@selector(serialisableRepresentation)]) {
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

- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context
{
    @try {
        [super removeObserver:observer forKeyPath:keyPath context:context];
    }
    @catch (NSException *exception) {
        NSLog(@"Failed to remove observer with exception : %@",exception);
    }
}

- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    @try {
        [super removeObserver:observer forKeyPath:keyPath];
    }
    @catch (NSException *exception) {
        NSLog(@"Failed to remove observer with exception : %@",exception);
    }
}

@end
