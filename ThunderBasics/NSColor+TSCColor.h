//
//  NSColor+TSCColor.h
//  ThunderBasics
//
//  Created by Simon Mitchell on 09/05/2015.
//  Copyright (c) 2015 3 SIDED CUBE. All rights reserved.
//

#import <Cocoa/Cocoa.h>
/**
 A wrapper on `NSColor` which adds useful methods.
 */
@interface NSColor (TSCColor)

/**
 Returns a UIColor for a given hex string.
 @param hexString The hex string to return a `UIColor` instance of.
 */
+ (NSColor *)colorWithHexString:(NSString *)hexString;

@end
