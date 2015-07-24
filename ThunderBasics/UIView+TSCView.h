//
//  UIView+TSCResize.h
//  ThunderBasics
//
//  Created by Sam Houghton on 08/01/2015.
//  Copyright (c) 2015 3 SIDED CUBE. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 A block called for each view when enumerating over subviews using `enumerateSubviewsUsingHandler:`
 */
typedef void (^TSCViewEnumerationHandler)(UIView *view, BOOL *stop);

/**
 This category adds useful methods for resizing and repositioning UIView's without having to worry about duplicating frame references
 */
@interface UIView (TSCView)

/**
 Adjusts the height of the current view's frame to the given value
 @param height The height to adjust the view to
 */
- (void)setHeight:(float)height;

/**
 Adjusts the width of the current view's frame to the given value
 @param width The width to adjust the view to
 */
- (void)setWidth:(float)width;

/**
 Moves the view to the given position on the X axis
 @param x The x value to set the frames origin to
 */
- (void)setX:(float)x;

/**
 Moves the view to the given position on the Y axis
 @param y The y value to set the frames origin to
 */
- (void)setY:(float)y;

/**
 Moves the view's centre x coordinate to the given position
 @param x The x value to set the frames centre point to
 */
- (void)setCenterX:(float)x;

/**
 Moves the view's centre y coordinate to the given position
 @param y The x value to set the frames centre point to
 */
- (void)setCenterY:(float)y;

/**
Sets the view's size to the given size
@param size The size to give the view
*/
- (void)setSize:(CGSize)size;

/**
Sets the view's origin to the given point
@param origin The point to set as the view's origin
*/
- (void)setOrigin:(CGPoint)origin;


/**
 Enumerates the subviews of this view, and every subview of every subview recursively until told to stop.
 @discussion At any point you can set stop to true on the handler and the process will end
 @param handler The handler of which to pass every view to.
 */
- (void)enumerateSubviewsUsingHandler:(TSCViewEnumerationHandler)handler;

/**
 Centers all of the subviews in the view vertically, maintaining their current spacing
 @discussion Please configure the vertical spacing of your views before calling this method as that spacing will be maintained
 */
- (void)centerSubviewsVertically;

/**
 Centers all of the subviews in the view vertically, maintaining their current spacing and offsetting all views by the given value vertically
 @discussion Please configure the vertical spacing of your views before calling this method as that spacing will be maintained
 @param offset The value to offset the views by.
 */
- (void)centerSubviewsVerticallyWithOffset:(CGFloat)offset;

/**
 Centers all of the subviews in the view vertically, maintaining their current spacing and offsetting all views by the given value vertically whilst ignoring any number of views
 @discussion Please configure the vertical spacing of your views before calling this method as that spacing will be maintained
 @param excludedViews Any views that you do not want to center. These will be ignored.
 @param offset The value to offset the views by.
 */
- (void)centerSubviewsVerticallyExcludingViews:(NSArray *)excludedViews withOffset:(CGFloat)offset;

/**
 Centers all of the subviews in the view vertically, maintaining their current spacing and ignoring any number of views.
 @discussion Please configure the vertical spacing of your views before calling this method as that spacing will be maintained
 @param excludedViews Any views that you do not want to center. These will be ignored.
 */
- (void)centerSubviewsVerticallyExcludingViews:(NSArray *)excludedViews;

/**
 Gets the height of the subviews by checking the position and height of the highest view
 @return The height of all subviews
 */
- (CGFloat)heightOfSubviews;

@end
