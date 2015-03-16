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

/**
 `TSCLanguageController` is a wrapped for standard iOS localisation behaviour. It should be initialised with a key-value pair dictionary of localised strings which you can then easily pull the strings out of using the macros `TSCLanguageString()` and `TSCLanguageDictionary()`
 */
@interface TSCLanguageController : NSObject

/**
 @abstract A string representing the currently set language.
 */
@property (nonatomic, copy) NSString *currentLanguage;

/**
 @abstract A string representing the currently set language short key.
 */
@property (nonatomic, copy) NSString *currentLanguageShortKey;

/**
 @abstract The key-value pair dictionary of localised strings.
 */
@property (nonatomic, strong) NSDictionary *languageDictionary;

///---------------------------------------------------------------------------------------
/// @name Initializing `TSCLanguageController`
///---------------------------------------------------------------------------------------

/**
 Returns the current shared instance of the TSCLanguageController.
 */
+ (TSCLanguageController *)sharedController;

/**
 Initializes an instance of `TSCLanguageController`
 @param dictionary The key-value pair dictionary to be used by the `TSCLanguageController`
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;

///---------------------------------------------------------------------------------------
/// @name Retrieving Localised Strings
///---------------------------------------------------------------------------------------

/**
 Returns the localised string for the required key.
 @param key The key for which a localised string should be returned.
 */
- (NSString *)stringForKey:(NSString *)key;

/**
 Returns the localised string for the required key, with a fallback string if a localisation cannot be found in the key-value pair dictionary of localised strings
 @param key The key for which a localised string should be returned.
 @param fallbackString The fallback string to be used if the string doesn't exist in the key-value pair dictionary.
 */
- (NSString *)stringForKey:(NSString *)key withFallbackString:(NSString *)fallbackString;

/**
 Returns the correct localised string for a Storm text dictionary.
 @param dictionary the Storm text dictionary to pull a string out of.
 */
- (NSString *)stringForDictionary:(NSDictionary *)dictionary;

@end
