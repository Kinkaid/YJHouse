//
//  YJFeedbackViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/5.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJFeedbackViewController.h"

@interface YJFeedbackViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (nonatomic,assign) NSInteger lastSelectBtnTag;
@end

@implementation YJFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setNavigationBarItem:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navigationBar).with.offset(10);
        make.trailing.equalTo(self.navigationBar).with.offset(-15);
    }];
    [self initWithBtn];
    [self setTitle:@"意见反馈"];
}
- (void)saveAction:(UIButton *)sender {
    if (!self.feedbackTextView.text.length) {
        [YJApplicationUtil alertHud:@"请输入意见反馈信息" afterDelay:1];
        return;
    }
    [[NetworkTool sharedTool] requestWithURLString:@"https://youjar.com/you/frontend/web/app/user/feedback" parameters:@{@"content":self.feedbackTextView.text,@"type":@(self.lastSelectBtnTag),@"auth_key":[LJKHelper getAuth_key]} method:POST callBack:^(id responseObject) {
        if (!ISEMPTY(responseObject[@"result"])) {
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                [YJApplicationUtil alertHud:@"意见反馈成功" afterDelay:1];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } error:^(NSError *error) {
        
    }];
}
- (void)initWithBtn {
    for (int i=1; i<=4; i++) {
        UIButton *btn = [self.view viewWithTag:i];
        if (i==1) {
            btn.selected = YES;
            self.lastSelectBtnTag = 1;
        }
        [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"4C4B4B"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_solid_circle"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"icon_hollow_circle"] forState:UIControlStateNormal];
    }
}
- (IBAction)selectCategoryAction:(id)sender {
    UIButton *selectBtn = sender;
    selectBtn.selected = YES;
    UIButton *lastBtn = [self.view viewWithTag:self.lastSelectBtnTag];
    lastBtn.selected = NO;
    self.lastSelectBtnTag = selectBtn.tag;
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    if (existTextNum >100){
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:100];
        [textView setText:s];
    }
}
#pragma mark -限制输入字数(最多不超过300个字)
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //不支持系统表情的输入
    if ([[textView textInputMode] primaryLanguage]==nil||[[[textView textInputMode] primaryLanguage]isEqualToString:@"emoji"]) {
        return NO;
    }
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange =NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location <100) {
            return YES;
        }else{
            return NO;
        }
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen =100 - comcatstr.length;
    if (caninputlen >=0){
        return YES;
    }else{
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        if (rg.length >0){
            NSString *s =@"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }else{
                __block NSInteger idx =0;
                __block NSString  *trimString =@"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
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
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
}


@end
