//
//  TSCNotificationHelper.h
//  ThunderBasics
//
//  Created by Matt Cheetham on 05/11/2014.
//  Copyright (c) 2014 threesidedcube. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `TSCNotificationHelper` is a class designed to simplify the process of registering for push notifications. It provides convenience methods for registering for generic push notification types as well as the flexibility to register for custom actions in iOS 8
 */
@interface TSCNotificationHelper : NSObject

/**
 @abstract Registers for notification types of Alert, Sound and Badge.
 @discussion Call this method in your app delegate to register for notifications
 */
+ (void)setupNotifications;

/**
 @abstract Registers for notification types with the given types and categories
 @discussion Call this method in your app delegate to register for notifications. For convenience `setupNotifications` is available to register for generic push notification types
 @param types The `UIUserNotificationType`s to register for that your app supports
 @param categories A set of `UIUserNotificationCategory` objects that define the groups of actions a notification may include.
 */
+ (void)setupNotificationsForTypes:(UIUserNotificationType)types categories:(NSSet *)categories;

/**
 @abstract Call this method in the `application:didRegisterUserNotificationSettings:` delegate method if your app successfully registers for notification types after calling `setupNotifications` or `setupNotificationsForTypes:categories:` to register for notifications with APNS.
 */
+ (void)registerForRemoteNotifications;

@end
