//
//  TSCGraphViewPoint.m
//  GraphView
//
//  Created by Phillip Caudell on 19/02/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import "TSCGraphPoint.h"

@implementation TSCGraphPoint

- (NSString *)description
{
    return [NSString stringWithFormat:@"<TSCGraphPoint X: %@ | Y: %@>", self.xValue, self.yValue];
}

@end
