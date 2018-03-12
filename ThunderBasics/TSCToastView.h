//
//  TSCToastViewController.h
//  ThunderBasics
//
//  Created by Simon Mitchell on 14/10/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSCToastView;

/**
 A block that will be called when a toast view is tapped
 */
typedef void (^TSCToastViewActionHandler)(TSCToastView * _Nonnull toastView);

/**
 The block that will be called when a toast has been displayed
 */
typedef void (^TSCToastDisplayCompletion)(void);

/**
 A visual representation of a `TSCToast` that will be displayed to the user at the top of their screen
 */
@interface TSCToastView : UIView

/**
 Creates a toast notification view with a title, message and image
 @param title The title text to display on the toast
 @param message The message text to display on the toast
 @param image The image to display on the left hand side of the toast
 @return An instance of `TSCToastView` populated with data
 */
+ (instancetype _Nonnull)toastNotificationWithTitle:(NSString * _Nullable)title message:(NSString * _Nullable)message image:(UIImage * _Nullable)image;

/**
 Shows the Toast notification on the screen
 @param completion A completion block to be called when the toast notification has displayed and dismissed successfully
 */
- (void)showWithCompletion:(TSCToastDisplayCompletion _Nonnull)completion;

/**
 The action to be called if the user taps the toast
 */
@property (nonatomic, strong, nullable) TSCToastViewActionHandler action;

/**
 The colour of the text in the notification view
 @discussion Conforms to appearance selectors
 */
@property (nonatomic, strong, nullable) UIColor *textColour UI_APPEARANCE_SELECTOR;

/**
 The duration in seconds that the toast will be visible for
 @discussion Conforms to appearance selectors
 */
@property (nonatomic, assign) CGFloat visibleDuration UI_APPEARANCE_SELECTOR;

@end
