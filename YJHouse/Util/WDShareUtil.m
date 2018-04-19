//
//  WDShareUtil.m
//  wadaoduobao
//
//  Created by 刘金凯 on 2016/10/12.
//  Copyright © 2016年 iju. All rights reserved.
//

#import "WDShareUtil.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
@implementation WDShareUtil


+ (void)shareTye:(WDShareType)ShareType withImageAry:(NSArray *)imageAry withUrl:(NSString *)url withTitle:(NSString *)title withContent:(NSString *)content isPic:(BOOL)isPic{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    if (ShareType == shareSinaWeibo) {
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@%@",title,url]
                                         images:imageAry
                                            url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]
                                          title:title
                                           type:SSDKContentTypeImage];
    } else {
        [shareParams SSDKSetupShareParamsByText:content
                                         images:imageAry
                                            url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]
                                          title:title
                                           type:isPic?SSDKContentTypeImage:SSDKContentTypeAuto];
    }
    
    SSDKPlatformType platFormType;
    switch (ShareType) {
        case shareQQFriends:
        {
            platFormType = SSDKPlatformSubTypeQQFriend;
        }
            break;
        case shareQQzone:
        {
            platFormType = SSDKPlatformSubTypeQZone;
        }
            break;
        case shareWXFriends:
        {
            platFormType = SSDKPlatformSubTypeWechatSession;
        }
            break;
        case shareWXzone:
        {
            platFormType = SSDKPlatformSubTypeWechatTimeline;
        }
            break;
        case shareSinaWeibo:
        {
            platFormType = SSDKPlatformTypeSinaWeibo;
        }
            break;
        default:
            break;
    }
    [SVProgressHUD dismiss];
    [ShareSDK share:platFormType
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@", error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
//             case SSDKResponseStateCancel:
//             {
//                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
//                                                                     message:nil
//                                                                    delegate:nil
//                                                           cancelButtonTitle:@"确定"
//                                                           otherButtonTitles:nil];
//                 [alertView show];
//                 break;
//             }
             default:
                 break;
         }
     }];
}

@end
