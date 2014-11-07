//
//  NSArray+TSCArray.h
//  Roboto Lite
//
//  Created by Phillip Caudell on 24/01/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

/** A category on `NSArray` which allows for easy serialization of `NSArray` objects */
@interface NSArray (TSCArray)

/**
 Serializes the objects within the `NSArray`.
 
 This method recurses through the Array serialising it's contained objects and returning them in an `NSArray`
 @see TSCObject
 */
- (NSArray *)serialisableRepresentation;

/**
 Returns a pretty printed JSON representation of the `NSArray`
 @discussion This method is useful for creating JSON representations of your model objects for use with a JSON API
 */
- (NSData *)JSONRepresentation;

/**
 Returns an `NSArray` by instantiating classes of a certain object using the `initWithDictionary:` method
 @param dictionaries The array of dictionaries to be initialised into objects of the defined `Class`
 @param classType The class type to initialize each object in the array as
 */
+ (NSArray *)arrayWithArrayOfDictionaries:(NSArray *)dictionaries rootInstanceType:(Class)classType;

@end
