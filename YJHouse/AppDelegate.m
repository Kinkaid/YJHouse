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
#import "YJFirstScrollViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#define kGtAppId @"UcDJH8tFZy7fVYqeMx4TS3"
#define kGtAppSecret @"G6HRVjiZ938hiOhOOpdQL8"
#define kGtAppKey @"BFQDaz9AUG9jpW1N955fv2"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注:该 法需要在主线程中调
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册 APNs
    [self registerRemoteNotification];
    [AMapServices sharedServices].apiKey = @"76749794ed5a237799f5b7d7021bf745";
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [NSThread sleepForTimeInterval:1];
    if (ISEMPTY([LJKHelper getZufangWeight_id]) && ISEMPTY([LJKHelper getErshouWeight_id])) {
        YJFirstScrollViewController *vc= [[YJFirstScrollViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nav;
    } else {
        self.tabBar = [[YJTabBarSystemController alloc] init];
        self.window.rootViewController = self.tabBar;
    }
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
                                                                         [appInfo SSDKSetupSinaWeiboByAppKey:wbAppKey
                                                                                                   appSecret:wbAppSecret
                                                                                                 redirectUri:@"http://www.sharesdk.cn"
                                                                                                    authType:SSDKAuthTypeBoth];
                                                                         break;
                                                                     case SSDKPlatformTypeWechat:
                                                                         [appInfo SSDKSetupWeChatByAppId:wxAppID
                                                                                               appSecret:wxAppSecret];
                                                                         break;
                                                                     case SSDKPlatformTypeQQ:
                                                                         [appInfo SSDKSetupQQByAppId:qqAppID
                                                                                              appKey:qqAppKey
                                                                                            authType:SSDKAuthTypeBoth];
                                                                         break;
                                                                     default:
                                                                         break;
                                                                 }
                                                                 
                                                             }];
}
- (void)registerRemoteNotification {
    [GeTuiSdk resetBadge];
    //如果需要角标清空需要调用系统方法设置
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    // 向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // 将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

//  iOS 10: App在前台获取到通知 对于iOS 10 及以后版本，为处理 APNs 通知点击，统计有效用户点击数
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发，在该方法内统计有效用户点击数
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    completionHandler();
//    SystemUser *user =  [SystemUser shareInstance];
//    if (user.isLogin) {
//        if (!ISEMPTY(response.notification.request.content.userInfo[@"tid"])) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kPushRemoteNotification object:response.notification.request.content.userInfo];
//        }
//    }
}
#endif
/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    [[NSUserDefaults standardUserDefaults] setObject:clientId forKey:@"clientId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    NSData * data = [payloadMsg dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if (!offLine) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kOrderReceiveRemoteNotification object:jsonDict];
    }
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
