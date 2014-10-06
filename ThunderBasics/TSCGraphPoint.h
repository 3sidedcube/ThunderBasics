//
//  TSCGraphViewPoint.h
//  GraphView
//
//  Created by Phillip Caudell on 19/02/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSCGraphPoint : NSObject

@property (nonatomic, strong) NSNumber *xValue;
@property (nonatomic, strong) NSNumber *yValue;
@property (nonatomic, strong) NSString *xLabel;
@property (nonatomic, strong) NSString *yLabel;

@end
