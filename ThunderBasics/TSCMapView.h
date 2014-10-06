//
//  TSCMapView.h
//  ThunderBasics
//
//  Created by Phillip Caudell on 29/05/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "TSCAnnotation.h"

@interface TSCMapView : MKMapView <MKMapViewDelegate>

@property (nonatomic, assign) BOOL shouldGroupAnnotations;
@property (nonatomic, strong) NSArray *allAnnotations;
@property (nonatomic, strong) NSMutableArray *groupedAnnotations;

- (void)updateVisibleAnnotations;

/**
 Should be implemented in their respective MKMapViewDelegate
 */
- (void)regionDidChangeAnimated:(BOOL)animated;

/**
 Should be implemented in their respective MKMapViewDelegate
 */
- (void)didAddAnnotationViews:(NSArray *)views;

@end
