//
//  RCHiCloudController.h
//  ARC Hazards
//
//  Created by Matt Cheetham on 25/11/2014.
//  Copyright (c) 2014 3 SIDED CUBE Design Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The block called when iCloud performs it's initial sync
 */
typedef void (^TSCiCloudSyncHandler)(void);

/**
 The iCloud controller is responsible for synchronising data across the users iCloud account, between devices. It both repsonsible for updating values as well as listening out for changes to values on other devices and updating them in the app
 */
@interface TSCiCloudController : NSObject

/**
 Checks if iCloud is enabled on the current device
 @return YES if iCloud is enabled
 */
+ (BOOL)iCloudEnabled;

/**
 A shared instance of the iCloud controller
 */
+ (TSCiCloudController *)sharedController;

/**
 Sets a new value for key and syncronises it with iCloud
 @param value The NSObject to add to the store
 @param key The key to assign the value to in the store
 **/
- (void)updateValue:(id)value forKey:(NSString *)key;

/**
 Completely clears anything stored in the iCloud UIUbiquitousKeyStore
 */
- (void)purge;

/**
 Requests the initial sync for iCloud upon device install
 @param handler The block of code to be run once the initial sync has been performed
 */
- (void)initialSyncWithCompletionHandler:(TSCiCloudSyncHandler)handler;

/**
 The identifier of the app group that should be used to save and read user defaults
 @discussion If this property is nil, standard user defaults will be used
 */
@property (nonatomic, copy) NSString *appGroup;

@end
