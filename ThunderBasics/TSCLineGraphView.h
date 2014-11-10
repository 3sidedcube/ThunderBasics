//
//  TSCGraphView.h
//  GraphView
//
//  Created by Phillip Caudell on 19/02/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSCGraphPoint.h"

@class TSCLineGraphView;

/**
 This protocol can be implemented to provide data to a `TSCLineGraphView` instance. It allows for:
    - providing data points to the `TSCLineGraphView`
    - Providing labels for the `TSCLineGraphView`
 */
@protocol TSCGraphViewDataSource <NSObject>

@required

/**
 The number of points which will be displayed on the `TSCLineGraphView`.
 @param graphView The graph view which the number of points is being provided to.
 */
- (NSInteger)numberOfPointsInGraphView:(TSCLineGraphView *)graphView;

/**
 The x value for the point at a certain index.
 @param graphView The graph view which the value is being provided to.
 @param index The index for which the x value is being provided for.
 */
- (NSNumber *)graphView:(TSCLineGraphView *)graphView xValueAtIndex:(NSInteger)index;

/**
 The y value for the point at a certain index.
 @param graphView The graph view which the value is being provided to.
 @param index The index for which the y value is being provided for.
 */
- (NSNumber *)graphView:(TSCLineGraphView *)graphView yValueAtIndex:(NSInteger)index;

@optional

/**
 The x label for the point at a certain index.
 @param graphView The graph view which the value is being provided to.
 @param index The index for which the label string is being provided for.
 */
- (NSString *)graphView:(TSCLineGraphView *)graphView xLabelAtIndex:(NSInteger)index;

/**
 The y label for the point at a certain index.
 @param graphView The graph view which the value is being provided to.
 @param index The index for which the label string is being provided for.
 */
- (NSString *)graphView:(TSCLineGraphView *)graphView yLabelAtIndex:(NSInteger)index;

@end

/**
 `TSCLineGraphView` is a subclass of UIView which allows for easy displaying of 2D data sets as a line graph.
 
 Implementing the `TSCGraphViewDataSource` protocol enables for a tableView style implementation of graphing on iOS.
 */
@interface TSCLineGraphView : UIView

///---------------------------------------------------------------------------------------
/// @name Configuring the Data Source
///---------------------------------------------------------------------------------------

/**
 @abstract The object which will be used to provide data to the `TSCLineGraphView`.
 @discussion Setting this property will perform an animated reload of the graph.
*/
@property (nonatomic, weak) id <TSCGraphViewDataSource> dataSource;

/**
 @abstract An array of `TSCGraphPoints` to be plotted - or which are currently plotted - on the `TSCLineGraphView`.
 */
@property (nonatomic, strong) NSArray *points;

/**
 @abstract An array of `UILabel` objects which are displayed along the x axis of the graph.
 */
@property (nonatomic, strong) NSArray *xLabels;

/**
 Reloads and redraws the `TSCLineGraphView`.
 @param animated Whether the changes to the graph should be animated, or occur instantaneously.
 */
- (void)reloadDataAnimated:(BOOL)animated;

/**
 Redraws the `TSCLineGraphView` without reloading the data from the datasource.
 @param animated Whether the changes to the graph should be animated, or occur instantaneously.
 */
- (void)plotPointsAnimated:(BOOL)animated;

///---------------------------------------------------------------------------------------
/// @name Configuring the Appearance
///---------------------------------------------------------------------------------------

/**
 @abstract The `CAShapeLayer` which represents the line of the `TSCLineGraphView`.
 */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

/**
 @abstract The `CAGradientLayer` which represents the line of the `TSCLineGraphView`.
 */
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

/**
 @abstract The colour of the line on the graph view.
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 @abstract The width of the line on the graph view.
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 Sets the colours of the gradient layer which represents the line graph's line.
 @param colors The colours to be used in the gradient.
 */
- (void)setLineColors:(NSArray *)colors;

@end
