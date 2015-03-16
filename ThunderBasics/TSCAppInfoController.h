//
//  TSCAppInfoController.h
//  ThunderStorm
//
//  Created by Phillip Caudell on 19/12/2013.
//  Copyright (c) 2013 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `TSCAppInfoController` allows easy access to app information pulled from the info.plist file.
 */
@interface TSCAppInfoController : NSObject

/**
 Returns a shared instance of `TSCAppInfoController`
 */
+ (TSCAppInfoController *)sharedController;

/**
 @abstract The info dictionary of the main bundle.
 */
@property (nonatomic, strong) NSDictionary *infoDictionary;

/**
 @abstract The display name of the main bundle.
 */
@property (nonatomic, copy) NSString *bundleDisplayName;

/**
 @abstract The version number of the main bundle.
 */
@property (nonatomic, copy) NSString *bundleVersion;

/**
 @abstract The bundle identifier of the main bundle.
 */
@property (nonatomic, copy) NSString *bundleIdentifier;

@end
