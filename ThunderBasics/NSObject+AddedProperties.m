//
//  TSCLocalisedObject.m
//  ThunderCloud
//
//  Created by Simon Mitchell on 05/11/2014.
//  Copyright (c) 2014 Sam Houghton. All rights reserved.
//

#import "NSObject+AddedProperties.h"
#import <objc/runtime.h>

@implementation NSObject (AddedProperties)

static char associativeObjectsKey;

- (id)associativeObjectForKey: (NSString *)key
{
    NSMutableDictionary *dict = objc_getAssociatedObject(self, &associativeObjectsKey);
    return [dict objectForKey: key];
}

- (void)setAssociativeObject:(id)object forKey:(NSString *)key
{
    NSMutableDictionary *dict = objc_getAssociatedObject(self, &associativeObjectsKey);
    
    if (!dict) {
        dict = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &associativeObjectsKey, dict, OBJC_ASSOCIATION_RETAIN);
    }
    
    if (object != nil) {
        [dict setObject: object forKey: key];
    } else {
        [dict removeObjectForKey:key];
    }
}

@end
