//
//  MKMapView+LP.m
//  MrMood
//
//  Created by Lipeng on 16/10/4.
//  Copyright © 2016年 Lipeng. All rights reserved.
//

#import "MKMapView+LP.h"
#import <objc/runtime.h>

#define MERCATOR_OFFSET 268435456
#define MERCATOR_RADIUS 85445659.44705395

static char dragKey;
static char fixedKey;
static char readyKey;
static char subviewKey;

@implementation MKMapView(LP)
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (double)longitudeToPixelSpaceX:(double)longitude
{
    return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0);
}

- (double)latitudeToPixelSpaceY:(double)latitude
{
    return round(MERCATOR_OFFSET - MERCATOR_RADIUS * logf((1 + sinf(latitude * M_PI / 180.0)) / (1 - sinf(latitude * M_PI / 180.0))) / 2.0);
}

- (double)pixelSpaceXToLongitude:(double)pixelX
{
    return ((round(pixelX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / M_PI;
}

- (double)pixelSpaceYToLatitude:(double)pixelY
{
    return (M_PI / 2.0 - 2.0 * atan(exp((round(pixelY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / M_PI;
}

#pragma mark -
#pragma mark Helper methods

- (MKCoordinateSpan)coordinateSpanWithMapView:(MKMapView *)mapView
                             centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                 andZoomLevel:(NSUInteger)zoomLevel
{
    // convert center coordiate to pixel space
    double centerPixelX = [self longitudeToPixelSpaceX:centerCoordinate.longitude];
    double centerPixelY = [self latitudeToPixelSpaceY:centerCoordinate.latitude];
    
    // determine the scale value from the zoom level
    NSInteger zoomExponent = 20 - zoomLevel;
    double zoomScale = pow(2, zoomExponent);
    
    // scale the map’s size in pixel space
    CGSize mapSizeInPixels = mapView.bounds.size;
    double scaledMapWidth = mapSizeInPixels.width * zoomScale;
    double scaledMapHeight = mapSizeInPixels.height * zoomScale;
    
    // figure out the position of the top-left pixel
    double topLeftPixelX = centerPixelX - (scaledMapWidth / 2);
    double topLeftPixelY = centerPixelY - (scaledMapHeight / 2);
    
    // find delta between left and right longitudes
    CLLocationDegrees minLng = [self pixelSpaceXToLongitude:topLeftPixelX];
    CLLocationDegrees maxLng = [self pixelSpaceXToLongitude:topLeftPixelX + scaledMapWidth];
    CLLocationDegrees longitudeDelta = maxLng - minLng;
    
    // find delta between top and bottom latitudes
    CLLocationDegrees minLat = [self pixelSpaceYToLatitude:topLeftPixelY];
    CLLocationDegrees maxLat = [self pixelSpaceYToLatitude:topLeftPixelY + scaledMapHeight];
    CLLocationDegrees latitudeDelta = -1 * (maxLat - minLat);
    
    // create and return the lat/lng span
    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
    return span;
}

#pragma mark -
#pragma mark Public methods

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated
{
    // clamp large numbers to 28
    zoomLevel = MIN(zoomLevel, 28);
    // use the zoom level to compute the region
    MKCoordinateSpan span = [self coordinateSpanWithMapView:self centerCoordinate:centerCoordinate andZoomLevel:zoomLevel];
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
    
    // set the region like normal
    [self setRegion:region animated:animated];
}

- (NSUInteger) zoomLevelWithMapView:(MKMapView *) mapView
{
    MKCoordinateRegion region = self.region;
    
    double centerPixelX = [self longitudeToPixelSpaceX:region.center.longitude];
    double topLeftPixelX = [self longitudeToPixelSpaceX:region.center.longitude - region.span.longitudeDelta / 2];
    
    double scaledMapWidth = (centerPixelX - topLeftPixelX) * 2;
    CGSize mapSizeInPixels = mapView.bounds.size;
    double zoomScale = scaledMapWidth / mapSizeInPixels.width;
    double zoomExponent = log(zoomScale) / log(2);
    double zoomLevel = 20 - zoomExponent;
    return zoomLevel;
}

- (NSUInteger)zoomLevel
{
    return [self zoomLevelWithMapView:self];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.dragging=YES;
    [super touchesBegan:touches withEvent:event];
}
- (void)setDragging:(BOOL)dragging
{
    objc_setAssociatedObject(self,&dragKey,@(dragging),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)dragging
{
    NSNumber *xx=objc_getAssociatedObject(self,&dragKey);
    return xx.boolValue;
}
- (void)setFixed:(BOOL)fixed
{
    objc_setAssociatedObject(self,&fixedKey,@(fixed),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)fixed
{
    NSNumber *xx=objc_getAssociatedObject(self,&fixedKey);
    return xx.boolValue;
}
- (void)setReady:(BOOL)ready
{
    self.alpha=ready?1:0;
    objc_setAssociatedObject(self,&readyKey,@(ready),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)ready
{
    NSNumber *xx=objc_getAssociatedObject(self,&readyKey);
    return xx.boolValue;
}
- (void)setAddSubview_block:(void (^)(UIView *))addSubview_block
{
    objc_setAssociatedObject(self,&subviewKey,addSubview_block,OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(UIView *))addSubview_block
{
    return objc_getAssociatedObject(self,&subviewKey);
}
- (void)lp_addSubview:(UIView *)view
{
    [self lp_addSubview:view];
    if (nil!=self.addSubview_block){
        self.addSubview_block(view);
    }
}
+ (void)loadSwizzling
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SwizzleSelector(class,@selector(addSubview:),@selector(lp_addSubview:));
    });
}

@end
