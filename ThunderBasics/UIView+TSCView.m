//
//  UIView+TSCResize.m
//  ThunderBasics
//
//  Created by Sam Houghton on 08/01/2015.
//  Copyright (c) 2015 3 SIDED CUBE. All rights reserved.
//

#import "UIView+TSCView.h"

@implementation UIView (TSCResize)

- (void)setHeight:(float)height
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (void)setWidth:(float)width
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (void)setX:(float)x
{
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setY:(float)y
{
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (void)setCenterX:(float)x
{
    self.center = CGPointMake(x, self.center.y);
}

- (void)setCenterY:(float)y
{
    self.center = CGPointMake(self.center.x, y);
}

- (CGFloat)heightOfSubviews
{
    if (self.subviews.count == 0) {
        return 0;
    }
    
    __block CGFloat highestY = -MAXFLOAT;
    __block CGFloat lowestYOrigin = MAXFLOAT;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        
        if (CGRectGetMaxY(view.frame) > highestY) {
            highestY = CGRectGetMaxY(view.frame);
        }
        
        if (view.frame.origin.y < lowestYOrigin) {
            lowestYOrigin = view.frame.origin.y;
        }
    }];
    
    return highestY - lowestYOrigin;
}

- (void)centerSubviewsVerticallyExcludingViews:(NSArray *)excludedViews
{
    [self centerSubviewsVerticallyExcludingViews:excludedViews withOffset:0];
}

- (void)centerSubviewsVerticallyExcludingViews:(NSArray *)excludedViews withOffset:(CGFloat)offset
{
    if (self.subviews.count == 0) {
        return;
    }
    
    CGFloat highestY = -MAXFLOAT;
    CGFloat lowestYOrigin = MAXFLOAT;
    
    for (UIView *view in self.subviews) {
        
        if (![excludedViews containsObject:view]) {
            
            if (CGRectGetMaxY(view.frame) > highestY) {
                highestY = CGRectGetMaxY(view.frame);
            }
            
            if (view.frame.origin.y < lowestYOrigin) {
                lowestYOrigin = view.frame.origin.y;
            }
        }
    }
    
    CGFloat height = highestY - lowestYOrigin;
    CGFloat yOffset = (self.bounds.size.height - height - offset)/2 - lowestYOrigin;
    
    for (UIView *view in self.subviews) {
        
        if (![excludedViews containsObject:view]) {
            
            CGRect viewFrame = view.frame;
            viewFrame.origin.y += yOffset;
            view.frame = viewFrame;
        }
    }
}

- (void)centerSubviewsVertically
{
    [self centerSubviewsVerticallyWithOffset:0];
}

- (void)centerSubviewsVerticallyWithOffset:(CGFloat)offset
{
    [self centerSubviewsVerticallyExcludingViews:nil withOffset:offset];
}

- (void)enumerateSubviewsUsingHandler:(TSCViewEnumerationHandler)handler
{
    [self enumerateSubviewsOfView:self usingHandler:handler];
}

- (void)enumerateSubviewsOfView:(UIView *)view usingHandler:(TSCViewEnumerationHandler)handler
{
    for (UIView *subview in view.subviews) { // I wrote this (Me, Simon)... Don't even ask me how it works! :D (Let's just pretend I know).
        
        __block BOOL stop = false;
        __block TSCViewEnumerationHandler block = handler;
        handler(subview, &stop);
        
        if (!stop) {
            
            [self enumerateSubviewsOfView:subview usingHandler:^(UIView *view, BOOL *shouldContinue) {
                
                block(view, &stop);
                *shouldContinue = stop;
            }];
            
            if (stop) {
                return;
            }
        } else {
            return;
        }
    }
}

@end
