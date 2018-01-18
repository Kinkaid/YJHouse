//
//  YJFirstStepViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/18.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJFirstStepViewController.h"
#import "YJSecondStepViewController.h"
#import "YJRegisterModel.h"
@interface YJFirstStepViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewZ;
@property (weak, nonatomic) IBOutlet UIView *viewB;

@end

@implementation YJFirstStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewZ.backgroundColor = [[UIColor ex_colorFromHexRGB:@"44A7FB"] colorWithAlphaComponent:0.4];
    self.viewB.backgroundColor = [[UIColor ex_colorFromHexRGB:@"44A7FB"] colorWithAlphaComponent:0.4];
    self.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (IBAction)zAction:(id)sender {
    if (self.viewZ.hidden == YES) {
        self.viewZ.hidden = NO;
        self.viewB.hidden = YES;
    }
}
- (IBAction)mAction:(id)sender {
    if (self.viewB.hidden == YES) {
        self.viewB.hidden = NO;
        self.viewZ.hidden = YES;
    }
}

- (IBAction)nextClick:(id)sender {
    if (self.viewB.hidden == YES && self.viewZ.hidden == YES) {
        [YJApplicationUtil alertHud:@"请点击选择" afterDelay:1];
        return;
    }
    YJSecondStepViewController *vc = [[YJSecondStepViewController alloc] init];
    YJRegisterModel *model = [[YJRegisterModel alloc] init];
    model.firstEnter = self.firstEnter;
    if (self.viewZ.hidden == YES) {
        model.zufang = NO;
    } else {
        model.zufang = YES;
    }
    vc.registerModel = model;
    PushController(vc);
}


@end
