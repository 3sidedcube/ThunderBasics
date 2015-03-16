//
//  TSCToastViewController.m
//  ThunderBasics
//
//  Created by Simon Mitchell on 14/10/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import "TSCToastView.h"
#import "TSCToastViewController.h"

#define kToastEdgeInsets UIEdgeInsetsMake(12, 12, 12, 12)

@interface TSCToastView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIWindow *coverWindow;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravity;

@property (nonatomic, copy) TSCToastDisplayCompletion completion;

@end

@implementation TSCToastView

- (instancetype)init
{
    if (self = [super init]) {
        
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.messageLabel = [UILabel new];
        self.messageLabel.font = [UIFont systemFontOfSize:16];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.imageView = [UIImageView new];
        
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.messageLabel];
        
        if ([[TSCToastView appearance] visibleDuration] == 0) {
            self.visibleDuration = 2.0;
        }
    }
    return self;
}

+ (instancetype)toastNotificationWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)image
{
    TSCToastView *toastView = [TSCToastView new];
    toastView.titleLabel.text = title;
    toastView.messageLabel.text = message;
    toastView.imageView.image = image;
    
    toastView.titleLabel.text = title;
    toastView.messageLabel.text = message;
    
    return toastView;
}

+ (instancetype)toastNotificationWithTitle:(NSString *)title message:(NSString *)message
{
    return [TSCToastView toastNotificationWithTitle:title message:message image:nil];
}

- (UIStatusBarStyle)currentStatusBarStyle
{
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    UIViewController *rootViewController = window.rootViewController;
    UIStatusBarStyle statusBarStyle = window.rootViewController.preferredStatusBarStyle;
    
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *navController = (UINavigationController *)rootViewController;
        
        if ([navController.presentedViewController respondsToSelector:@selector(preferredStatusBarStyle)]) {
            statusBarStyle = navController.presentedViewController.preferredStatusBarStyle;
        }
    } else if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tabController = (UITabBarController *)rootViewController;
    
        if ([tabController.selectedViewController respondsToSelector:@selector(preferredStatusBarStyle)]) {
            statusBarStyle = tabController.selectedViewController.preferredStatusBarStyle;
        }
    }
    
    return statusBarStyle;
}

- (void)showWithCompletion:(TSCToastDisplayCompletion)completion
{
    self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44); // Add on 40 points so when it drops down you can't see the view behind it.
    
    [self layout];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, self.bounds.size.height)];
    
    self.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
    
    self.coverWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.coverWindow.windowLevel = UIWindowLevelStatusBar+1;
    
    TSCToastViewController *toastViewController = [TSCToastViewController new];
    toastViewController.statusBarStyle = [self currentStatusBarStyle];
    toastViewController.view.userInteractionEnabled = false; // This must be false, otherwise our tap gesture nevet makes it down to the added UIWindow
    
    self.coverWindow.rootViewController = toastViewController;
    self.coverWindow.hidden = false;
    self.coverWindow.backgroundColor = [UIColor clearColor];
    [self.coverWindow.rootViewController.view addSubview:containerView];
    [containerView addSubview:self];
    
    UITapGestureRecognizer *tapHandler = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.coverWindow addGestureRecognizer:tapHandler];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:containerView];
    
    CGVector gravityDirection = {0.0, 1.4};
    self.gravity = [[UIGravityBehavior alloc] initWithItems:@[self]];
    self.gravity.gravityDirection = gravityDirection;
    [self.animator addBehavior:self.gravity];
    
    UIDynamicItemBehavior *behaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
    behaviour.elasticity = 0.5;
    [self.animator addBehavior:behaviour];
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self]];
    [collision setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(-self.frame.size.height-10, -10, 1, -10)];
    [self.animator addBehavior:collision];
    
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:self.visibleDuration + 0.7];
    
    self.completion = completion;
    
//    [UIView animateWithDuration:self.animateInDuration delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{ // Let's do all the pretty animations
//        
//        self.transform = CGAffineTransformIdentity;
//        
//    } completion:^(BOOL finished) {
//        
//        if (finished) {
//            
//            [UIView animateWithDuration:self.animateOutDuration delay:self.visibleDuration usingSpringWithDamping:0.5 initialSpringVelocity:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                
//                self.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
//                self.alpha = 0.0;
//            } completion:^(BOOL finished) {
//                
//                self.coverWindow.hidden = true;
//                [self removeFromSuperview];
//                completion();
//            }];
//        }
//    }];
}

- (void)layout
{
    CGRect labelContainer = CGRectMake(kToastEdgeInsets.left, kToastEdgeInsets.top, self.frame.size.width - kToastEdgeInsets.left - kToastEdgeInsets.right, MAXFLOAT);
    
    if (self.imageView.image) { // If we have an image adjust how much room we have for the labels.
        
        self.imageView.frame = CGRectMake(kToastEdgeInsets.left, 0, 38, 38);
        labelContainer.origin.x += 12 + 38;
        labelContainer.size.width -= 12 + 38;
    }
    
    CGSize titleSize = [self.titleLabel sizeThatFits:labelContainer.size];
    self.titleLabel.frame = CGRectMake(labelContainer.origin.x, labelContainer.origin.y, titleSize.width, titleSize.height);
    
    CGSize messageSize = [self.messageLabel sizeThatFits:labelContainer.size];
    self.messageLabel.frame = CGRectMake(labelContainer.origin.x, labelContainer.origin.y + self.titleLabel.frame.size.height, messageSize.width, messageSize.height);
    
    self.frame = CGRectMake(0, -40, self.frame.size.width, MAX(self.messageLabel.frame.origin.y + self.messageLabel.frame.size.height + kToastEdgeInsets.bottom,44));
    self.imageView.center = CGPointMake(self.imageView.center.x, self.frame.size.height/2);
}

- (void)handleTap:(id)sender
{
    
    if (self.action) {
        self.action(self);
    }
}

- (void)setTextColour:(UIColor *)textColour
{
    _textColour = textColour;
    self.messageLabel.textColor = textColour;
    self.titleLabel.textColor = textColour;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
}

- (void)dismiss
{
    [self.animator removeBehavior:self.gravity];
    [self.animator removeAllBehaviors];
    
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self]];
    [gravityBehaviour setGravityDirection:CGVectorMake(0, -2.4)];
    [self.animator addBehavior:gravityBehaviour];
    
    [self performSelector:@selector(complete) withObject:nil afterDelay:0.7];
}

- (void)complete
{
    self.coverWindow.hidden = true;
    [self removeFromSuperview];
    self.completion();
}

@end
