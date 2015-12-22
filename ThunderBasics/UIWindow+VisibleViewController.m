//
//  UIWindow+VisibleViewController.m
//  ThunderBasics
//
//  Created by Simon Mitchell on 15/10/2015.
//  Copyright © 2015 threesidedcube. All rights reserved.
//

#import "UIWindow+VisibleViewController.h"

typedef void (^TSCNavigationViewControllerRecursion)(UIViewController *visibleViewController, UINavigationController *navigationController, BOOL *stop);

@implementation UIWindow (VisibleViewController)

- (UIViewController *)visibleViewController
{
    UIViewController *rootViewController = self.rootViewController;
    
    if (rootViewController.splitViewController) {
        
        // If any of the split view controller's viewControllers are presnting work up their view hierarcy
        for (UIViewController *splitViewController in rootViewController.splitViewController.viewControllers) {
            
            if (splitViewController.presentedViewController) {
                return [self visibleViewControllerForViewController:splitViewController.presentedViewController];
            }
        }
        
        // Otherwise navigate through the last view controller on the splitViewController
        return [self visibleViewControllerForViewController:rootViewController.splitViewController.viewControllers.lastObject];
    }

    return [self visibleViewControllerForViewController:rootViewController];
}

- (UIViewController *)visibleViewControllerForViewController:(UIViewController *)viewController
{
    // Work up the view hierarchy if presented
    if (viewController.presentedViewController) {
        return [self visibleViewControllerForViewController:viewController.presentedViewController];
    }
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *navigationController = (UINavigationController *)viewController;
        UIViewController *lastViewController = navigationController.viewControllers.lastObject;
        
        return [self visibleViewControllerForViewController:lastViewController];
        
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tabBarController = (UITabBarController *)viewController;
        return [self visibleViewControllerForViewController:tabBarController.selectedViewController];
        
    } else if ([viewController isKindOfClass:[UIViewController class]]) {
        
        return viewController;
        
    }
    
    return viewController;
}

@end
