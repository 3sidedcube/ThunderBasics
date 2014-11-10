//
//  UIColor+TSCColor.h
//  Paperboy
//
//  Created by Phillip Caudell on 13/09/2013.
//  Copyright (c) 2013 3SIDEDCUBE. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 A wrapper on `UIColor` which adds useful methods.
 */
@interface UIColor (TSCColor)

/**
 Returns a UIColor for a given hex string.
 @param hexString The hex string to return a `UIColor` instance of.
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end
