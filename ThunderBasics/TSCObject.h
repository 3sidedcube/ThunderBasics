//
//  TSCObject.h
//  ThunderBasics
//
//  Created by Phillip Caudell on 18/02/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

/** A subclass of NSObject which allows for easy JSON serialization */
@interface TSCObject : NSObject

/**
 Serialises the object to an object which can be sent using a web request.
 @discussion As a base class `TSCObject` returns an `NSDictionary` containing all the properties on your subclass. Override this to implement custom serialisation.
 */
- (id)serialisableRepresentation;

/**
 Returns a pretty printed JSON representation of the `TSCObject`.
 @discussion This method is useful for creating JSON representations of your model objects for use with a JSON API.
 */
- (NSData *)JSONRepresentation;

/**
 Returns whether an object is serialisable by default.
 @discussion This method is useful for creating JSON representations of your model objects for use with a JSON API.
 @param object The object to test for serialisability.
 */
+ (BOOL)isSerialisable:(id)object;

/**
 @abstract The unique identifier for the `TSCObject`.
 @discussion This should always be non-nil.
 */
@property (nonatomic, strong) NSString *identifier;

///---------------------------------------------------------------------------------------
/// @name Initialization
///---------------------------------------------------------------------------------------

/**
 Initializes a `TSCObject` from it's dictionary representation.
 @discussion As a base class `TSCObject` this uses objective-c runtime to set properties on all objects inheriting from `TSCObject`.
 @param dictionary The dictionary to initialise the object with.
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
