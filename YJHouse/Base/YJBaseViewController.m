//
//  YJBaseViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/17.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJBaseViewController.h"
@interface YJBaseViewController ()

@end

@implementation YJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor ex_colorFromHexRGB:@"A746E8"]];
    self.navigationController.navigationBar.tintColor = [UIColor ex_colorFromHexRGB:@"FFFFFF"];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [self currentNetworkStatus];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)currentNetworkStatus {
    [YJNetworkHelper networkStatusWithBlock:^(YJNetworkStatusType status) {
        switch (status) {
            case YJNetworkStatusUnknown:
            case YJNetworkStatusNotReachable: {
                
                [YJApplicationUtil alertHud:@"无网络" afterDelay:1];
                break;
            }
            case YJNetworkStatusReachableViaWWAN:
            case YJNetworkStatusReachableViaWiFi: {
                YJLog(@"有网络,请求网络数据");
                break;
            }
        }
        
    }];
}


@end
