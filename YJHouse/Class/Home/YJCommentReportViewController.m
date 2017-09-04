//
//  YJCommentReportViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/8/31.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJCommentReportViewController.h"

@interface YJCommentReportViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTV;

@end

@implementation YJCommentReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self rightBarButtonItem];
}

- (void)rightBarButtonItem {
    self.commentLabel.text = self.comment;
    [self setTitle:@"举报"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(APP_SCREEN_WIDTH - 60, 20 , 60, 40);
    [self setNavigationBarItem:btn];
    [btn addTarget:self action:@selector(confirmSend:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)confirmSend:(UIButton*)sender {
    NSDictionary *params = @{@"auth_key":[LJKHelper getAuth_key],@"type":@"2",@"id":self.commentID,@"content":[self.commentTV.text hasPrefix:@"详细描述..."] ? @"":self.commentTV.text};
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/report",Server_url] parameters:params method:POST callBack:^(id responseObject) {
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            [YJApplicationUtil alertHud:@"举报成功" afterDelay:1];
            [self.navigationController popViewControllerAnimated:YES];
        }
       
    } error:^(NSError *error) {
        
    }];
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"详细描述..."]) {
        textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (!textView.text.length) {
        textView.text = @"详细描述...";
    }
}

@end
