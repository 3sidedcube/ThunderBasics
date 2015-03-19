//
//  TSCToastNotificationController.h
//  Blood
//
//  Created by Simon Mitchell on 14/10/2014.
//  Copyright (c) 2014 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSCToastView.h"

/**
 The controller responsible for displaying toast notifications at the top of the screen.
 
 This class has a shared instance that can be used to queue and display as many notification toasts as required.
 
 The class is particularly useful for showing remote or local alerts passed to the app whilst the app is open.
 */
@interface TSCToastNotificationController : NSObject

/**
 A shared instance of `TSCToastNotificationController` responsible for displaying toasts
 */
+ (TSCToastNotificationController *)sharedController;

/**
 Displays the given toast view immediately
 @param toastView An instance of `TSCToastView` to display
 */
- (void)displayToastNotificationView:(TSCToastView *)toastView;

/**
 Creates and displays a toast view with a given title and message
 @param title The title text to display on the toast
 @param message The message text to display on the toast
 */
- (void)displayToastNotificationWithTitle:(NSString *)title message:(NSString *)message;

/**
 Creates and displays a toast view with a given title, message and image
 @param title The title text to display on the toast
 @param message The message text to display on the toast
 @param image The image to display on the left hand side of the toast
 */
- (void)displayToastNotificationWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)image;

/**
 Creates and displays a toast view with a given title, message and image.
 @param title The title text to display on the toast
 @param message The message text to display on the toast
 @param image The image to display on the left hand side of the toast
 @param action A `TSCToastViewActionHandler` to call when the user taps the toast notification
 */
- (void)displayToastNotificationWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)image action:(TSCToastViewActionHandler)action;

@end
