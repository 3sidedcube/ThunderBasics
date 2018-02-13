//
//  UIView+Pop.h
//  ThunderStorm
//
//  Created by Andrew Hart on 20/11/2013.
//  Copyright (c) 2013 3 SIDED CUBE. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 `UIView+Pop` A simple pop animation that can be performed on a view
 */
@interface UIView (Pop)

/**
 @abstract Pops a view inwards, the view will contract inwards then expand back to its original size
 */
- (void)popIn;

/**
 @abstract Pops a view outwards, the view will expand outwards then contract back to its original size
 */
- (void)popOut;

@end
