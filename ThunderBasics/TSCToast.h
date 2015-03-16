//
//  TSCToast.h
//  Blood
//
//  Created by Simon Mitchell on 14/10/2014.
//  Copyright (c) 2014 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;
@class TSCToastView;

@interface TSCToast : NSOperation

@property (nonatomic, strong) TSCToastView *toastView;
@property (nonatomic, strong) UIView *presentingView;

@property (nonatomic, assign) BOOL isExecuting;
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, assign) BOOL isAsynchronous;

@end
