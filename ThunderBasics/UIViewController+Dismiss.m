//
//  UIViewController+Dismiss.m
//  ThunderBasics
//
//  Created by Simon Mitchell on 15/10/2015.
//  Copyright © 2015 threesidedcube. All rights reserved.
//

#import "UIViewController+Dismiss.h"

@implementation UIViewController (Dismiss)

- (void)dismissAnimated
{
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
