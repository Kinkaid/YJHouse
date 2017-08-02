//
//  YJMapDetailViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/7/13.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJMapDetailViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface YJMapDetailViewController ()
@property (nonatomic,strong)MAMapView *mapView;

@end

@implementation YJMapDetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    [AMapServices sharedServices].enableHTTPS = YES;
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self.view addSubview:_mapView];
    [self.view sendSubviewToBack:_mapView];
    NSString *address = [NSString stringWithFormat:@"http://restapi.amap.com/v3/geocode/geo?key=389880a06e3f893ea46036f030c94700&s=rsv3&city=35&address=浙江省杭州市%@",self.address];
    NSString* encodedString = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[NetworkTool sharedTool]requestWithURLString:encodedString parameters:nil method:GET callBack:^(id responseObject) {
        if (!ISEMPTY(responseObject[@"geocodes"])) {
            NSArray *ary = [responseObject[@"geocodes"][0][@"location"] componentsSeparatedByString:@","];
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake([ary[1] floatValue],[ary[0] floatValue]);
            [_mapView addAnnotation:pointAnnotation];
            _mapView.centerCoordinate = pointAnnotation.coordinate;
            [_mapView setZoomLevel:14];
        }
    } error:^(NSError *error) {
    }];


}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
