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
    return [self visibleViewControllerForViewController:self.rootViewController];
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
