//
//  UITabBarController+TSCTabBarController.h
//  ThunderBasics
//
//  Created by Phillip Caudell on 27/05/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (TSCTabBarController)

- (id)initWithViewControllers:(NSArray *)viewControllers;
- (id)initWithViewControllers:(NSArray *)viewControllers nestInsideNavigationControllers:(BOOL)nest;

@end
