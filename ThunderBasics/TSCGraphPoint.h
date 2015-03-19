//
//  TSCGraphViewPoint.h
//  GraphView
//
//  Created by Phillip Caudell on 19/02/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `TSCGraphPoint` represents a single data point on a 2-dimensional cartesian coordinate system graph.
 */
@interface TSCGraphPoint : NSObject

/**
 @abstract The x value of the data point.
 */
@property (nonatomic, strong) NSNumber *xValue;

/**
 @abstract The y value of the data point.
 */
@property (nonatomic, strong) NSNumber *yValue;

/**
 @abstract The label to be displayed on the x axis on the graph for this data point.
 */
@property (nonatomic, copy) NSString *xLabel;

/**
 @abstract The label to be displayed on the y axis on the graph for this data point.
 */
@property (nonatomic, copy) NSString *yLabel;

@end
