//
//  RCHiCloudController.h
//  ARC Hazards
//
//  Created by Matt Cheetham on 25/11/2014.
//  Copyright (c) 2014 3 SIDED CUBE Design Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TSCiCloudSyncHandler)();

/**
 The iCloud controller is responsible for synchronising data across the users iCloud account, between devices. It both repsonsible for updating values as well as listening out for changes to values on other devices and updating them in the app
 */
@interface TSCiCloudController : NSObject

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

@property (nonatomic, copy) NSString *appGroup;

@end
