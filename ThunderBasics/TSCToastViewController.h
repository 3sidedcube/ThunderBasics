//
//  TSCToastViewController.h
//  Blood
//
//  Created by Simon Mitchell on 14/10/2014.
//  Copyright (c) 2014 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This class is created and used automatically by a `TSCToastView` when it is presented.
 
 Toasts are displayed inside this view.
 
 This view is needed because in order to present a toast above everything else a new UIWindow is created and displayed, and a window must have root view controller.
 
 This root view controller allows us to access and use the statusBarStyle
 */
@interface TSCToastViewController : UIViewController

/**
 The current status bar style of the view
 */
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

@end
