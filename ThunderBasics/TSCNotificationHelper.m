//
//  TSCNotificationHelper.m
//  ThunderBasics
//
//  Created by Matt Cheetham on 05/11/2014.
//  Copyright (c) 2014 threesidedcube. All rights reserved.
//

@import UIKit;
#import "TSCNotificationHelper.h"

@implementation TSCNotificationHelper

+ (void)setupNotifications
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [TSCNotificationHelper setupNotificationsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
}

+ (void)setupNotificationsForTypes:(UIUserNotificationType)types categories:(NSSet *)categories
{
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}

+ (void)registerForRemoteNotifications
{
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

@end
