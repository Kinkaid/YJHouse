//
//  YJReportAndFeedbackViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/26.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJReportAndFeedbackViewController.h"
#import "WDLoginViewController.h"
#import "KLCPopup.h"
#import "YJLoginView.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <ShareSDK/ShareSDK.h>
@interface YJReportAndFeedbackViewController ()<UITextViewDelegate,YJLoginViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UITextView *otherReasonTextView;
@property (nonatomic,strong) YJLoginView *loginView;
@property (nonatomic,strong) KLCPopup *klcManager;
@end

@implementation YJReportAndFeedbackViewController

- (YJLoginView *)loginView {
    if (!_loginView) {
        _loginView = [[YJLoginView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH - 80, 220)];
        _loginView.delegate = self;
        _loginView.backgroundColor = [UIColor whiteColor];
    }
    return _loginView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"反馈与举报";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:20], NSFontAttributeName, nil]];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(commitAction)];
    self.navigationItem.rightBarButtonItem = right;
    [self setRightBarButtonItem];
}
- (void)setRightBarButtonItem {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setNavigationBarItem:button];
    [button addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self.navigationBar).with.offset(10);
        make.trailing.equalTo(self.navigationBar).with.offset(-10);
    }];
}
- (void)commitAction {
    if ([LJKHelper thirdLoginSuccess]) {
        NSMutableArray *reasonAry = [@[] mutableCopy];
        for (int i= 1; i<=5; i++) {
            UIButton *button = [self.view viewWithTag:i];
            if (button.selected ==  YES) {
                [reasonAry addObject:button.titleLabel.text];
            }
        }
        if (reasonAry.count == 0 &&ISEMPTY(self.otherReasonTextView.text)) {
            return;
        }
        NSString *reasonStr = @"";
        if (!ISEMPTY(reasonAry)) {
            for (int i=0; i<reasonAry.count; i++) {
                reasonStr = [NSString stringWithFormat:@"%@|%@",reasonStr,reasonAry[i]];
            }
        }
        if (!ISEMPTY(self.otherReasonTextView.text)) {
            reasonStr = [NSString stringWithFormat:@"%@|%@",reasonStr,self.otherReasonTextView.text];
        }
        [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/report",Server_url] parameters:@{@"site":self.siteId,@"type":@"1",@"tid":self.ID,@"content":reasonStr,@"auth_key":[LJKHelper getAuth_key],@"user_id":[LJKHelper getUserID]} method:POST callBack:^(id responseObject) {
            if (!ISEMPTY(responseObject[@"result"])) {
                if ([responseObject[@"result"] isEqualToString:@"success"]) {
                    [YJApplicationUtil alertHud:@"举报成功" afterDelay:1];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        } error:^(NSError *error) {
            
        }];
    } else {
        self.klcManager = [KLCPopup popupWithContentView:self.loginView];
        [self.klcManager show];
    }
}
- (IBAction)selectReasonAction:(id)sender {
    UIButton *btn = sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"FFFFFF"] forState:UIControlStateSelected];
        [btn setBackgroundColor:[UIColor ex_colorFromHexRGB:@"44A7FB"]];
    } else {
        [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"4A4949"] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor ex_colorFromHexRGB:@"F5F5F5"]];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.tipsLabel.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.otherReasonTextView resignFirstResponder];
}
- (void)cancelLoginTipsAction {
    [self.klcManager dismiss:YES];
}

#pragma mark -- YJLoginViewDelegate
- (void)wxLoginAction {
    [self.klcManager dismiss:YES];
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
- (void)sinaLoginAction {
    [self.klcManager dismiss:YES];
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
            [LJKHelper saveUserHeader:[NSString stringWithFormat:@"https://www.youjar.top%@",[responseObject[@"result"] lastObject]]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kEditPrivateCustomNotification" object:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:@"上传失败,请重试"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kEditPrivateCustomNotification" object:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"上传失败,请重试"];
    }];
}
@end
