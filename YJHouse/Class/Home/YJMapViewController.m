//
//  YJMapViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/6/21.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "YJMapView.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface YJMapViewController ()<MAMapViewDelegate>
@property (nonatomic,strong) YJMapView *mapView;

@end

@implementation YJMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AMapServices sharedServices].enableHTTPS = YES;
    [self setTitle:@"地图定位"];
    ///初始化地图
//    MAMapView *_mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
//    ///把地图添加至view
//    _mapView.delegate = self;
//    [self.view addSubview:_mapView];
//    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
//    _mapView.showsUserLocation = YES;
//    _mapView.userTrackingMode = MAUserTrackingModeFollow;
////    [[NetworkTool sharedTool]requestWithURLString:@"http://restapi.amap.com/v3/geocode/geo?key=389880a06e3f893ea46036f030c94700&s=rsv3&city=35&address=%E6%9D%AD%E5%B7%9E%E5%B8%82%E8%A5%BF%E6%BA%AA%E6%B0%B4%E5%B2%B8%E8%8A%B1%E8%8B%91" parameters:nil method:GET callBack:^(id responseObject) {
////        
////    } error:^(NSError *error) {
////        
////    }];
//    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
//    pointAnnotation.coordinate = CLLocationCoordinate2DMake(30.234367, 120.437100);
//    [_mapView addAnnotation:pointAnnotation];
//    _mapView.centerCoordinate = CLLocationCoordinate2DMake(30.234367, 120.437100);
    self.mapView = [[YJMapView alloc] init];
    self.mapView.frame = CGRectMake(0, 64, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH);
    [self.view addSubview:self.mapView];
    [self.mapView showLongitude:120.157091 andLatitude:30.272913];
}

- (void)addAnimation{
 
}
@end
