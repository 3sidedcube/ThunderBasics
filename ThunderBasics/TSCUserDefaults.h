//
//  TSCUserDefaults.h
//  ThunderStorm
//
//  Created by Matt Cheetham on 09/10/2013.
//  Copyright (c) 2013 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A convenience class for accessing user defaults. 
 This class saves everything as one big NSData object which obfuscates all the key values from the user
 */
@interface TSCUserDefaults : NSObject

/**
 The dictionary of objects saved into the defaults
 */
@property (nonatomic, strong) NSMutableDictionary *defaults;

/**
 Gets an object for a key which was previously saved to defaults
 @param key The key to lookup in the defaults dictionary
 */
- (id)objectForKey:(NSString *)key;

/**
 Sets an object for key in the dictionary and then saves it to defaults
 @param object The object to save to defaults. Must be NSCoding compliant
 @param key The key to save the object against
 */
- (void)setObject:(id)object forKey:(NSString *)key;

/**
 The shared controller that should be used to access defaults
 */
+ (instancetype)sharedController;

/**
 Stores a boolean for a key in the `NSUserDefaults`
 @param boolVal The value to store in the user defaults
 @param key The key to save the boolean under
 */
- (void)setBool:(BOOL)boolVal forKey:(NSString *)key;

/**
 Returns a boolean for a key from the `NSUserDefaults`
 @param key The key to return the boolean value from
 */
- (BOOL)boolForKey:(NSString *)key;

@end
