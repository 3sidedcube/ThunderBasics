//
//  NSApplication+NetworkActivityIndicator.m
//  ThunderBasics
//
//  Created by Simon Mitchell on 12/04/2016.
//  Copyright © 2016 threesidedcube. All rights reserved.
//

#import "UIApplication+NetworkActivityIndicator.h"
#import <objc/runtime.h>

static NSInteger activityCount = 0;

@implementation UIApplication (NetworkActivityIndicator)

+ (void)load {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(setNetworkActivityIndicatorVisible:);
        SEL swizzledSelector = @selector(tsc_setNetworkActivityIndicatorVisible:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (void)tsc_setNetworkActivityIndicatorVisible:(BOOL)visible {
	
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		
		if ([self isStatusBarHidden]) return;
		
		// Synchronise self to avoid threading issues
		@synchronized (self) {
			
			// If trying to make visible
			if (visible) {
				
				if (activityCount == 0) {
					[self tsc_setNetworkActivityIndicatorVisible:YES];
				}
				activityCount++;
				
			} else { // Otherwise trying to hide it
				
				activityCount--;
				if (activityCount <= 0) {
					[self tsc_setNetworkActivityIndicatorVisible:NO];
					activityCount=0;
				}
			}
		}
	}];
}

@end
