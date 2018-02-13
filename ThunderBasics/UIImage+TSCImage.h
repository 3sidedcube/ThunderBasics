//
//  UIImage+TSCImage.h
//  ThunderBasics
//
//  Created by Simon Mitchell on 21/01/2015.
//  Copyright (c) 2015 3 SIDED CUBE. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This category adds methods for UIImage such as the ability to identify an individual pixel in the image
 */
@interface UIImage (TSCImage)

/**
 Looks up a specific pixel in an image and gets it's color
 @param x The pixel to select on the horizontal axis
 @param y The pixel to select on the vertical axis
 @return The color of the selected pixel
 */
- (UIColor * _Nonnull)pixelColorForX:(NSInteger)x y:(NSInteger)y;

/**
 Gets an image with a certain name and tints it with the required color
 @param name The name of the image to pull from the app
 @param color The color to tint the returned image
 */
+ (UIImage * _Nullable)imageNamed:(NSString * _Nonnull)name withColor:(UIColor * _Nonnull)color;

/**
 Gets an image with a certain name and tints it with the required color
 @param name The name of the image to pull from the app
 @param bundle The bundle to look for the image in
 @param traitCollection The trait collection to pull the image for
 @param color The color to tint the returned image
 */
+ (UIImage * _Nullable)imageNamed:(NSString * _Nonnull)name inBundle:(NSBundle * _Nullable)bundle compatibleWithTraitCollection:(UITraitCollection * _Nullable)traitCollection withColor:(UIColor * _Nonnull)color;

@end
