//
//  TSCLanguageController.m
//  ThunderStorm
//
//  Created by Phillip Caudell on 10/09/2013.
//  Copyright (c) 2013 3 SIDED CUBE. All rights reserved.
//

#import "TSCLanguageController.h"

@interface TSCLanguageController ()

@end

@implementation TSCLanguageController

static TSCLanguageController *sharedController = nil;

+ (TSCLanguageController *)sharedController
{
    return sharedController;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self) {
        
        self.languageDictionary = dictionary;
        
    }
    
    sharedController = self;
    
    return self;
}

#pragma mark - Lookup methods

- (NSString *)stringForKey:(NSString *)key
{
    return [self stringForKey:key withFallbackString:key];
}

- (NSString *)stringForKey:(NSString *)key withFallbackString:(NSString *)fallbackString
{
    NSString *languageString = self.languageDictionary[key];
    
    if (languageString && languageString.length > 0) {
        return languageString;
    } else {
        return fallbackString;
    }
}

- (NSString *)stringForDictionary:(NSDictionary *)dictionary
{
    if ((![dictionary isEqual:[NSNull null]]) && dictionary) {
        return [self stringForKey:dictionary[@"content"] withFallbackString:nil];
    }
    
    return nil;
}

@end
