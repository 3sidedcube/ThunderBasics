//
//  TSCMapView.h
//  ThunderBasics
//
//  Created by Phillip Caudell on 29/05/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "TSCAnnotation.h"

/**
 `TSCMapView` is a subclass of MKMapView with added grouping of annotations.
 */
@interface TSCMapView : MKMapView <MKMapViewDelegate>

/**
 @abstract A boolean which determines whether the MapView should group annotations or not.
 */
@property (nonatomic, assign) BOOL shouldGroupAnnotations;

/**
 @abstract An array of all the annotations present on the `TSCMapView`.
 @discussion This is an array of the separate annotations pulled out of their groups.
 */
@property (nonatomic, strong, nullable) NSArray< __kindof NSObject <MKAnnotation> *> *allAnnotations;

/**
 @abstract An array of grouped annotations present on the `TSCMapView`
 */
@property (nonatomic, strong, nullable) NSMutableArray <__kindof NSObject <MKAnnotation> *> *groupedAnnotations;

/**
 This method re-organizes the annotations into the correct groups.
 @discussion This method is called internally when adding or removing annotations and when the user scrolls the `TSCMapView`. You should not need to call it yourself.
 */
- (void)updateVisibleAnnotations;

/**
 This method should be implemented in your respective MKMapViewDelegate.
 @param animated Whether the region change was animated or not.
 */
- (void)regionDidChangeAnimated:(BOOL)animated;

/**
 This method Should be implemented in your respective MKMapViewDelegate.
 @param views The annotation views which were added to the `TSCMapView`.
 */
- (void)didAddAnnotationViews:(NSArray <__kindof NSObject <MKAnnotation> *> * _Nonnull)views;

/**
 Zooms the map view to fit the given polygons
 @param polygons The polygons that the map view should fit to
 */
- (void)fitMapToPolygons:(NSArray <MKPolygon *> * _Nonnull)polygons;

/**
 Zooms the map view to fit the given polygons
 @param polygons The polygons that the map view should fit to
 @param animated Whether or not the zoom should be animated
 */
- (void)fitMapToPolygons:(NSArray <MKPolygon *> * _Nonnull)polygons animated:(BOOL)animated;


/**
 Zooms the map view to fit both the given polygons and annotations

 @param polygons The polygons that the map view should fit to
 @param annotations The annotations that the map view should fit to
 @param animated Whether or not the zoom should be animated
 */
- (void)fitMapToPolygons:(NSArray <MKPolygon *> * _Nullable)polygons andAnnotations:(NSArray <id <MKAnnotation>> * _Nullable)annotations animated:(BOOL)animated;

@end
