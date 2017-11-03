//
//  InputView.m
//  TableViewDemo
//
//  Created by dudongge on 14-7-21.
//  Copyright (c) 2014年 dudongge. All rights reserved.
//



#import "InputView.h"
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define ORINGIN_X(view) view.frame.origin.x
#define ORINGIN_Y(view) view.frame.origin.y
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define VIEW_HEIGHT(view)  view.frame.size.height



@interface InputView ()

@property (nonatomic, assign)float h;

@end

@implementation InputView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization cod
        self.inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(15, 10, frame.size.width-65, frame.size.height-20)];
        self.inputTextView.backgroundColor = [UIColor whiteColor];
        self.inputTextView.layer.cornerRadius = 5;
        self.inputTextView.layer.masksToBounds = YES;
        self.inputTextView.delegate = self;
        self.inputTextView.returnKeyType = UIReturnKeySend;
        self.inputTextView.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.inputTextView];
        self.h = self.inputTextView.frame.size.height;
        self.label = [[UILabel alloc]initWithFrame:self.inputTextView.bounds];
        self.label.text = @"   添加一条评论~";
        self.label.textColor = [UIColor colorWithRed:117/255.0 green:117/255.0 blue:117/255.0 alpha:1];
        self.label.font = [UIFont systemFontOfSize:14];
        [self.inputTextView addSubview:self.label];
        self.sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 45, (self.frame.size.height - 30) / 2, 30, 30)];
        [self.sendBtn setImage:[UIImage imageNamed:@"icon_send"] forState:UIControlStateNormal];
        self.sendBtn.contentMode = UIViewContentModeScaleAspectFit;
        [self.sendBtn addTarget:self action:@selector(clicksendBtn) forControlEvents:UIControlEventTouchUpInside];
        self.sendBtn.adjustsImageWhenHighlighted = NO;
        [self addSubview:self.sendBtn];
        self.sendBtn.layer.cornerRadius = 4;
        self.sendBtn.layer.masksToBounds = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
- (void)clicksendBtn{
    if ([self.delegate respondsToSelector:@selector(publishButtonDidClick)]) {
        [self.delegate publishButtonDidClick];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.label.alpha = 1.0;
}

- (void)keyboardWillShowNotification:(NSNotification *)notification {
    CGRect keyboardEndFrameWindow;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
    
    double keyboardTransitionDuration;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardTransitionDuration];
    UIViewAnimationCurve keyboardTransitionAnimationCurve;
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&keyboardTransitionAnimationCurve];
    // 参数 ：速度  高度，时间
    if ([self.delegate respondsToSelector:@selector(keyboardWillShow:keyboardHeight:animationDuration:animationCurve:)]) {
        [self.delegate keyboardWillShow:self keyboardHeight:keyboardEndFrameWindow.size.height animationDuration:keyboardTransitionDuration animationCurve:keyboardTransitionAnimationCurve];
    }
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    CGRect keyboardEndFrameWindow;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
    double keyboardTransitionDuration;// 获取键盘的速度
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardTransitionDuration];
    UIViewAnimationCurve keyboardTransitionAnimationCurve;
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&keyboardTransitionAnimationCurve];
    if ([self.delegate respondsToSelector:@selector(keyboardWillHide:keyboardHeight:animationDuration:animationCurve:)]) {
        [self.delegate keyboardWillHide:self keyboardHeight:keyboardEndFrameWindow.size.height animationDuration:keyboardTransitionDuration animationCurve:keyboardTransitionAnimationCurve];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length>50) {
        textView.text = [textView.text substringToIndex:50];
        return NO;
    } else {
        if ([text isEqualToString:@"\n"]) {
            if ([self.delegate respondsToSelector:@selector(publishButtonDidClick)]) {
                [self.delegate publishButtonDidClick];
            }
            return YES;
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length!=0) {
        self.label.alpha = 0;
    } else {
        self.label.alpha = 1;
    }
    //计算文本的高度
    CGSize constraintSize = CGSizeMake(self.inputTextView.frame.size.width,MAXFLOAT);
    NSDictionary *attributes = @{NSFontAttributeName:self.inputTextView.font};
    CGRect sizeFrame = [self.inputTextView.text boundingRectWithSize:constraintSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    textView.height = (sizeFrame.size.height<=self.h?self.h:sizeFrame.size.height);
    textView.frame = CGRectMake(self.inputTextView.frame.origin.x, self.inputTextView.frame.origin.y, self.inputTextView.frame.size.width, textView.height);
    //重新调整textView的高度
    if ([self.delegate respondsToSelector:@selector(textViewHeightDidChange:)]) {
        [self.delegate textViewHeightDidChange:textView.height];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
