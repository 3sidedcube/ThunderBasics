//
//  PCWebServiceLocationManager.h
//  Glenigan
//
//  Created by Phillip Caudell on 23/08/2012.
//  Copyright (c) 2012 madebyphill.co.uk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;


typedef NS_ENUM(NSInteger, TSCAuthorizationType) {
    TSCAuthorizationTypeWhenInUse = 1,
    TSCAuthorizationTypeAlways = 2
};

@interface TSCSingleRequestLocationManager : NSObject


typedef void (^TSCSingleRequestLocationCompletion)(CLLocation *location, NSError *error);

/**
 Returns the shared instance of the single request location manager
 @discussion This solves the problem of having to retain a strong reference to an instance of PCSingleRequestLocationManager
 */
+ (TSCSingleRequestLocationManager *)sharedLocationManager;

/**
 Requests a users current location and fires a completion block once it has established that an accurate location has been found, or that an error has occured
 @param authorization The TSCAuthorizationType for the request. Defines whether the app can use location services in the background or not
 @param completion The TSCSingleRequestLocationCompletion block to be fired when the manager has found or failed to find the current location
 **/
- (void)requestCurrentLocationWithAuthorizationType:(TSCAuthorizationType)authorization completion:(TSCSingleRequestLocationCompletion)completion;

/**
 Requests a users current location and fires a completion block once it has established that an accurate location has been found, or that an error has occured
 @param completion The TSCSingleRequestLocationCompletion block to be fired when the manager has found or failed to find the current location
 **/
- (void)requestCurrentLocationWithCompletion:(TSCSingleRequestLocationCompletion)completion;

@end
