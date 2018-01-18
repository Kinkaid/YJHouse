//
//  YJTabBarSystemController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/17.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJTabBarSystemController.h"
#import "YJHomePageViewController.h"
#import "YJUserCenterViewController.h"
#import "YJPricateCustomViewController.h"
#import "YJImage.h"
#import "YJBaseNavigationController.h"
@interface YJTabBarSystemController ()

@end

@implementation YJTabBarSystemController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customerTabBar];
}

- (void)customerTabBar {
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    bgView.backgroundColor = [UIColor ex_colorFromHexRGB:@"F6F6F6"];
    [self.tabBar insertSubview:bgView atIndex:0];
    
    YJHomePageViewController *vc1 = [[YJHomePageViewController alloc] init];
    UINavigationController *nav1 = [[YJBaseNavigationController alloc]initWithRootViewController:vc1];
    vc1.tabBarItem.title = @"首页";
    [vc1.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor ex_colorFromHexRGB:@"44A7FB"],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    vc1.tabBarItem.selectedImage = [YJImage imageNameWithOriginalMode:[NSString stringWithFormat:@"home_tab_icon1_selec"]];
    vc1.tabBarItem.image = [YJImage imageNameWithOriginalMode:[NSString stringWithFormat:@"home_tab_icon1"]];
    [self addChildViewController:nav1];
    
    YJPricateCustomViewController *vc2 = [[YJPricateCustomViewController alloc] init];
    UINavigationController *nav2 = [[YJBaseNavigationController alloc]initWithRootViewController:vc2];
    vc2.tabBarItem.title = @"私人订制";
    [vc2.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor ex_colorFromHexRGB:@"44A7FB"],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    vc2.tabBarItem.selectedImage = [YJImage imageNameWithOriginalMode:[NSString stringWithFormat:@"home_tab_icon2_selec"]];
    vc2.tabBarItem.image = [YJImage imageNameWithOriginalMode:[NSString stringWithFormat:@"home_tab_icon2"]];
    [self addChildViewController:nav2];
    
    YJUserCenterViewController *vc3 = [[YJUserCenterViewController alloc] init];
    UINavigationController *nav3 = [[YJBaseNavigationController alloc]initWithRootViewController:vc3];
    vc3.tabBarItem.title = @"个人中心";
    [vc3.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor ex_colorFromHexRGB:@"44A7FB"],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    vc3.tabBarItem.selectedImage = [YJImage imageNameWithOriginalMode:[NSString stringWithFormat:@"home_tab_icon3_selec"]];
    vc3.tabBarItem.image = [YJImage imageNameWithOriginalMode:[NSString stringWithFormat:@"home_tab_icon3"]];
    [self addChildViewController:nav3];
}
@end
