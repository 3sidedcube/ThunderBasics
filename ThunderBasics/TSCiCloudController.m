//
//  RCHiCloudController.m
//  ARC Hazards
//
//  Created by Matt Cheetham on 25/11/2014.
//  Copyright (c) 2014 3 SIDED CUBE Design Ltd. All rights reserved.
//

#import "TSCiCloudController.h"

@interface TSCiCloudController ()

@property (nonatomic, strong) TSCiCloudSyncHandler syncHandler;

@end

@implementation TSCiCloudController

static TSCiCloudController *sharedController = nil;

+ (BOOL)iCloudEnabled
{
    NSLog(@"ICLOUD TOKEN : %@",[[NSFileManager defaultManager] ubiquityIdentityToken]);
    return [[NSFileManager defaultManager] ubiquityIdentityToken] != nil;
}

+ (TSCiCloudController *)sharedController
{
    @synchronized(self) {
        
        if (sharedController == nil) {
            sharedController = [self new];
        }
    }
    
    return sharedController;
}

- (void)initialSyncWithCompletionHandler:(TSCiCloudSyncHandler)handler
{
    self.syncHandler = handler;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeDidChange:) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:[NSUbiquitousKeyValueStore defaultStore]];
    [[NSUbiquitousKeyValueStore defaultStore] setString:@"Test" forKey:@"Test"]; // This is necessary as it pulls out any entitlement errors from the call to synchronize
    
    if (![[NSUbiquitousKeyValueStore defaultStore] synchronize]) {

        if (self.syncHandler) {
            self.syncHandler();
        }
        self.syncHandler = nil;
    }
}

- (void)storeDidChange:(NSNotification *)notification
{
    NSLog(@"Detected change in iCloud");
    
    // Get the list of keys that changed.
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *reasonForChange = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
    NSInteger reason = -1;
    
    // If a reason could not be determined, do not update anything.
    if (!reasonForChange)
        return;
    
    // Update only for changes from the server.
    reason = [reasonForChange integerValue];
    
    if ((reason == NSUbiquitousKeyValueStoreServerChange) || (reason == NSUbiquitousKeyValueStoreInitialSyncChange)) {
        
        // If something is changing externally, get the changes and update the corresponding keys locally.
        NSArray *changedKeys = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
        NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if (self.appGroup) {
            userDefaults = [[NSUserDefaults alloc] initWithSuiteName:self.appGroup];
        }
        
        //Save your iCloud keys into defaults
        for (NSString *key in changedKeys) {
            id value = [store objectForKey:key];
            [userDefaults setObject:value forKey:key];
        }
    }
    
    if (reason == NSUbiquitousKeyValueStoreInitialSyncChange) {
        
        if (self.syncHandler) {
            
            self.syncHandler();
            self.syncHandler = nil;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TSCiCloudControllerDidInitialSync" object:nil];
    } else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TSCiCloudControllerDidDetectChange" object:nil];
    }
}

- (void)updateValue:(id)value forKey:(NSString *)key
{
    [[NSUbiquitousKeyValueStore defaultStore] setObject:value forKey:key];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

- (void)purge
{
    for (NSString *key in [NSUbiquitousKeyValueStore defaultStore].dictionaryRepresentation.allKeys) {
        
        [[NSUbiquitousKeyValueStore defaultStore] setObject:nil forKey:key];
        [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    }
}

@end
