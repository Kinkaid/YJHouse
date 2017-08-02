//
//  YJMapView.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/7/12.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJMapView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
@implementation YJMapView{
    MAMapView*_mapView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [AMapServices sharedServices].enableHTTPS = YES;
        _mapView = [[MAMapView alloc] initWithFrame:self.bounds];
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        _mapView.showsCompass = NO;
        [self addSubview:_mapView];
    }
    return self;
}
- (void)showLongitude:(CGFloat)longitude andLatitude:(CGFloat)latitude {
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(latitude,longitude);
    [_mapView addAnnotation:pointAnnotation];
    _mapView.centerCoordinate = pointAnnotation.coordinate;
    [_mapView setZoomLevel:14];
}
@end
