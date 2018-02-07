//
//  CAGradientLayer+AutoGradient.h
//  ThunderStorm
//
//  Created by Andrew Hart on 20/11/2013.
//  Copyright (c) 2013 3 SIDED CUBE. All rights reserved.
//

@import QuartzCore;
@import UIKit;

/**
 `CAGradientLayer+AutoGradient` is a category that generates `CAGradientLayer`s easily
 */
@interface CAGradientLayer (AutoGradient)

/**
 Returns a `CAGradientLayer` transitioning from one color to another. A transparent color can be parsed to create dark to translucent gradients.
 @param topColor The gradients top color represented as a `UIColor`. Starts at location 0.0
 @param bottomColor The gradients bottom color represented as a `UIColor`. Starts at location 1.0
 */
+ (CAGradientLayer *)generateGradientLayerWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor;

@end
