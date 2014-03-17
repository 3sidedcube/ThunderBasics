//
//  TSCAppInfoController.h
//  ThunderStorm
//
//  Created by Phillip Caudell on 19/12/2013.
//  Copyright (c) 2013 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSCAppInfoController : NSObject

+ (TSCAppInfoController *)sharedController;

@property (nonatomic, strong) NSDictionary *infoDictionary;
@property (nonatomic, strong) NSString *bundleDisplayName;
@property (nonatomic, strong) NSString *bundleVersion;
@property (nonatomic, strong) NSString *bundleIdentifier;

@end
