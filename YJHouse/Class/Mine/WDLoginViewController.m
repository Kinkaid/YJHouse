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
    self.accountTF.delegate = self;
    self.pwTF.delegate = self;
    self.navigationBar.hidden = YES;
}
- (IBAction)loginByQQ:(id)sender {
    if([QQApiInterface isQQInstalled]){
        [ShareSDK getUserInfo:SSDKPlatformTypeQQ
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             if (state == SSDKResponseStateSuccess) {
                 NSDictionary *params = @{@"type":@"1",@"tuid":user.uid,@"content":@{@"nickname":user.nickname,@"icon":user.icon},@"device_uid":[[[UIDevice currentDevice] identifierForVendor] UUIDString]};
                 [self thirdLogin:params nick:user.nickname icon:user.icon];
             } else {
                 [YJApplicationUtil alertHud:@"QQ授权失败，请重新尝试" afterDelay:1];
             }
         }];
    } else {
        [YJApplicationUtil alertHud:@"请安装QQ客户端授权登录" afterDelay:1];
    }
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
             NSDictionary *params = @{@"type":@"2",@"tuid":user.uid,@"device_uid":[[[UIDevice currentDevice] identifierForVendor] UUIDString]};
             [self thirdLogin:params nick:user.nickname icon:user.icon];
         } else {
             [YJApplicationUtil alertHud:@"微博授权失败，请重新尝试" afterDelay:1];
         }
     }];
}
- (void)thirdLogin:(NSDictionary *)params nick:(NSString *)nick icon:(NSString *)icon {
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/signup",Server_url] parameters:params method:POST callBack:^(id responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"third_login_success"];
        [LJKHelper saveUserName:nick];
        [LJKHelper saveUserHeader:icon];
        [LJKHelper saveAuth_key:responseObject[@"result"][@"user_info"][@"auth_key"]];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } error:^(NSError *error) {
        
    }];
}

- (IBAction)loginAction:(id)sender {
    NSDictionary *params = @{@"email":self.accountTF.text,@"password":self.pwTF.text,@"device_uid":[[[UIDevice currentDevice] identifierForVendor] UUIDString]};
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/signup",Server_url] parameters:params method:POST callBack:^(id responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"third_login_success"];
        [LJKHelper saveUserName:[NSString stringWithFormat:@"yj_%@",responseObject[@"result"][@"user_info"][@"username"]]];
        [LJKHelper saveAuth_key:responseObject[@"result"][@"user_info"][@"auth_key"]];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } error:^(NSError *error) {
        
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
- (NSString*)dataTojsonString:(id)object {
    NSString *jsonString = @"{}";
    NSError *error;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:object
                        options:NSJSONWritingPrettyPrinted error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData
                                           encoding:NSUTF8StringEncoding];
    }
    return jsonString;
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
