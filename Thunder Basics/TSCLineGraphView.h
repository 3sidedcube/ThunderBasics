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

@protocol TSCGraphViewDataSource <NSObject>

@required
- (NSInteger)numberOfPointsInGraphView:(TSCLineGraphView *)graphView;
- (NSNumber *)graphView:(TSCLineGraphView *)graphView xValueAtIndex:(NSInteger)index;
- (NSNumber *)graphView:(TSCLineGraphView *)graphView yValueAtIndex:(NSInteger)index;

@optional
- (NSString *)graphView:(TSCLineGraphView *)graphView xLabelAtIndex:(NSInteger)index;
- (NSString *)graphView:(TSCLineGraphView *)graphView yLabelAtIndex:(NSInteger)index;

@end

@interface TSCLineGraphView : UIView

@property (nonatomic, weak) id <TSCGraphViewDataSource> dataSource;
@property (nonatomic, strong) NSArray *points;
@property (nonatomic, strong) NSArray *xLabels;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;

- (void)reloadDataAnimated:(BOOL)animated;
- (void)plotPointsAnimated:(BOOL)animated;
- (void)setLineColors:(NSArray *)colors;

@end
