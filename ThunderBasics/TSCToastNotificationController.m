//
//  TSCToastNotificationController.m
//  Blood
//
//  Created by Simon Mitchell on 14/10/2014.
//  Copyright (c) 2014 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

#import "TSCToastNotificationController.h"
#import "TSCToast.h"

@interface TSCToastNotificationController ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation TSCToastNotificationController

static TSCToastNotificationController *sharedController = nil;

- (instancetype)init
{
    if (self = [super init]) {
        
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

+ (TSCToastNotificationController *)sharedController
{
    @synchronized(self) {
        if (sharedController == nil) {
            sharedController = [[self alloc] init];
        }
    }
    
    return sharedController;
}

- (void)displayToastNotificationWithTitle:(NSString *)title message:(NSString *)message
{
    [self displayToastNotificationWithTitle:title message:message image:nil action:nil];
}

- (void)displayToastNotificationWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)image
{
    [self displayToastNotificationWithTitle:title message:message image:image action:nil];
}

- (void)displayToastNotificationWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)image action:(TSCToastViewActionHandler)action
{
    TSCToastView *toastView = [TSCToastView toastNotificationWithTitle:title message:message image:image];
    toastView.action = action;
    [self displayToastNotificationView:toastView];
}

- (void)displayToastNotificationView:(TSCToastView *)toastView
{
    TSCToast *toast = [TSCToast new];
    toast.toastView = toastView;
    
    [self.operationQueue addOperation:toast];
}

@end
