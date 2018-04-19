//
//  WDLoginViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/7/26.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "WDLoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "YJRegisterViewController.h"
@interface WDLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *pwTF;


@end

@implementation WDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *accountBtn = [self.view viewWithTag:1];
    UIButton *pwBtn = [self.view viewWithTag:2];
    [accountBtn setImage:[UIImage imageNamed:@"icon_login_account"] forState:UIControlStateNormal];
    [accountBtn setImage:[UIImage imageNamed:@"icon_login_account_select"] forState:UIControlStateSelected];
    [pwBtn setImage:[UIImage imageNamed:@"icon_login_pw"] forState:UIControlStateNormal];
    [pwBtn setImage:[UIImage imageNamed:@"icon_login_pw_select"] forState:UIControlStateSelected];
    [self.accountTF setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.pwTF setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.accountTF.delegate = self;
    self.pwTF.delegate = self;
    self.navigationBar.hidden = YES;
}
- (IBAction)loginByQQ:(id)sender {
//    if([QQApiInterface isQQInstalled]){
        [ShareSDK getUserInfo:SSDKPlatformTypeQQ
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             if (state == SSDKResponseStateSuccess) {
                 [SVProgressHUD show];
                 NSDictionary *params = @{@"type":@"1",@"tuid":user.uid,@"username":user.nickname,@"device_uid":[[[UIDevice currentDevice] identifierForVendor] UUIDString]};
                 [self thirdLogin:params nick:user.nickname icon:user.icon];
             } else {
                 [YJApplicationUtil alertHud:@"QQ授权失败，请重新尝试" afterDelay:1];
             }
         }];
//    } else {
//        [YJApplicationUtil alertHud:@"请安装QQ客户端授权登录" afterDelay:1];
//    }
}
- (IBAction)loginByWB:(id)sender {
    
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess) {
//             NSLog(@"uid=%@",user.uid);
//             NSLog(@"%@",user.credential);
//             NSLog(@"token=%@",user.credential.token);
//             NSLog(@"nickname=%@",user.nickname);
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD show];
                 NSDictionary *params = @{@"type":@"2",@"tuid":user.uid,@"username":user.nickname,@"device_uid":[[[UIDevice currentDevice] identifierForVendor] UUIDString]};
                 [self thirdLogin:params nick:user.nickname icon:user.icon];
             });
         } else {
             [YJApplicationUtil alertHud:@"微博授权失败，请重新尝试" afterDelay:1];
         }
     }];
}
- (void)thirdLogin:(NSDictionary *)params nick:(NSString *)nick icon:(NSString *)icon {
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/signup",Server_url] parameters:params method:POST callBack:^(id responseObject) {
        [LJKHelper saveAuth_key:responseObject[@"result"][@"user_info"][@"auth_key"]];
        [LJKHelper saveUserID:responseObject[@"result"][@"user_info"][@"user_id"]];
        [LJKHelper saveUserName:responseObject[@"result"][@"user_info"][@"username"]];
        [LJKHelper saveThirdLoginState];
//        [self saveUserInfoWithNick:nick icon:icon];
        [self postHeaderImg:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:icon]]]];
        [self bindRemotePushCid];
    } error:^(NSError *error) {
        [YJApplicationUtil alertHud:@"第三方登录失败" afterDelay:1];
    }];
}
- (void)bindRemotePushCid{
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/set-cid",Server_url] parameters:@{@"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"],@"auth_key":[LJKHelper getAuth_key]} method:POST callBack:^(id responseObject) {
        
    } error:^(NSError *error) {
        NSLog(@"绑定cid错误");
    }];
}
- (void)saveUserInfoWithNick:(NSString *)nick icon:(NSString *)icon {
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/set-username",Server_url] parameters:@{@"username":nick,@"auth_key":[LJKHelper getAuth_key]} method:POST callBack:^(id responseObject) {
        if (!ISEMPTY(responseObject[@"result"])) {
            [LJKHelper saveUserName:nick];
            [weakSelf postHeaderImg:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:icon]]]];
        } else {
            [weakSelf postHeaderImg:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:icon]]]];
        }
    } error:^(NSError *error) {
        
    }];
}
- (void)getUserInfo {
    [SVProgressHUD show];
//    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/user-info",Server_url] parameters:@{@"auth_key":[LJKHelper getAuth_key]} method:POST callBack:^(id responseObject) {
//        if (!ISEMPTY(responseObject)) {
//            if (ISEMPTY(responseObject[@"error"])) {
//                [SVProgressHUD dismiss];
//                if ([responseObject[@"result"][@"weight_ershou"] count]) {
//                    [LJKHelper saveErshouWeight_id:responseObject[@"result"][@"weight_ershou"][0][@"id"]];
//                }
//                if ([responseObject[@"result"][@"weight_zufang"] count]) {
//                    [LJKHelper saveZufangWeight_id:responseObject[@"result"][@"weight_zufang"][0][@"id"]];
//                }
//            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kEditPrivateCustomNotification" object:nil];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//        }
//    } error:^(NSError *error) {
//    }];
}
- (IBAction)loginAction:(id)sender {
    if (ISEMPTY(self.accountTF.text)||ISEMPTY(self.pwTF.text)) {
        return;
    }
    [SVProgressHUD show];
    NSDictionary *params = @{@"email":self.accountTF.text,@"password":self.pwTF.text,@"device_uid":[[[UIDevice currentDevice] identifierForVendor] UUIDString]};
    [SVProgressHUD show];
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/user-info",Server_url] parameters:params method:POST callBack:^(id responseObject) {
        [SVProgressHUD dismiss];
        if (!ISEMPTY(responseObject[@"result"])) {
            [LJKHelper saveThirdLoginState];
            [LJKHelper saveAuth_key:responseObject[@"result"][@"user_info"][@"auth_key"]];
            [LJKHelper saveUserID:responseObject[@"result"][@"user_info"][@"user_id"]];
            [LJKHelper saveUserName:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"user_info"][@"username"]]];
            if (ISEMPTY(responseObject[@"result"][@"user_info"][@"avatar"])) {
                [self postHeaderImg:[UIImage imageNamed:[NSString stringWithFormat:@"icon_private_%d",arc4random()%16]]];
            } else {
                [self getUserInfo];
            }
        } else {
            [YJApplicationUtil alertHud:responseObject[@"error"] afterDelay:1];
        }

    } error:^(NSError *error) {
        [YJApplicationUtil alertHud:@"邮箱登录失败" afterDelay:1];
        [SVProgressHUD dismiss];
    }];
}

