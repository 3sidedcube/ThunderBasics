//
//  TSCToast.m
//  Blood
//
//  Created by Simon Mitchell on 14/10/2014.
//  Copyright (c) 2014 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

#import "TSCToast.h"
#import "TSCToastView.h"


@implementation TSCToast

- (void)main
{
    if ([NSThread currentThread] != [NSThread mainThread]) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self.toastView showWithCompletion:^{
                self.isFinished = true;
            }];
        });
        
        sleep(self.toastView.visibleDuration + 2.2);
        self.isFinished = true;
    } else {
        
        [self.toastView showWithCompletion:^{
            
            self.isFinished = true;
        }];
    }
}

- (BOOL)isAsynchronous
{
    return false;
}

@end
