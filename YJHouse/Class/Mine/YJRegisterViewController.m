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

- (IBAction)confirmAction:(id)sender {
    if (![self.emailTextField.text containsString:@"@"]) {
        [YJApplicationUtil alertHud:@"请输入正确的邮箱地址" afterDelay:1];
        return;
    }
    NSDictionary *params = @{@"email":self.emailTextField.text};
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/signup",Server_url] parameters:params method:POST callBack:^(id responseObject) {
        
        
    } error:^(NSError *error) {
        
    }];
}



@end
