//
//  LPLocationManager.h
//  JamGo
//
//  Created by Lipeng on 2017/6/16.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kLPLocationNotification @"kLPLocationNotification"

@interface LPLocationManager : NSObject
LP_SingleInstanceDec(LPLocationManager)
@property(nonatomic,copy) CLLocation *(^location_block)(void);
@property(nonatomic,strong) CLLocation *location;
- (void)start:(NSString *)identifier;
- (void)stop:(NSString *)identifier;
- (void)geocode:(CLLocation *)location block:(void (^)(CLPlacemark *placemark))block;
@end
