//
//  AppDelegate.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/17.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeTuiSdk.h"
#import "YJTabBarSystemController.h"
// iOS10 及以上需导  UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate : UIResponder <UIApplicationDelegate, GeTuiSdkDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)YJTabBarSystemController *tabBar;

@end

