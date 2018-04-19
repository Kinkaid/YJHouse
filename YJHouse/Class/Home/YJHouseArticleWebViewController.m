//
//  YJHouseArticleWebViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/12/12.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJHouseArticleWebViewController.h"

@interface YJHouseArticleWebViewController ()<UIWebViewDelegate>

@end

@implementation YJHouseArticleWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"文章详情"];
    self.webView.frame = CGRectMake(0, KIsiPhoneX?88:64, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - (KIsiPhoneX?88:64));
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/news/detail",Server_url] parameters:@{@"id":self.articleId} method:GET callBack:^(id responseObject) {
        NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
                                "<head> \n"
                                "<meta charset='utf-8'>"
                                "<meta name='viewport' content='width=device-width,initial-scale=1.0'>"
                                "<style>img{max-width: 100%%;}div{margin-left: 10px;margin-right: 10px;}</style>"
                                "<title>%@</title>"
                                "</head> \n"
                                "<body>"
                                "<div>%@</div>"
                                "</body>"
                                "</html>",responseObject[@"result"][@"title"],
                                responseObject[@"result"][@"content"]];
        [self openHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://www.youjar.com"]];
        [self setTitle:@"文章详情"];
    } error:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
