//
//  TSCLanguageController.m
//  ThunderStorm
//
//  Created by Phillip Caudell on 10/09/2013.
//  Copyright (c) 2013 3 SIDED CUBE. All rights reserved.
//

#import "TSCLanguageController.h"

@interface TSCLanguageController ()

@property (nonatomic, strong) NSDictionary *languageDictionary;

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
    return [self stringForKey:key withFallbackString:nil];
}

- (NSString *)stringForKey:(NSString *)key withFallbackString:(NSString *)fallbackString
{
    NSString *languageString = self.languageDictionary[key];
    
    if (languageString) {
        return languageString;
    } else {
        return fallbackString;
    }
}

- (NSString *)stringForDictionary:(NSDictionary *)dictionary
{
    if (![dictionary isEqual:[NSNull null]]) {
        return [self stringForKey:dictionary[@"content"] withFallbackString:nil];
    }
    
    return nil;
}

#pragma mark - Locale management

- (NSLocale *)localeForLanguageKey:(NSString *)localeString
{
    NSArray *localeComponents = [localeString componentsSeparatedByString:@"_"];
    
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:[NSLocale localeIdentifierFromComponents:@{NSLocaleLanguageCode: localeComponents[1], NSLocaleCountryCode: localeComponents[0]}]];
    
    return locale;
}

- (NSString *)localisedLanguageNameForLocale:(NSLocale *)locale
{
    return [locale displayNameForKey:NSLocaleIdentifier value:locale.localeIdentifier];
}

- (NSString *)localisedLanguageNameForLocaleIdentifier:(NSString *)localeIdentifier
{
    return [self localisedLanguageNameForLocale:[self localeForLanguageKey:localeIdentifier]];
}

- (NSLocale *)currentLocale
{
    return [self localeForLanguageKey:self.currentLanguage];
}

@end
