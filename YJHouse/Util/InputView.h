//
//  InputView.h
//  TableViewDemo
//
//  Created by dudongge on 14-7-21.
//  Copyright (c) 2014年 dudongge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExt.h"
@class InputView;

@protocol InputViewDelegate <NSObject>

@optional

- (void)keyboardWillShow:(InputView *)inputView keyboardHeight:(CGFloat)keyboardHeight animationDuration:(NSTimeInterval)duration animationCurve:(UIViewAnimationCurve)animationCurve;

- (void)keyboardWillHide:(InputView *)inputView keyboardHeight:(CGFloat)keyboardHeight animationDuration:(NSTimeInterval)duration animationCurve:(UIViewAnimationCurve)animationCurve;

//- (void)recordButtonDidClick:(UIButton *)button;

//- (void)addButtonDidClick:(UIButton *)button;

- (void)publishButtonDidClick;

- (void)textViewHeightDidChange:(CGFloat)height;


//- (void)textViewContent:(NSString *)str;



@end

@interface InputView : UIView <UITextViewDelegate>

@property (strong, nonatomic)  UITextView *inputTextView;
@property (strong, nonatomic)  UILabel *label;
@property (strong, nonatomic)  UIButton *sendBtn;
@property (strong, nonatomic)  UIButton *keyBtn;


@property (weak, nonatomic) id<InputViewDelegate> delegate;


@end
