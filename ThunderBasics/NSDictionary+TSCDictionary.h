//
//  NSDictionary+TSCDictionary.h
//  Roboto Lite
//
//  Created by Phillip Caudell on 31/01/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

/** A category on `NSDictionary` which allows for easy serialization of `NSDictionary` objects */
@interface NSDictionary (TSCDictionary)

/**
 Serializes the objects within the `NSDictionary`.
 *
 This method recurses through the Array serialising it's contained objects and returning them in an `NSArray`
 @see TSCObject
 */
- (NSDictionary *)serialisableRepresentation;

/**
 Returns a pretty printed JSON representation of the `NSDictionary`
 @discussion This method is useful for creating JSON representations of your model objects for use with a JSON API
 */
- (NSData *)JSONRepresentation;

@end
