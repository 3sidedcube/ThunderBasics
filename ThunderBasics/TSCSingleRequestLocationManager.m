//
//  PCWebServiceLocationManager.m
//  Glenigan
//
//  Created by Phillip Caudell on 23/08/2012.
//  Copyright (c) 2012 madebyphill.co.uk. All rights reserved.
//

#import "TSCSingleRequestLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@import os.log;

#define kPCWebServiceLocationManagerDebug NO
#define kPCWebServiceLocationManagerMaxWaitTime 14.0
#define kPCWebServiceLocationManagerMinWaitTime 2.0

static os_log_t ui_log;

@interface TSCSingleRequestLocationManager() <CLLocationManagerDelegate>
{
    BOOL _maxWaitTimeReached;
    BOOL _minWaitTimeReached;
    BOOL _locationSettledUpon;
    NSTimer *_maxWaitTimeTimer;
    NSTimer *_minWaitTimeTimer;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, copy) void (^PCSingleRequestLocationCompletion)(CLLocation *location, NSError *error);

@end;

@implementation TSCSingleRequestLocationManager

// Set up the logging component before it's used.
+ (void)initialize {
    ui_log = os_log_create("com.threesidedcube.ThunderCloud", "TSCSingleRequestLocationManager");
}

static TSCSingleRequestLocationManager *sharedLocationManager = nil;

- (void)dealloc
{
    self.locationManager.delegate = nil;
    self.locationManager = nil;
}

+ (TSCSingleRequestLocationManager *)sharedLocationManager
{
    @synchronized(self) {
        if (sharedLocationManager == nil) {
            sharedLocationManager = [self new];
        }
    }
    
    return sharedLocationManager;
}

- (void)requestCurrentLocationWithCompletion:(TSCSingleRequestLocationCompletion)completion
{
    [self requestCurrentLocationWithAuthorizationType:TSCAuthorizationTypeWhenInUse completion:completion];
}

- (void)requestCurrentLocationWithAuthorizationType:(TSCAuthorizationType)authorization completion:(TSCSingleRequestLocationCompletion)completion
{
    if (!self.locationManager) {
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    }
    
    self.locationManager.delegate = self;
    
    //Copy completion block for firing later
    self.PCSingleRequestLocationCompletion = completion;
	
	// If we've already asked for location permissions and user has denied then immediately return an error
	if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
		
		NSError *error = [NSError errorWithDomain:@"org.threesidedcube.requestmanager" code:1001 userInfo:@{NSLocalizedDescriptionKey: @"_LOCATIONREQUEST_ALERT_LOCATIONDISABLED_MESSAGE"}];
		self.PCSingleRequestLocationCompletion(nil, error);
		[self cleanUp];
		
		// Start location manager
	} else if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        if(authorization == TSCAuthorizationTypeAlways) {
            
            [self.locationManager requestAlwaysAuthorization];
        } else if(authorization == TSCAuthorizationTypeWhenInUse) {
            
            [self.locationManager requestWhenInUseAuthorization];
        }
    } else {
        
        //Are we running iOS 9? let's use the built in method and forget about all of this junk handling.
        if ([self.locationManager respondsToSelector:@selector(requestLocation)]) {
            
            [self.locationManager requestLocation];
            return;
        }
        
        [self.locationManager startUpdatingLocation];
        // Start timers - If user hasn't enabled permissions yet we need to wait until they have allowed/disallowed location updates before starting these timers.
        _maxWaitTimeTimer = [NSTimer scheduledTimerWithTimeInterval:kPCWebServiceLocationManagerMaxWaitTime target:self selector:@selector(maxWaitTimeReached) userInfo:nil repeats:NO];
        _minWaitTimeTimer = [NSTimer scheduledTimerWithTimeInterval:kPCWebServiceLocationManagerMinWaitTime target:self selector:@selector(minWaitTimeReached) userInfo:nil repeats:NO];
    }
}

