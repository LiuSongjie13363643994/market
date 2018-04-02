//
//  MKMapView+LP.h
//  MrMood
//
//  Created by Lipeng on 16/10/4.
//  Copyright © 2016年 Lipeng. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView(LP)
@property(nonatomic,assign) BOOL dragging;
@property(nonatomic,assign) BOOL fixed;
@property(nonatomic,assign) BOOL ready;
@property(nonatomic,copy) void (^addSubview_block)(UIView *view);
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;
- (NSUInteger)zoomLevel;
- (UIView *)compassView;

+ (void)loadSwizzling;
@end
