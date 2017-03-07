//
//  AppDelegate.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/17.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.tabBar = [[YJTabBarSystemController alloc] init];
    self.window.rootViewController = self.tabBar;
    [self.window makeKeyAndVisible];
    [self setShareSDK];
    return YES;
}
- (void)setShareSDK {
    [ShareSDK registerApp:@"1ba668c093e3e" activePlatforms:@[
                                                             @(SSDKPlatformTypeSinaWeibo),
                                                             @(SSDKPlatformTypeWechat),
                                                             @(SSDKPlatformTypeQQ),
                                                             ] onImport:^(SSDKPlatformType platformType) {
                                                               switch (platformType)
                                                                 {
                                                                     case SSDKPlatformTypeWechat:
                                                                         [ShareSDKConnector connectWeChat:[WXApi class]];
                                                                         break;
                                                                     case SSDKPlatformTypeQQ:
                                                                         [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                                                         break;
                                                                     case SSDKPlatformTypeSinaWeibo:
                                                                         [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                                                         break;
                                                                     default:
                                                                         break;
                                                                 }
                                                             } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                                                 switch (platformType)
                                                                 {
                                                                     case SSDKPlatformTypeSinaWeibo:
                                                                         //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                                                                         [appInfo SSDKSetupSinaWeiboByAppKey:@"1385005150"
                                                                                                   appSecret:@"76ceddc86e84a34cbb50490bfa96795c"
                                                                                                 redirectUri:@"http://www.sharesdk.cn"
                                                                                                    authType:SSDKAuthTypeBoth];
                                                                         break;
                                                                     case SSDKPlatformTypeWechat:
                                                                         [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                                                                               appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                                                                         break;
                                                                     case SSDKPlatformTypeQQ:
                                                                         [appInfo SSDKSetupQQByAppId:@"1105936467"
                                                                                              appKey:@"EdCOPrpZsOW516qO"
                                                                                            authType:SSDKAuthTypeBoth];
                                                                         break;
                                                                     default:
                                                                         break;
                                                                 }
                                                                 
                                                             }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
