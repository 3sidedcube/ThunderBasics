//
//  TSCAlertView.h
//  ThunderBasics
//
//  Created by Phillip Caudell on 19/06/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TSCAlertAction;

/** The styles available for a TSCAlertViewController */
typedef NS_ENUM(NSInteger, TSCAlertViewControllerStyle) {
    /** Lays the TSCAlertViewController out in a UIActionSheet style */
    TSCAlertViewControllerStyleActionSheet = 0,
    /** Lays the TSCAlertViewController out in a UIAlertView style */
    TSCAlertViewControllerStyleAlert = 1
};

/**
 A block that allows customisation of a text field in the alert view
 */
typedef void (^TSCAlertTextFieldConfigurationHandler)(UITextField *textField);

/**
 `TSCAlertViewController` Is a wraparound for `UIAlertView` and `UIActionSheet` which allows behaviour identical to that of `UIAlertController` when building for iOS 7.
 */
@interface TSCAlertViewController : NSObject <UIAlertViewDelegate, UIActionSheetDelegate>

/**
 @abstract The title of the alert.
 @discussion The title string is displayed prominently in the alert or action sheet. You should use this string to get the user’s attention and communicate the reason for displaying the alert.
 */
@property (nonatomic, readonly) NSString *title;

/**
 @abstract Descriptive text that provides more details about the reason for the alert.
 @discussion The title string is displayed below the title string and is less prominent. Use this string to provide additional context about the reason for the alert or about the actions that the user might take.
 */
@property (nonatomic, readonly) NSString *message;

/**
 @abstract The style of the alert controller.
 @discussion The value of this property is set to the value you specified in the alertControllerWithTitle:message:preferredStyle: method. This value determines how the alert is displayed onscreen.
 */
@property (nonatomic, readonly) TSCAlertViewControllerStyle preferredStyle;

/**
 @abstract The actions that the user can take in response to the alert or action sheet
 @discussion The actions are in the order in which you added them to the alert controller. This order also corresponds to the order in which they are displayed in the alert or action sheet. The second action in the array is displayed below the first, the third is displayed below the second, and so on.
 */
@property (nonatomic, readonly) NSArray *actions;

/**
 @abstract This text fields on the alert.
 @discussion This is only set once the UIAlertView has been shown to the user.
 */
@property (nonatomic, readonly) NSArray *textFields;


/**
 @abstract Creates and returns a view controller for displaying an alert to the user.
 @param title The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
 @param message Descriptive text that provides additional details about the reason for the alert.
 @param preferredStyle The style to use when presenting the alert controller. Use this parameter to configure the alert controller as an action sheet or as a modal alert.
 */
+ (id)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(TSCAlertViewControllerStyle)preferredStyle;

/**
 @abstract Attaches an action object to the alert or action sheet.
 @param action The action object to display as part of the alert. Actions are displayed as buttons in the alert. The action object provides the button text and the action to be performed when that button is tapped.
 */
- (void)addAction:(TSCAlertAction *)action;

/**
 @abstract Attaches a text field to the alert.
 @param handler The handler for configuring the text field before it is inserted into the UIAlertView. Can be used for example to make it a secure text field.
 */
- (void)addTextFieldWithConfigurationHandler:(TSCAlertTextFieldConfigurationHandler)handler;

/**
 @abstract Displays an alert controller that originates from the specified view.
 @param view The view from which the alert controller originates.
 */
- (void)showInView:(UIView *)view;

@end
