//
//  UIViewController+Dismiss.h
//  ThunderBasics
//
//  Created by Simon Mitchell on 15/10/2015.
//  Copyright © 2015 threesidedcube. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 A category for easier dismissal of view controllers in a target selector situation
 */
@interface UIViewController (Dismiss)

/**
 Dismisses the view controller in an animated manner
 */
- (void)dismissAnimated;

@end
