//
//  UIView+TSCResize.h
//  ThunderBasics
//
//  Created by Sam Houghton on 08/01/2015.
//  Copyright (c) 2015 3 SIDED CUBE. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TSCViewEnumerationHandler)(UIView *view, BOOL *stop);

@interface UIView (TSCView)

- (void)setHeight:(float)height;

- (void)setWidth:(float)width;

- (void)setX:(float)x;

- (void)setY:(float)y;

- (void)setCenterX:(float)x;

- (void)setCenterY:(float)y;

- (void)enumerateSubviewsUsingHandler:(TSCViewEnumerationHandler)handler;

- (void)centerSubviewsVertically;

- (void)centerSubviewsVerticallyWithOffset:(CGFloat)offset;

- (void)centerSubviewsVerticallyExcludingViews:(NSArray *)excludedViews withOffset:(CGFloat)offset;

- (void)centerSubviewsVerticallyExcludingViews:(NSArray *)excludedViews;

- (CGFloat)heightOfSubviews;

@end
