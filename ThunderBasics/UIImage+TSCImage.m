//
//  UIImage+TSCImage.m
//  ThunderBasics
//
//  Created by Simon Mitchell on 21/01/2015.
//  Copyright (c) 2015 3 SIDED CUBE. All rights reserved.
//

#import "UIImage+TSCImage.h"

@implementation UIImage (TSCImage)

- (UIColor *)pixelColorForX:(NSInteger)x y:(NSInteger)y
{
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    
    int pixelInfo = ((self.size.width  * y) + x ) * 4; // The image is png
    
    int red = (int)data[pixelInfo];         // If you need this info, enable it
    int green = (int)data[(pixelInfo + 1)]; // If you need this info, enable it
    int blue = (int)data[pixelInfo + 2];    // If you need this info, enable it
    int alpha = (int)data[pixelInfo + 3];     // I need only this info for my maze game
    CFRelease(pixelData);
        
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f];
}

@end