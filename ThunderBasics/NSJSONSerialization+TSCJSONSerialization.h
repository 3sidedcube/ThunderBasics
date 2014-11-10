//
//  NSJSONSerialization+TSCJSONSerialization.h
//  ThunderBasics
//
//  Created by Phillip Caudell on 19/02/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A category on NSJSONSerialization which implements wrapper methos for returning serialized JSON from a certain file in the system directory.
 */
@interface NSJSONSerialization (TSCJSONSerialization)

/**
 Returns a Foundation object for a certain resource of a certain filetype
 @param name the filename of the file to be JSON serialized
 @param type the file type of the file to be JSON serialized
 @param opt the options to be used when serializing the resource
 @param error returns any errors that were come across whilst serializing
 */
+ (id)JSONObjectWithResource:(NSString *)name ofType:(NSString *)type options:(NSJSONReadingOptions)opt error:(NSError **)error;

/**
 Returns a Foundation object for a certain file in the system directory
 @param path the file path of the file to be JSON serialized
 @param opt the options to be used when serializing the resource
 @param error returns any errors that were come across whilst serializing
 */
+ (id)JSONObjectWithFile:(NSString *)path options:(NSJSONReadingOptions)opt error:(NSError **)error;

@end