- (void)postHeaderImg:(UIImage *)image {
    [SVProgressHUD show];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"multipart/form-data",
                                                                @"text/html",
                                                                @"image/jpeg",
                                                                @"image/png",
                                                                @"application/octet-stream",
                                                                @"text/json",
                                                                nil];
    [sessionManager POST:[NSString stringWithFormat:@"%@/user/set-avatar",Server_url] parameters:@{@"auth_key":[LJKHelper getAuth_key]} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传文件
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        [formData appendPartWithFileData:imageData name:@"avatar_image" fileName:fileName mimeType:@"image/jpg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            [LJKHelper saveUserHeader:[NSString stringWithFormat:@"https://youjar.com%@",[responseObject[@"result"] lastObject]]];
            [self getUserInfo];
        } else {
            [SVProgressHUD showErrorWithStatus:@"上传失败,请重试"];
            [self getUserInfo];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"上传失败,请重试"];
    }];
}

- (IBAction)ForgetPWAction:(id)sender {
    YJRegisterViewController *vc = [[YJRegisterViewController alloc] init];
    vc.isForgetPW = YES;
    PushController(vc);
}
- (IBAction)registerAction:(id)sender {
    YJRegisterViewController *vc = [[YJRegisterViewController alloc] init];
    vc.isForgetPW = NO;
    PushController(vc);
}

- (IBAction)dismissAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.accountTF) {
        UIButton *accountBtn = [self.view viewWithTag:1];
        accountBtn.selected = YES;
    } else if(textField == self.pwTF) {
        UIButton *pwBtn = [self.view viewWithTag:2];
        pwBtn.selected = YES;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.accountTF) {
        UIButton *accountBtn = [self.view viewWithTag:1];
        accountBtn.selected = NO;
    } else if(textField == self.pwTF) {
        UIButton *pwBtn = [self.view viewWithTag:2];
        pwBtn.selected = NO;
    }
}

@end
