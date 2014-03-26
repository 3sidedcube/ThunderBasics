//
//  TSCGraphView.m
//  GraphView
//
//  Created by Phillip Caudell on 19/02/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import "TSCLineGraphView.h"

@implementation TSCLineGraphView

- (id)init
{
    if (self = [super init]) {
        
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.fillColor = [[UIColor clearColor]  CGColor];
        
        self.gradientLayer = [CAGradientLayer layer];
        [self.layer addSublayer:self.gradientLayer];
        
        self.lineWidth = 2.0;
        [self setLineColors:@[[UIColor yellowColor], [UIColor colorWithRed:0.99 green:0.36 blue:0 alpha:1]]];
        
        self.clipsToBounds = NO;
    }
    
    return self;
}

#pragma mark Options

- (void)setLineColor:(UIColor *)lineColor
{
    [self setLineColors:@[(id)[lineColor CGColor]]];
}

- (void)setLineColors:(NSArray *)colors
{
    NSMutableArray *cgColors = [NSMutableArray array];
    
    for (UIColor *color in colors) {
        
        [cgColors addObject:(id)[color CGColor]];
    }
    
    self.gradientLayer.colors = cgColors;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    self.shapeLayer.lineWidth = lineWidth;
}

- (void)setDataSource:(id<TSCGraphViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadDataAnimated:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
}

- (void)reloadDataAnimated:(BOOL)animated
{
    NSMutableArray *points = [NSMutableArray array];
    NSInteger numberOfPoints = [self.dataSource numberOfPointsInGraphView:self];
    
    for (NSInteger index = 0; index <= numberOfPoints; index++) {
        
        TSCGraphPoint *point = [TSCGraphPoint new];
        point.xValue = [self.dataSource graphView:self xValueAtIndex:index];
        point.yValue = [self.dataSource graphView:self yValueAtIndex:index];
        
        if ([self.dataSource respondsToSelector:@selector(graphView:xLabelAtIndex:)]) {
            point.xLabel = [self.dataSource graphView:self xLabelAtIndex:index];
        }
        
        if ([self.dataSource respondsToSelector:@selector(graphView:yLabelAtIndex:)]) {
            point.yLabel = [self.dataSource graphView:self yLabelAtIndex:index];
        }
        
        [points addObject:point];
    }
    
    self.points = points;
    [self plotPointsAnimated:animated];
}

- (void)plotPointsAnimated:(BOOL)animated;
{
    [self.shapeLayer removeFromSuperlayer];
    
    for (UILabel *label in self.xLabels) {
        [label removeFromSuperview];
    }
    
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }
    
    NSSortDescriptor *ySortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"yValue" ascending:YES];
    NSArray *ySortedPoints = [self.points sortedArrayUsingDescriptors:@[ySortDescriptor]];
    TSCGraphPoint *maxYGraphPoint = [ySortedPoints lastObject];
    TSCGraphPoint *minYGraphPoint = [ySortedPoints firstObject];
    
    NSSortDescriptor *xSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"xValue" ascending:YES];
    NSArray *xSortedPoints = [self.points sortedArrayUsingDescriptors:@[xSortDescriptor]];
    TSCGraphPoint *maxXGraphPoint = [xSortedPoints lastObject];
    TSCGraphPoint *minXGraphPoint = [xSortedPoints firstObject];
    
    UIBezierPath *path = [UIBezierPath new];

    TSCGraphPoint *previousGraphPoint = [self.points firstObject];
    [path moveToPoint:[self normalisedCGPointWithGraphPoint:previousGraphPoint maxY:maxYGraphPoint minY:minYGraphPoint maxX:maxXGraphPoint minX:minXGraphPoint]];

    for (TSCGraphPoint *graphPoint in self.points) {
        
        CGPoint previousPoint = [self normalisedCGPointWithGraphPoint:previousGraphPoint maxY:maxYGraphPoint minY:minYGraphPoint maxX:maxXGraphPoint minX:minXGraphPoint];
        CGPoint currentPoint  = [self normalisedCGPointWithGraphPoint:graphPoint maxY:maxYGraphPoint minY:minYGraphPoint maxX:maxXGraphPoint minX:minXGraphPoint];
        
        CGPoint controlPoint1 = CGPointMake(previousPoint.x + 20, previousPoint.y);
        CGPoint controlPoint2 = CGPointMake(currentPoint.x - 20, currentPoint.y);
        
        // Don't plot first one as it looks fucking cray
        if (![[self.points firstObject] isEqual:previousGraphPoint]) {
            [path addCurveToPoint:currentPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
        }
       
        previousGraphPoint = graphPoint;
    }
    
    self.shapeLayer.path = [path CGPath];
    self.shapeLayer.frame = self.bounds;
    self.shapeLayer.strokeColor = [[UIColor blackColor] CGColor];
    self.gradientLayer.mask = self.shapeLayer;
    
    if (animated) {
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 2.0;
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    }
    
    NSMutableArray *xLabels = [NSMutableArray array];
//    NSMutableArray *yLabels = [NSMutableArray array];

    for (TSCGraphPoint *graphPoint in self.points) {
        
        CGPoint currentPoint  = [self normalisedCGPointWithGraphPoint:graphPoint maxY:maxYGraphPoint minY:minYGraphPoint maxX:maxXGraphPoint minX:minXGraphPoint];

        UILabel *xLabel = [UILabel new];
        xLabel.text = graphPoint.xLabel;
        xLabel.textColor = [UIColor whiteColor];
        xLabel.font = [UIFont systemFontOfSize:12];
        xLabel.textAlignment = NSTextAlignmentCenter;
        xLabel.frame = CGRectMake(currentPoint.x, self.bounds.size.height - 30, 30, self.bounds.size.width / self.points.count);
        
        [self addSubview:xLabel];
        [xLabels addObject:xLabel];
        
//        UILabel *yLabel = [UILabel new];
//        yLabel.text = graphPoint.yLabel;
//        yLabel.textColor = [UIColor whiteColor];
//        yLabel.font = [UIFont systemFontOfSize:12];
//        yLabel.textAlignment = NSTextAlignmentCenter;
//        yLabel.frame = CGRectMake(0, currentPoint.y, 30, self.bounds.size.width / self.points.count);
//        
//        [self addSubview:yLabel];
//        [xLabels addObject:yLabel];
    }
    
    self.xLabels = xLabels;
}

- (CGPoint)normalisedCGPointWithGraphPoint:(TSCGraphPoint *)point maxY:(TSCGraphPoint *)maxYGraphPoint minY:(TSCGraphPoint *)minYGraphPoint maxX:(TSCGraphPoint *)maxXGraphPoint minX:(TSCGraphPoint *)minXGraphPoint
{
//    CGFloat minY = minYGraphPoint.yValue.integerValue;
    CGFloat maxY = maxYGraphPoint.yValue.integerValue;
    
//    CGFloat minX = minXGraphPoint.xValue.integerValue;
    CGFloat maxX = maxXGraphPoint.xValue.integerValue;
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;

    CGFloat y = (point.yValue.floatValue / maxY) * height;
    y = self.bounds.size.height - y;
    CGFloat x = (point.xValue.floatValue / maxX) * width;
    
    if (isnan(y)) {
        y = 0;
    }
    
    if (isnan(x)) {
        x = 0;
    }
    CGPoint p = CGPointMake(x, y);
    
    return p;
}

@end
