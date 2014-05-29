//
//  TSCAnnotation.h
//  ThunderBasics
//
//  Created by Phillip Caudell on 29/05/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol TSCAnnotation <MKAnnotation>

@required
- (id <TSCAnnotation>)parentAnnotation;
- (void)setParentAnnotation:(id <TSCAnnotation>)annotation;
- (NSArray *)childAnnotations;
- (void)setChildAnnotations:(NSArray *)childAnnotations;

@end
