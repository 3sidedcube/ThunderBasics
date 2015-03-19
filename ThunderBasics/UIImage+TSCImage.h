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
- (UIColor *)pixelColorForX:(NSInteger)x y:(NSInteger)y;

@end
