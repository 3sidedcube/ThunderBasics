//
//  TSCDismissSegue.m
//  ThunderBasics
//
//  Created by Sam Houghton on 10/11/2015.
//  Copyright © 2015 threesidedcube. All rights reserved.
//

#import "TSCDismissSegue.h"

@implementation TSCDismissSegue

- (void)perform
{
    UIViewController *sourceViewController = self.sourceViewController;
    [sourceViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
