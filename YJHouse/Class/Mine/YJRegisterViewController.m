//
//  YJRegisterViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/7/29.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJRegisterViewController.h"

@interface YJRegisterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tips;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;


@end

@implementation YJRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isForgetPW) {
        self.tips.text = @"请填写邮箱进行找回密码";
        [self setTitle:@"忘记密码"];
    } else {
        [self setTitle:@"注册账号"];
    }
}
- (void)clickBackButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)confirmAction:(id)sender {
    if (![self.emailTextField.text containsString:@"@"]) {
        [YJApplicationUtil alertHud:@"请输入正确的邮箱地址" afterDelay:1];
        return;
    }
    [SVProgressHUD show];
    NSDictionary *params = @{@"email":self.emailTextField.text,@"device_uid":[[[UIDevice currentDevice] identifierForVendor] UUIDString]};
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/signup",Server_url] parameters:params method:POST callBack:^(id responseObject) {
        if (!ISEMPTY(responseObject[@"result"])) {
            if ([responseObject[@"result"] isKindOfClass:[NSArray class]]) {
                [YJApplicationUtil alertHud:responseObject[@"result"][0] afterDelay:1];
            } else if ([responseObject[@"result"] isKindOfClass:[NSString class]]) {
                [YJApplicationUtil alertHud:responseObject[@"result"] afterDelay:1];
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [YJApplicationUtil alertHud:responseObject[@"error"] afterDelay:1];
        }
        [SVProgressHUD dismiss];
    } error:^(NSError *error) {
        [YJApplicationUtil alertHud:@"请输入正确的邮箱" afterDelay:1];
        [SVProgressHUD dismiss];
    }];
}
@end
