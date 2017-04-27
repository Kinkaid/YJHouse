//
//  YJBaseViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/17.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJBaseViewController.h"
@interface YJBaseViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL firstDisplay;

@end

@implementation YJBaseViewController

#pragma mark - Accessor

- (UIView *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 64)];
        _navigationBar.backgroundColor = [UIColor ex_colorFromHexRGB:@"BD00E9"];
        [self.view addSubview:_navigationBar];
        [self.view bringSubviewToFront:_navigationBar];
    }
    return _navigationBar;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        [self.navigationBar addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"white_back_icon"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(clickBackButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:_backButton];
    }
    return _backButton;
}
#pragma mark - Life Cycle
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor ex_colorFromHexRGB:@"A746E8"]];
    self.navigationController.navigationBar.tintColor = [UIColor ex_colorFromHexRGB:@"FFFFFF"];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.hidden = YES;
    [self customNavgationBar];
    self.firstDisplay = YES;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.firstDisplay = NO;
    [SVProgressHUD dismiss];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)customNavgationBar {
    if (self.navigationController.viewControllers.count == 1) {
        self.backButton.hidden = YES;
    } else {
        self.backButton.hidden = NO;
    }
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navigationBar);
        make.centerY.equalTo(self.navigationBar).with.offset(10);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationBar);
        make.top.equalTo(self.navigationBar).with.offset(20);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(44);
    }];
    
}
- (void)isHiddenBackButton:(BOOL)isHidden {
    self.backButton.hidden = isHidden;
}
- (void)setNavigationBarColor:(UIColor *)color {
    self.navigationBar.backgroundColor = color;
}
- (void)clickBackButtonAction {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}
- (void)setTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color {
    self.titleLabel.text = title;
    self.titleLabel.font = font;
    self.titleLabel.textColor = color;
}
- (void)setNavigationBarItem:(UIView *)itemView {
    [self.navigationBar addSubview:itemView];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}



@end
