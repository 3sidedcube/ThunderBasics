//
//  TSCLanguageController.h
//  ThunderStorm
//
//  Created by Phillip Caudell on 10/09/2013.
//  Copyright (c) 2013 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TSCLanguageString(key) [[TSCLanguageController sharedController] stringForKey:(key)]
#define TSCLanguageDictionary(dictionary) [[TSCLanguageController sharedController] stringForDictionary:(dictionary)]

@interface TSCLanguageController : NSObject

@property (nonatomic, strong) NSString *currentLanguage;

+ (TSCLanguageController *)sharedController;
- (NSString *)stringForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key withFallbackString:(NSString *)fallbackString;
- (NSString *)stringForDictionary:(NSDictionary *)dictionary;
- (NSLocale *)localeForLanguageKey:(NSString *)localeString;
- (NSString *)localisedLanguageNameForLocale:(NSLocale *)locale;
- (NSString *)localisedLanguageNameForLocaleIdentifier:(NSString *)localeIdentifier;
- (NSLocale *)currentLocale;

@end
