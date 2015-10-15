//
//  UIWindow+VisibleViewController.h
//  ThunderBasics
//
//  Created by Simon Mitchell on 15/10/2015.
//  Copyright © 2015 threesidedcube. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 A category on UIWindow which allows easy accesss to the currently visible view controller
 */
@interface UIWindow (VisibleViewController)

@property (nonatomic, weak, readonly) UIViewController *visibleViewController;

@end
