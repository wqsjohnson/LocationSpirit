//
//  MKMapView+ZoomLevel.h
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/25.
//

#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMapView (ZoomLevel)
@property (assign, nonatomic) NSUInteger zoomLevel;

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
