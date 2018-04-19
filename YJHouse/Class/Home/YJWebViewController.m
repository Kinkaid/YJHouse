//
//  YJWebViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/25.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJWebViewController.h"

@interface YJWebViewController ()<WDWebViewDoPushDelegate>

@end

@implementation YJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.frame = CGRectMake(0, 64, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT-64);
    super.delegate = self;
    self.title = @"房源信息";
    [self openURL:[NSURL URLWithString:self.url]];
}

- (void)webKitDoPush:(NSString *)absoluteString {
    if ([absoluteString isEqualToString:@"https://m.5i5j.com/hz/"]) {
        [YJApplicationUtil alertHud:@"该房源已下架" afterDelay:2];
    }
}
- (void)clickBackButtonAction {
    if ([self.webView canGoBack] == YES) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
