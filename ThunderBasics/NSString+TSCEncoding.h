//
//  NSString+TSCEncoding.h
//  ThunderBasics
//
//  Created by Simon Mitchell on 09/01/2015.
//  Copyright (c) 2015 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TSCEncoding)

/**
 Encodes a string to remove characters incompatible with URL's
 @note Unsure why this exists, as `stringByAddingPercentEscapesUsingEncoding:` should have the same effect
 @return a URL encoded string
 */
- (NSString *)urlEncodedString;

/**
 Strips HTML from an NSString
 @return A string with no HTML tags in it
 */
- (NSString *)stringByStrippingHTML;

@end
