//
//  MDCHUDActivityView.h
//  MDCHudActivityViewExample
//
//  Created by Matthew Cheetham on 26/04/2014.
//  Copyright (c) 2014 Matthew Cheetham. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Defines the style of `MDCHudActivityView`
 */
typedef NS_ENUM(NSInteger, MDCHUDActivityViewStyle) {
    /** Default style of HUD displays a light activity indicator in a dark translucent view with text beneath */
    MDCHUDActivityViewStyleDefault = 0,
    /** Displays the logo with text below it */
    MDCHUDActivityViewStyleLogo = 1,
    /** Displays a dark activity indicator and black text below it */
    MDCHUDActivityViewStyleMinimal = 2
};

/**
 A view which show an activity indicator and an (Optional) descriptive string below it in a HUD display
 */
@interface MDCHUDActivityView : UIView

/**
 *  Adds an animated HUD to the centre of the view to indicate loading
 *
 *  @param view The view that should present the loading HUD
 */
+ (void)startInView:(UIView *)view;

/**
 *  Adds an animated HUD to the centre of the view to indicate loading with a message displayed underneath the activity indicator
 *
 *  @param view The view that should present the loading HUD
 *  @param text The text to display beneath the indicator
 */
+ (void)startInView:(UIView *)view text:(NSString *)text;

/**
 *  Adds an animated HUD to the centre of the view to indicate loading with a message displayed underneath the activity indicator. Choose from a range of styles.
 *
 *  @param view  The view that should present the loading HUD
 *  @param text  The text to display beneath the indicator
 *  @param style The MDCHUDActivityViewStyle that should be used to layout the view
 */
+ (void)startInView:(UIView *)view text:(NSString *)text style:(MDCHUDActivityViewStyle)style;

/**
 *  Removes any loading HUD views from the specified view
 *
 *  @param view The view which already contains a loading HUD
 */
+ (void)finishInView:(UIView *)view;

/**
 *  Updates the text label beneath an already running loading indicator
 *
 *  @param view The view which already contains a loading HUD
 *  @param text The text to replace the existing text with in the view
 */
+ (void)updateActivityInView:(UIView *)view withText:(NSString *)text;

/**
 *  Removes text from the given activity view
 *
 *  @param view The view which already contains a loading HUD
 */
+ (void)removeTextOnActivityViewInView:(UIView *)view;

@end
