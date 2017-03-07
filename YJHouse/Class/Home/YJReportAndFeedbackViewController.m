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
}
- (void)commitAction {
    NSMutableArray *reasonAry = [@[] mutableCopy];
    for (int i= 1; i<=5; i++) {
        UIButton *button = [self.view viewWithTag:i];
        if (button.selected ==  YES) {
            [reasonAry addObject:button.titleLabel.text];
        }
    }
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
