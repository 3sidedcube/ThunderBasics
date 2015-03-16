//
//  TSCAppInfoController.m
//  ThunderStorm
//
//  Created by Phillip Caudell on 19/12/2013.
//  Copyright (c) 2013 3 SIDED CUBE. All rights reserved.
//

#import "TSCAppInfoController.h"

@implementation TSCAppInfoController

static TSCAppInfoController *sharedController = nil;

+ (TSCAppInfoController *)sharedController
{
    @synchronized(self) {
        if (sharedController == nil) {
            sharedController = [[self alloc] init];
        }
    }
    
    return sharedController;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        self.infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
    }
    return self;
}

- (NSString *)bundleDisplayName
{
    return self.infoDictionary[@"CFBundleDisplayName"];
}

- (NSString *)bundleVersion
{
    return self.infoDictionary[@"CFBundleVersion"];
}

- (NSString *)bundleIdentifier
{
    return self.infoDictionary[@"CFBundleIdentifier"];
}

@end
