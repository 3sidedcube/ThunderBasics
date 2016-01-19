//
//  CAGradientLayer+AutoGradient.m
//  ThunderStorm
//
//  Created by Andrew Hart on 20/11/2013.
//  Copyright (c) 2013 3 SIDED CUBE. All rights reserved.
//

#import "CAGradientLayer+AutoGradient.h"

@implementation CAGradientLayer (AutoGradient)

+ (CAGradientLayer *)generateGradientLayerWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor
{
    NSArray *colors = [NSArray arrayWithObjects:(id)topColor.CGColor, bottomColor.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}

@end
