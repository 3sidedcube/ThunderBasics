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
    if (self = [super init]) {
        
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

- (NSString *)currentLanguageShortKey
{
    // Getting the user locale
    NSLocale *locale = [NSLocale currentLocale];
    
    NSString *localeString = [locale localeIdentifier];
    
    // Re-arranging it to match the language pack filename
    NSArray *localeComponents = [[localeString lowercaseString] componentsSeparatedByString:@"_"];
    
    NSString *language;
    
    if (localeComponents && localeComponents.count > 1) {
        language = [localeComponents objectAtIndex:0];
    }
    
    return language;
}

@end
