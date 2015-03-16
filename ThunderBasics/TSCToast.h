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

/**
 An instance of a toast operation to be presented to the user
 */
@interface TSCToast : NSOperation

/**
 The view that will be displayed when the toast operation is begun
 @discussion This must be an instance of `TSCToastView`
 */
@property (nonatomic, strong) TSCToastView *toastView;

/**
 The view that will present the toast
 */
@property (nonatomic, strong) UIView *presentingView;

/**
 Whether or not the operation is currently being executed
 */
@property (nonatomic, assign) BOOL isExecuting;

/**
 Whether or not the operation is finished
 */
@property (nonatomic, assign) BOOL isFinished;

/**
 Whether or not the operation is to be completed asynchronously
 @discussion This property will always be FALSE
 @return FALSE
 @warning Do not override this method
 */
@property (nonatomic, assign) BOOL isAsynchronous;

@end
