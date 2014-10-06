//
//  TSCAlertAction.h
//  ThunderBasics
//
//  Created by Phillip Caudell on 19/06/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TSCAlertActionStyle) {
    TSCAlertActionStyleDefault = 0,
    TSCAlertActionStyleCancel = 1,
    TSCAlertActionStyleDestructive = 2
};

/**
 @class TSCAlertAction
 @discussion A TSCAlertAction object represents an action that can be taken when tapping a button in an alert. You use this class to configure information about a single action, including the title to display in the button, any styling information, and a handler to execute when the user taps the button. After creating an alert action object, add it to a UIAlertController object before displaying the corresponding alert to the user.
 */
@interface TSCAlertAction : NSObject

typedef void (^TSCAlertActionHandler)(TSCAlertAction *action);

/**
 @abstract The title of the action’s button.
 */
@property (nonatomic, readonly) NSString *title;

/**
 @abstract The style that is applied to the action’s button
 */
@property (nonatomic, readonly) TSCAlertActionStyle style;

/**
 @abstract A block to execute when the user selects the action. This block has no return value and takes the selected action object as its only parameter.
 */
@property (nonatomic, readonly) TSCAlertActionHandler handler;

/**
 @abstract Create and return an action with the specified title and behavior.
 @param title The text to use for the button title. The value you specify should be localized for the user’s current language. This parameter must not be nil.
 @param style Additional styling information to apply to the button. Use the style information to convey the type of action that is performed by the button.
 @param handler A block to execute when the user selects the action. This block has no return value and takes the selected action object as its only parameter.
 */
+ (instancetype)actionWithTitle:(NSString *)title style:(TSCAlertActionStyle)style handler:(TSCAlertActionHandler)handler;

@end
