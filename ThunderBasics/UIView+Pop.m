//
//  UIView+Pop.m
//  ThunderStorm
//
//  Created by Andrew Hart on 20/11/2013.
//  Copyright (c) 2013 3 SIDED CUBE. All rights reserved.
//

#import "UIView+Pop.h"

@implementation UIView (Pop)

- (void)popIn
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(0.1, 0.1, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.1, 1.1, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.95, 0.95, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
    
    NSArray *frameValues = @[[NSValue valueWithCATransform3D:scale1],
                             [NSValue valueWithCATransform3D:scale2],
                             [NSValue valueWithCATransform3D:scale3],
                             [NSValue valueWithCATransform3D:scale4]];
    [animation setValues:frameValues];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 0.9;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)popOut
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(1.0, 1.0, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.01, 0.01, 1);
    
    NSArray *frameValues = @[[NSValue valueWithCATransform3D:scale1],
                             [NSValue valueWithCATransform3D:scale3]];
    [animation setValues:frameValues];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 0.2;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self.layer addAnimation:animation forKey:nil];
}

@end
