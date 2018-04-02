//
//  LPLocationManager.m
//  JamGo
//
//  Created by Lipeng on 2017/6/16.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "LPLocationManager.h"
#import "LPBDCoordinate.h"

static const double a = 6378245.0;
static const double ee = 0.00669342162296594323;

@interface LPLocationManager()<CLLocationManagerDelegate>
@property(nonatomic,strong) CLLocationManager *manager;
@property(nonatomic,strong) CLGeocoder *geocoder;
@property(nonatomic,strong) NSMutableArray *identifiers;
@property(nonatomic,strong) LPHttpClient *httpClient;
@end

@implementation LPLocationManager
LP_SingleInstanceImpl(LPLocationManager)
- (id)init
{
    if (self=[super init]) {
        _manager=[[CLLocationManager alloc] init];
        _manager.distanceFilter=kCLDistanceFilterNone;
        _manager.desiredAccuracy=kCLLocationAccuracyBest;
        _manager.delegate=self;
        _identifiers=[NSMutableArray array];
        
        _geocoder=[[CLGeocoder alloc] init];
        _httpClient=[[LPHttpClient alloc] init];
    }
    return self;
}
- (void)start:(NSString *)identifier
{
    __weak typeof(self) wself=self;
    [[LPAuthProxy shared] authLocation:^{
        [wself.manager requestWhenInUseAuthorization];
        if (NSNotFound==[wself.identifiers indexOfObject:identifier]){
            [wself.identifiers addObject:identifier];
        }
        [wself.manager startUpdatingLocation];
    } done_block:^(BOOL ready) {
        [wself.manager requestWhenInUseAuthorization];
        if (NSNotFound==[wself.identifiers indexOfObject:identifier]){
            [wself.identifiers addObject:identifier];
        }
        [wself.manager startUpdatingLocation];
    }];
}
- (void)stop:(NSString *)identifier
{
    [_identifiers removeObject:identifier];
    if (0==_identifiers.count){
        [_manager stopUpdatingLocation];
    }
}
- (void)geocode:(CLLocation *)location block:(void (^)(CLPlacemark *))block
{
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        block(placemarks.firstObject);
    }];
}
#pragma
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (locations.count>0){
        CLLocation *location=nil;
        if (_location_block){
            location=_location_block();
        }
        if (nil==location){
            location=locations[0];
            CLLocationCoordinate2D coordinate=[self transformFromWGSToGCJ:location.coordinate];
            location=[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        }
        _location=location;
        LP_PostNotification(kLPLocationNotification,location,nil);
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
//    LP_PostNotification(kLPLocationNotification,nil,nil);
}

- (void)bdTransformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc
{
    NSString *url=[NSString stringWithFormat:@"https://api.map.baidu.com/ag/coord/convert?from=0&to=2&x=%lf&y=%lf",wgsLoc.longitude,wgsLoc.latitude];
    [_httpClient HTTP_GET:url block:^(HTTPErrorCode statusCode, NSData *data) {
        LPBDCoordinate *bd=nil;
        if (nil!=data) {
            NSString *txt=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            bd=[LPBDCoordinate mj_objectWithKeyValues:txt];
        }
        if (nil!=bd && 0==bd.error){
//            bd.x=[[NSString alloc] initWithData:[QN_GTM_Base64 decodeString:bd.x] encoding:NSUTF8StringEncoding];
//            bd.y=[[NSString alloc] initWithData:[QN_GTM_Base64 decodeString:bd.y] encoding:NSUTF8StringEncoding];
            CLLocation *location=[[CLLocation alloc] initWithLatitude:bd.y.doubleValue longitude:bd.x.doubleValue];
            LP_PostNotification(kLPLocationNotification,location,nil);
        } else {
            CLLocation *location=[[CLLocation alloc] initWithLatitude:wgsLoc.latitude longitude:wgsLoc.longitude];
            LP_PostNotification(kLPLocationNotification,location,nil);
        }
    }];
}
- (CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc
{
    CLLocationCoordinate2D adjustLoc;
    if ([self isLocationOutOfChina:wgsLoc]){
        adjustLoc = wgsLoc;
    }else{
        double adjustLat = [self transformLatWithX:wgsLoc.longitude - 105.0 withY:wgsLoc.latitude - 35.0];
        double adjustLon = [self transformLonWithX:wgsLoc.longitude - 105.0 withY:wgsLoc.latitude - 35.0];
        double radLat = wgsLoc.latitude / 180.0 * M_PI;
        double magic = sin(radLat);
        magic = 1 - ee * magic * magic;
        double sqrtMagic = sqrt(magic);
        adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
        adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
        adjustLoc.latitude = wgsLoc.latitude + adjustLat - 0.00039900; // 减去这个数字 完全是凑数，准确性有待验证
        adjustLoc.longitude = wgsLoc.longitude + adjustLon;
    }
    return adjustLoc;
}
- (BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location
{
    if (location.longitude < 72.004 || location.longitude > 137.8347 || location.latitude < 0.8293 || location.latitude > 55.8271)
        return YES;
    return NO;
}
- (double)transformLatWithX:(double)x withY:(double)y
{
    double lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    lat += (20.0 * sin(6.0 * x * M_PI) + 20.0 *sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    lat += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    lat += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return lat;
}

- (double)transformLonWithX:(double)x withY:(double)y
{
    double lon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    lon += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    lon += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    lon += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return lon;
}
@end
