//
//  TSCToastNotificationController.h
//  Blood
//
//  Created by Simon Mitchell on 14/10/2014.
//  Copyright (c) 2014 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSCToastView.h"

@interface TSCToastNotificationController : NSObject

+ (TSCToastNotificationController *)sharedController;

/**
 @abstract Use this to
 */
- (void)displayToastNotificationView:(TSCToastView *)toastView;
- (void)displayToastNotificationWithTitle:(NSString *)title message:(NSString *)message;
- (void)displayToastNotificationWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)image;
- (void)displayToastNotificationWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)image action:(TSCToastViewActionHandler)action;

@end
