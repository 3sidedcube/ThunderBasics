//
//  NSView+TSCView.h
//  ThunderBasics
//
//  Created by Simon Mitchell on 19/09/2015.
//  Copyright © 2015 3 SIDED CUBE. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void (^TSCViewEnumerationHandler)(NSView *view, BOOL *stop);

@interface NSView (TSCView)

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