#pragma mark CLLocationManager delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        if (self.PCSingleRequestLocationCompletion) { // Only start up if a user has actually requested location by now
            
            if ([self.locationManager respondsToSelector:@selector(requestLocation)]) {
                
                [self.locationManager requestLocation];
                return;
            }
            
            [self.locationManager startUpdatingLocation];
            // Start timers
            _maxWaitTimeTimer = [NSTimer scheduledTimerWithTimeInterval:kPCWebServiceLocationManagerMaxWaitTime target:self selector:@selector(maxWaitTimeReached) userInfo:nil repeats:NO];
            _minWaitTimeTimer = [NSTimer scheduledTimerWithTimeInterval:kPCWebServiceLocationManagerMinWaitTime target:self selector:@selector(minWaitTimeReached) userInfo:nil repeats:NO];
        }
    }
    
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        
        NSError *error = [NSError errorWithDomain:@"org.threesidedcube.requestmanager" code:1001 userInfo:@{NSLocalizedDescriptionKey: @"_LOCATIONREQUEST_ALERT_LOCATIONDISABLED_MESSAGE"}];
        self.PCSingleRequestLocationCompletion(nil, error);
        [self cleanUp];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    if (locations.count > 0) {
        
        if ([self.locationManager respondsToSelector:@selector(requestLocation)]) {
            
            if (self.PCSingleRequestLocationCompletion) {
                self.PCSingleRequestLocationCompletion(locations.firstObject, nil);
            }
            [self cleanUp];
            return;
            
        }
        
        CLLocation *newLocation = locations[0];
        
        // Debug the reported location
        if (kPCWebServiceLocationManagerDebug) {
            os_log_debug(ui_log, "PCWebServiceLocationManager: New location: %@", newLocation);
            
            os_log_debug(ui_log, "PCWebServiceLocationManager: Horizontal accuracy: %f", newLocation.horizontalAccuracy);
            
            os_log_debug(ui_log, "PCWebServiceLocationManager: Vertical accuracy: %f", newLocation.verticalAccuracy);
        }
        
        // If accuracy greater than 100 meters, it's too inaccurate
        if(newLocation.horizontalAccuracy > 100 && newLocation.verticalAccuracy > 100){
            if (kPCWebServiceLocationManagerDebug) {
                os_log_debug(ui_log, "PCWebServiceLocationManager: Accuracy poor, aborting...");
            }
            return;
        }
        
        // If location is older than 10 seconds, it's probably an old location getting re-reported
        NSInteger locationTimeIntervalSinceNow = fabs([newLocation.timestamp timeIntervalSinceNow]);
        if (locationTimeIntervalSinceNow > 10) {
            if (kPCWebServiceLocationManagerDebug) {
                os_log_debug(ui_log, "PCWebServiceLocationManager: Location old, aborting...");
            }
            return;
        }
        
        // If we haven't exceeded our min wait time, it's probably still too inaccurate
        if (!_minWaitTimeReached) {
            if (kPCWebServiceLocationManagerDebug) {
                os_log_debug(ui_log, "PCWebServiceLocationManager: Min wait time not yet reached, aborting...");
            }
            return;
        }
        
        [self settleUponCurrentLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (kPCWebServiceLocationManagerDebug) {
        os_log_debug(ui_log, "PCWebServiceLocationManager: Did fail with error: %@", error);
    }
    
    if (error.code != kCLErrorDenied){
        self.PCSingleRequestLocationCompletion(nil, error);
    }
    
    [self cleanUp];
}

#pragma mark Private helper methods

- (void)maxWaitTimeReached
{
    _maxWaitTimeReached = YES;
    _maxWaitTimeTimer = nil;
    [self settleUponCurrentLocation];
}

- (void)minWaitTimeReached
{
    _minWaitTimeReached = YES;
    _minWaitTimeTimer = nil;
}

/**
 Once all location crtiera has been met
 */
- (void)settleUponCurrentLocation
{
    // If we've already settled upon a location, don't fire again
    if (_locationSettledUpon) {
        return;
    }
    
    if (kPCWebServiceLocationManagerDebug) {
        os_log_debug(ui_log, "PCWebServiceLocationManager: Settling on location: %@", self.locationManager.location);
    }
    
    // Location settled upon!
    _locationSettledUpon = YES;
    
    if (self.PCSingleRequestLocationCompletion) {
        self.PCSingleRequestLocationCompletion(self.locationManager.location, nil);
    }
    
    [self cleanUp];
    
}

- (void)cleanUp
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        if (self.keepRunning) {
            [self.locationManager stopUpdatingLocation];
        }
        
        self.locationManager.delegate = nil;
        [_maxWaitTimeTimer invalidate];
        _maxWaitTimeTimer = nil;
        [_minWaitTimeTimer invalidate];
        _minWaitTimeTimer = nil;
        _maxWaitTimeReached = NO;
        _minWaitTimeReached = NO;
        _locationSettledUpon = NO;
        self.PCSingleRequestLocationCompletion = nil;
    }];
    
}

@end
