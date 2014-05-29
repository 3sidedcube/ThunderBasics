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

- (void)regionDidChangeAnimated:(BOOL)animated;
- (void)didAddAnnotationViews:(NSArray *)views;

@end
