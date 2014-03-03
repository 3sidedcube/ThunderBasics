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
@property (nonatomic, strong) TSCContentController *contentController;
@property (nonatomic, strong) NSDictionary *languageDictionary;
@property (nonatomic, strong) NSString *languagesFolder;

+ (TSCLanguageController *)sharedController;
- (id)initWithContentController:(TSCContentController *)contentController;
- (void)loadLanguageFile:(NSString *)filePath;
- (NSString *)stringForKey:(NSString *)key;
- (NSString *)stringForDictionary:(NSDictionary *)dictionary;
- (NSString *)stringForKey:(NSString *)key withFallbackString:(NSString *)fallbackString;
- (void)reloadLanguagePack;
- (NSLocale *)localeForLanguageKey:(NSString *)localeString;
- (NSString *)localisedLanguageNameForLocale:(NSLocale *)locale;
- (NSString *)localisedLanguageNameForLocaleIdentifier:(NSString *)localeIdentifier;
- (NSLocale *)currentLocale;

@end
