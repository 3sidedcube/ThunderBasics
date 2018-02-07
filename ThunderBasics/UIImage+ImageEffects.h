//
//  UIImage+ImageEffects.h
//  ThunderStorm
//
//  Created by Sam Houghton on 18/11/2013.
//  Copyright (c) 2013 3 SIDED CUBE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageEffects)

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor; //Applies a blur
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor blur:(BOOL)withBlur;
- (UIImage *)convertImageToGrayScale;
- (UIImage *)applyEffectWithTint:(UIColor *)tintColor;

- (UIImage *)crop:(CGRect)rect;
- (UIImage *)cropToSquare;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

- (UIImage *)roundCorners:(UIRectCorner)corners withRadius:(float)radius;
- (UIImage *)roundCorners:(UIRectCorner)corners withRadius:(float)radius andSize:(CGSize)size;

@end
