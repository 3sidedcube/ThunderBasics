//
//  MDCHUDActivityView.m
//  MDCHudActivityViewExample
//
//  Created by Matthew Cheetham on 26/04/2014.
//  Copyright (c) 2014 Matthew Cheetham. All rights reserved.
//

#import "MDCHUDActivityView.h"
#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface MDCHUDActivityView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *logoView;

/**
 Defines the activity view's identifier, so it can be removed while leaving any others intact.
 */
@property (nonatomic, strong) NSString *identifier;

@end

@implementation MDCHUDActivityView

#pragma mark - Setup
- (instancetype)initWithStyle:(MDCHUDActivityViewStyle)style identifier:(NSString*)identifier
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 100, 100)]) {
        
        if (style != MDCHUDActivityViewStyleMinimal){
            
            UIView *background = [[UIView alloc] initWithFrame:self.bounds];
            background.backgroundColor = [UIColor blackColor];
            background.alpha = 0.7;
            background.layer.cornerRadius = 8;
            [self addSubview:background];
        }
        
        if (style != MDCHUDActivityViewStyleLogo) {
            
            self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [self addSubview:self.activityIndicatorView];
            [self.activityIndicatorView startAnimating];
        }
        
        self.identifier = identifier;
        
        self.textLabel = [UILabel new];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.adjustsFontSizeToFitWidth = false;
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.textLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.textLabel];
        
        if (style == MDCHUDActivityViewStyleLogo) {
            
            self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MDCLoadingLogo" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil]];
            [self addSubview:self.logoView];
        }
        
        if (style == MDCHUDActivityViewStyleMinimal) {
            self.activityIndicatorView.color = [UIColor blackColor];
            self.textLabel.textColor = [UIColor blackColor];
        }
    }
    
    return self;
}

#pragma mark - Adding

+ (void)startInView:(UIView *)view identifier:(NSString*)identifier
{
    [MDCHUDActivityView startInView:view text:nil identifier:identifier];
}

+ (void)startInView:(UIView *)view text:(NSString *)text identifier:(NSString*)identifier
{
    [MDCHUDActivityView startInView:view text:text style:MDCHUDActivityViewStyleDefault identifier:identifier];
}

+ (void)startInView:(UIView *)view text:(NSString *)text style:(MDCHUDActivityViewStyle)style identifier:(NSString*)identifier
{
    MDCHUDActivityView *activityView = [[MDCHUDActivityView alloc] initWithStyle:style identifier:identifier];
    activityView.textLabel.text = text;
    
    [activityView showInView:view];
    
    if(style == MDCHUDActivityViewStyleLogo) {
        [activityView performSelector:@selector(performWobblyLogoRotation) withObject:nil afterDelay:1];
    }
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    
    [self setFrame:CGRectMake(view.frame.size.width / 2 - 50, view.frame.size.height / 2 - 50, 100, 100)];
    
    // Pop
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(0.1, 0.1, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.9, 0.9, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
    
    NSArray *frameValues = @[[NSValue valueWithCATransform3D:scale1],
                             [NSValue valueWithCATransform3D:scale2],
                             [NSValue valueWithCATransform3D:scale3],
                             [NSValue valueWithCATransform3D:scale4]];
    [animation setValues:frameValues];
    
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 0.65;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self.layer addAnimation:animation forKey:@"popup"];
}

#pragma mark - Modifying existing

+ (MDCHUDActivityView *)activityInView:(UIView *)view withIdentifier:(NSString*)identifier
{
    for (MDCHUDActivityView *subview in view.subviews) {
        
        if ([subview isKindOfClass:[MDCHUDActivityView class]]) {
            
            MDCHUDActivityView *activityView = (MDCHUDActivityView *)subview;
            if ([activityView.identifier isEqualToString:identifier]) {
                return activityView;
            }
        }
    }
    
    return nil;
}

+ (void)updateActivityInView:(UIView *)view withIdentifier:(NSString*)identifier toText:(NSString *)text
{
    MDCHUDActivityView *activityView = [MDCHUDActivityView activityInView:view withIdentifier:identifier];
    
    if (!activityView.textLabel.text) {
        
        [UIView animateWithDuration:0.65 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            activityView.activityIndicatorView.frame = CGRectOffset(activityView.activityIndicatorView.frame, 0, -7);
            activityView.logoView.frame = CGRectOffset(activityView.logoView.frame, 0, -7);
            activityView.textLabel.text = text;
            
        } completion:nil];
    }
    
    if (activityView.textLabel.text && text) {
        activityView.textLabel.text = text;
    }
    
    if (!text && activityView.textLabel.text) {
        
        [UIView animateWithDuration:0.65 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            activityView.activityIndicatorView.frame = CGRectOffset(activityView.activityIndicatorView.frame, 0, 7);
            activityView.logoView.frame = CGRectOffset(activityView.logoView.frame, 0, 7);
            activityView.textLabel.text = text;
            
        } completion:nil];
    }
}

+ (void)removeTextOnActivityViewInView:(UIView *)view withIdentifier:(NSString*)identifier
{
    [MDCHUDActivityView updateActivityInView:view withIdentifier:identifier toText:nil];
}

#pragma mark - Removing

+ (void)finishInView:(UIView *)view withIdentifier:(NSString*)identifier
{
    MDCHUDActivityView *activityView = [MDCHUDActivityView activityInView:view withIdentifier:identifier];
    
    [activityView finish];
}

- (void)finish
{
    [UIView animateWithDuration:0.35 animations:^{
        
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.activityIndicatorView.frame = CGRectMake(self.frame.size.width / 2 - 15, self.frame.size.height / 2 - 15, 30, 30);
    self.logoView.frame = CGRectMake(self.frame.size.width / 2 - 20, self.frame.size.height / 2 - 20, 40, 40);
    
    if (self.textLabel.text) {
        self.activityIndicatorView.frame = CGRectOffset(self.activityIndicatorView.frame, 0, -7);
        self.logoView.frame = CGRectOffset(self.logoView.frame, 0, -7);
    }
    
    CGSize textLabelSize = [self.textLabel sizeThatFits:CGSizeMake(self.frame.size.width-10, self.frame.size.height)];
    self.textLabel.frame = CGRectMake(5, self.frame.size.height - textLabelSize.height - 4, self.frame.size.width - 10, textLabelSize.height);
}

#pragma mark - Animating

- (void)performWobblyLogoRotation
{
    // Pop
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D transform1 = CATransform3DMakeRotation(DegreesToRadians(0), 0, 0, 1);
    CATransform3D transform2 = CATransform3DMakeRotation(DegreesToRadians(135), 0, 0, 1);
    CATransform3D transform3 = CATransform3DMakeRotation(DegreesToRadians(115), 0, 0, 1);
    CATransform3D transform4 = CATransform3DMakeRotation(DegreesToRadians(120), 0, 0, 1);
    
    NSArray *frameValues = @[[NSValue valueWithCATransform3D:transform1],
                             [NSValue valueWithCATransform3D:transform2],
                             [NSValue valueWithCATransform3D:transform3],
                             [NSValue valueWithCATransform3D:transform4]];
    [animation setValues:frameValues];
    
    animation.duration = 1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self.logoView.layer addAnimation:animation forKey:@"popup"];
    
    [self performSelector:@selector(performWobblyLogoRotation) withObject:nil afterDelay:1.0];
}

@end