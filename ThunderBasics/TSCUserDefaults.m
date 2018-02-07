//
//  TSCUserDefaults.m
//  ThunderStorm
//
//  Created by Matt Cheetham on 09/10/2013.
//  Copyright (c) 2013 3 SIDED CUBE. All rights reserved.
//

#import "TSCUserDefaults.h"
#define TSC_DEFAULTS_KEY @"TSCUserDefaultsKey"

@implementation TSCUserDefaults

static TSCUserDefaults *sharedController = nil;

+ (instancetype)sharedController
{
    @synchronized(self) {
        
        if (sharedController == nil) {
            sharedController = [[[self class] alloc] init];
        }
    }
    
    return sharedController;
}

- (instancetype)init
{
    if (self = [super init]) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:TSC_DEFAULTS_KEY]) {
            self.defaults = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:TSC_DEFAULTS_KEY]];
        } else {
            self.defaults = [NSMutableDictionary dictionary];
        }
    }
    
    return self;
}

- (id)objectForKey:(NSString *)key
{
    return self.defaults[key];
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    if (object) {
        [self.defaults setObject:object forKey:key];
    } else {
        [self.defaults removeObjectForKey:key];
    }
    [self synchronizeDefaults];
}

- (void)setBool:(BOOL)boolVal forKey:(NSString *)key
{
    NSNumber *boolNumber = [NSNumber numberWithBool:boolVal];
    [self setObject:boolNumber forKey:key];
}

- (BOOL)boolForKey:(NSString *)key
{
    NSNumber *boolNumber = [self objectForKey:key];
    
    if (!boolNumber) {
        return false;
    }
    return [boolNumber boolValue];
}

- (void)synchronizeDefaults
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.defaults] forKey:TSC_DEFAULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
