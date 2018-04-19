//
//  YJNickEditViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/27.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJNickEditViewController.h"

@interface YJNickEditViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nickTextField;

@end

@implementation YJNickEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"编辑昵称"];
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(APP_SCREEN_WIDTH - 60, 24, 60, 40);
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [commitBtn setTitle:@"保存" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [self setNavigationBarItem:commitBtn];
    self.nickTextField.text = self.nickName;
}

- (void)commitAction {
    NSString *regex = @"[A-Za-z0-9\u4e00-\u9fa5]{1,12}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:self.nickTextField.text]) {
        if (![self.nickTextField.text containsString:@"回复"]) {
            [SVProgressHUD show];
            [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/set-username",Server_url] parameters:@{@"username":self.nickTextField.text,@"auth_key":[LJKHelper getAuth_key]} method:POST callBack:^(id responseObject) {
                if (!ISEMPTY(responseObject[@"result"])) {
                    [SVProgressHUD dismiss];
                    self.nBlock(self.nickTextField.text);
                    [LJKHelper saveUserName:self.nickTextField.text];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [SVProgressHUD dismiss];
                    [YJApplicationUtil alertHud:responseObject[@"error"] afterDelay:1];
                }
            } error:^(NSError *error) {
                [SVProgressHUD dismiss];
                [YJApplicationUtil alertHud:@"设置失败，请重新尝试" afterDelay:1];
            }];
        } else {
            [YJApplicationUtil alertHud:@"昵称不能包含【回复】两字" afterDelay:1];
        }
    } else {
        [self.nickTextField resignFirstResponder];
        [YJApplicationUtil alertHud:@"昵称不符合平台规则" afterDelay:1];
    }
}
- (void)returnNickName:(nickBlock)block {
    self.nBlock = block;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.nickTextField resignFirstResponder];
}
/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //不支持系统表情的输入
    if ([[textField textInputMode] primaryLanguage]==nil||[[[textField textInputMode] primaryLanguage]isEqualToString:@"emoji"]) {
        return NO;
    }
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textField positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textField textInRange:selectedRange];
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange =NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location <=12) {
            return YES;
        }else{
            return NO;
        }
    }
    NSString *comcatstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger caninputlen =12 - comcatstr.length;
    if (caninputlen >=0){
        return YES;
    }else{
        NSInteger len = string.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        if (rg.length >0){
            NSString *s =@"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [string canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [string substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }else{
                __block NSInteger idx =0;
                __block NSString  *trimString =@"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                                           options:NSStringEnumerationByComposedCharacterSequences
                                        usingBlock: ^(NSString* substring,NSRange substringRange,NSRange enclosingRange,BOOL* stop) {
                                            if (idx >= rg.length) {
                                                *stop =YES;//取出所需要就break，提高效率
                                                return ;
                                            }
                                            trimString = [trimString stringByAppendingString:substring];
                                            idx++;
                                        }];
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
}
 */
@end
