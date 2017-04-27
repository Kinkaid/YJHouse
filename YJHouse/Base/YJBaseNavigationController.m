//
//  YJBaseNavigationController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/3/11.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJBaseNavigationController.h"

@interface YJBaseNavigationController ()

@end

@implementation YJBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


@end
