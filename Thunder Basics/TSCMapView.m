//
//  TSCMapView.m
//  ThunderBasics
//
//  Created by Phillip Caudell on 29/05/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import "TSCMapView.h"

@interface TSCMapView ()

@property (nonatomic, strong) MKMapView *allAnnotationMapView;
@property (nonatomic, weak) id <MKMapViewDelegate> externalDelegate;

@end

@implementation TSCMapView

- (id)init
{
    if (self = [super init]) {
        
        self.allAnnotationMapView = [MKMapView new];
    }
    
    return self;
}

- (void)addAnnotations:(NSArray *)annotations
{
    [self.allAnnotationMapView addAnnotations:annotations];
    [self updateVisibleAnnotations];
}

#pragma mark Helpers

- (void)updateVisibleAnnotations
{
    // Get the visible area of the map view, and add some padding around that area so when a user pans they see pins out of view too
    static float marginFactor = 2.0;
    MKMapRect visibleMapRect = [self visibleMapRect];
    MKMapRect adjustedVisibleMapRect = MKMapRectInset(visibleMapRect, - marginFactor * visibleMapRect.size.width, - marginFactor * visibleMapRect.size.height);
    
   // Determine how wide each bucket will be
    static float bucketSize = 60.0;
    CLLocationCoordinate2D leftCoordinate = [self convertPoint:CGPointZero toCoordinateFromView:self];
    CLLocationCoordinate2D rightCoordinate = [self convertPoint:CGPointMake(bucketSize, 0) toCoordinateFromView:self];
    
    double gridSize = MKMapPointForCoordinate(rightCoordinate).x - MKMapPointForCoordinate(leftCoordinate).x;
    MKMapRect gridMapRect = MKMapRectMake(0, 0, gridSize, gridSize);
    
    // Condense annotations, with a padding of two squares around visibleMapRect
    double startX = floor(MKMapRectGetMinX(adjustedVisibleMapRect) / gridSize) * gridSize;
    double startY = floor(MKMapRectGetMinY(adjustedVisibleMapRect) / gridSize) * gridSize;
    double endX = floor(MKMapRectGetMaxX(adjustedVisibleMapRect) / gridSize) * gridSize;
    double endY = floor(MKMapRectGetMaxY(adjustedVisibleMapRect) / gridSize) * gridSize;
    
    // For each square in our grid, pick one annotation to show...
    gridMapRect.origin.y = startY;
    
    while (MKMapRectGetMinY(gridMapRect) <= endY) {
        
        gridMapRect.origin.x = startX;
        
        while (MKMapRectGetMinX(gridMapRect) <= endX) {
            
            NSMutableSet *allAnnotationsInBucket = [[self.allAnnotationMapView annotationsInMapRect:gridMapRect] mutableCopy];
            NSSet *visibleAnnotationsInBucket = [self annotationsInMapRect:gridMapRect];
            
            id <TSCAnnotation> annotationForGrid = [self annotationInGrid:gridMapRect usingAnnotations:allAnnotationsInBucket];
            
            if (annotationForGrid) {
                
                [allAnnotationsInBucket removeObject:annotationForGrid];
                [annotationForGrid setChildAnnotations:[allAnnotationsInBucket allObjects]];
            }
            
            [self addAnnotation:annotationForGrid];
            
            // Remove annotations that now have a parent
            for (id <TSCAnnotation> annotation in allAnnotationsInBucket) {
                
                [annotation setParentAnnotation:annotationForGrid];
                [annotation setChildAnnotations:nil];
                
                if ([visibleAnnotationsInBucket containsObject:annotation]) {
                    
                    CLLocationCoordinate2D actualCoordinate = [annotation coordinate];
                    [UIView animateWithDuration:0.3 animations:^{
                        [annotation setCoordinate:[[annotation parentAnnotation] coordinate]];
                    } completion:^(BOOL finished) {
                        
                        [annotation setCoordinate:actualCoordinate];
                        [self removeAnnotation:annotation];
                    }];
                }
            }
            
            // Move along
            gridMapRect.origin.x += gridSize;
        }
        
        // KEEP MOVING THROUGH THE MAP
        gridMapRect.origin.y += gridSize;
    }
}

- (id <MKAnnotation>)annotationInGrid:(MKMapRect)gridMapRect usingAnnotations:(NSSet *)annotations
{
    // Are annotations we're already showing visible?
    NSSet *visibleAnnotationsInBucket = [self annotationsInMapRect:gridMapRect];
    NSSet *annotationsForGridSet = [annotations objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        
        BOOL returnValue = ([visibleAnnotationsInBucket containsObject:obj]);
        
        if (returnValue) {
            *stop = YES;
        }
        
        return returnValue;
    }];
    
    if (annotationsForGridSet.count != 0) {
        return [annotationsForGridSet anyObject];
    }
    
    // If not, sort the annotations based on their distance from the centre of the grid, then choose of the closest to the centre to show
    MKMapPoint centerMapPoint = MKMapPointMake(MKMapRectGetMidX(gridMapRect), MKMapRectGetMidY(gridMapRect));
    NSArray *sortedAnnotations = [[annotations allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
       
        MKMapPoint mapPoint1 = MKMapPointForCoordinate([((id <MKAnnotation>)obj1) coordinate]);
        MKMapPoint mapPoint2 = MKMapPointForCoordinate([((id <MKAnnotation>)obj2) coordinate]);
        
        CLLocationDistance distance1 = MKMetersBetweenMapPoints(mapPoint1, centerMapPoint);
        CLLocationDistance distance2 = MKMetersBetweenMapPoints(mapPoint2, centerMapPoint);
        
        if (distance1 < distance2) {
            return NSOrderedAscending;
        } else if (distance1 > distance2) {
            return NSOrderedDescending;
        }
        
        return NSOrderedSame;
    }];
    
    return [sortedAnnotations firstObject];
}

#pragma mark Map View Delegate - sorta

- (void)regionDidChangeAnimated:(BOOL)animated
{
    [self updateVisibleAnnotations];
}

- (void)didAddAnnotationViews:(NSArray *)views
{
    for (MKAnnotationView *annotationView in views) {
        
        id <TSCAnnotation> annotation = annotationView.annotation;
        
        CLLocationCoordinate2D actualCoordinate = [annotation coordinate];
        CLLocationCoordinate2D containerCoordinate = [[annotation parentAnnotation] coordinate];
        
        [annotation setParentAnnotation:nil];
        [annotation setCoordinate:containerCoordinate];

        [UIView animateWithDuration:0.3 animations:^{
            [annotation setCoordinate:actualCoordinate];
        } completion:nil];
    }
}

@end
