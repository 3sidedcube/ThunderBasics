//
//  NSObject+AddedProperties.h
//  ThunderCloud
//
//  Created by Sam Houghton on 06/11/2014.
//  Copyright (c) 2014 threesidedcube. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A class for easily assigning and retrieving runtime properties on any subclass of `NSObject`
 */
@interface NSObject (AddedProperties)

/**
 Retrieves the object associated with the current instance for a given key
 @param key The key to return the associated object for
 */
- (id)associativeObjectForKey:(NSString *)key;

/**
 Sets an associated object on the current instance for a given key
 @param object The object to 'attach' to the current instance
 @param key The key to assign the the object to
 */
- (void)setAssociativeObject:(id)object forKey:(NSString *)key;

@end
