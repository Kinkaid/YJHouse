//
//  YJReportAndFeedbackViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/26.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJReportAndFeedbackViewController.h"

@interface YJReportAndFeedbackViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UITextView *otherReasonTextView;

@end

@implementation YJReportAndFeedbackViewController

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
    NSMutableString *reasonStr = [@"" mutableCopy];
    if (!ISEMPTY(reasonAry)) {
        for (int i=0; i<reasonAry.count; i++) {
            [reasonStr stringByAppendingString:reasonAry[i]];
        }
    }
    if (!ISEMPTY(self.otherReasonTextView.text)) {
        [reasonStr stringByAppendingString:self.otherReasonTextView.text];
    }
    [[NetworkTool sharedTool] requestWithURLString:@"https://ksir.tech/you/frontend/web/app/user/report" parameters:@{@"site":self.site,@"id":self.ID,@"content":reasonStr,@"auth_key":[LJKHelper getAuth_key]} method:POST callBack:^(id responseObject) {
        if (!ISEMPTY(responseObject[@"result"])) {
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                [YJApplicationUtil alertHud:@"举报成功" afterDelay:1];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } error:^(NSError *error) {
        
    }];
    
}
- (IBAction)selectReasonAction:(id)sender {
    UIButton *btn = sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"FFFFFF"] forState:UIControlStateSelected];
        [btn setBackgroundColor:[UIColor ex_colorFromHexRGB:@"A746E8"]];
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
@end
