//
//  TSCAnnotation.h
//  ThunderBasics
//
//  Created by Phillip Caudell on 29/05/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

/**An extenstion of the `MKAnnotation` protocol used for grouping annotations on a map view */
@protocol TSCAnnotation <MKAnnotation>

@required

/**Returns the parent annotation of the annotation.
 @discussion This will only be set if the annotation is within an annotation cluster
 */
- (id <TSCAnnotation>)parentAnnotation;

- (void)setParentAnnotation:(id <TSCAnnotation>)annotation;
- (NSArray *)childAnnotations;
- (void)setChildAnnotations:(NSArray *)childAnnotations;

@end
