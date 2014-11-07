//
//  UITabBarController+TSCTabBarController.m
//  ThunderBasics
//
//  Created by Phillip Caudell on 27/05/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import "UITabBarController+TSCTabBarController.h"

@implementation UITabBarController (TSCTabBarController)

- (id)initWithViewControllers:(NSArray *)viewControllers
{
    return [self initWithViewControllers:viewControllers nestInsideNavigationControllers:NO];
}

- (id)initWithViewControllers:(NSArray *)viewControllers nestInsideNavigationControllers:(BOOL)nest
{
    if (self = [super init]) {
        
        if (nest) {
            
            NSMutableArray *navigationControllers = [NSMutableArray array];
            
            for (UIViewController *viewController in viewControllers) {
                
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                [navigationControllers addObject:navigationController];
            }
            
            self.viewControllers = navigationControllers;
            
        } else {
            self.viewControllers = viewControllers;
        }
    }
    
    return self;
}

@end
