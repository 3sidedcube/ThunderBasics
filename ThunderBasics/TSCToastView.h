//
//  TSCToastViewController.h
//  ThunderBasics
//
//  Created by Simon Mitchell on 14/10/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSCToastView;

typedef void (^TSCToastViewActionHandler)(TSCToastView *toastView);
typedef void (^TSCToastDisplayCompletion)(void);

@interface TSCToastView : UIView

+ (instancetype)toastNotificationWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)image;

- (void)showWithCompletion:(TSCToastDisplayCompletion)completion;

@property (nonatomic, assign) TSCToastViewActionHandler action;
@property (nonatomic, strong) UIColor *textColour UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat visibleDuration UI_APPEARANCE_SELECTOR;

@end
