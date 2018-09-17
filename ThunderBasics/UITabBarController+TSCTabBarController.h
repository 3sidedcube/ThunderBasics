//
//  UITabBarController+TSCTabBarController.h
//  ThunderBasics
//
//  Created by Phillip Caudell on 27/05/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 A wrapper class on UITabBarController which allows for easy implementation of `UINavigationControllers` within the tabs of the `UITabBarController`.
 */
@interface UITabBarController (TSCTabBarController)

///---------------------------------------------------------------------------------------
/// @name Initializing
///---------------------------------------------------------------------------------------

/**
 Initializes a `UITabBarController` with an array of `UIViewControllers`.
 @param viewControllers The `UIViewControllers` to be displayed in the `UITabBarController`.
 @param nest Whether the `UIViewControllers` should be nested in `UINavigationController` instances or not.
 */
- (instancetype)initWithViewControllers:(NSArray <UIViewController *> *)viewControllers nestInsideNavigationControllers:(BOOL)nest;

@end
