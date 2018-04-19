//
//  YJThirdStepViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/19.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJThirdStepViewController.h"
#import "TTRangeSlider.h"
#import "YJFourthStepViewController.h"
@interface YJThirdStepViewController ()<TTRangeSliderDelegate>
@property (nonatomic,strong)TTRangeSlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (strong, nonatomic) UILabel *curPrice;

@end

@implementation YJThirdStepViewController

- (UILabel *)curPrice {
    if (!_curPrice) {
        _curPrice = [[UILabel alloc] init];
        [self.view addSubview:_curPrice];
        [_curPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(220);
        }];
        _curPrice.textColor = [UIColor ex_colorFromHexRGB:@"44A7FB"];
        _curPrice.font = [UIFont systemFontOfSize:14];
    }
    return _curPrice;
}
- (TTRangeSlider *)slider {
    if (!_slider) {
        _slider = [[TTRangeSlider alloc] initWithFrame:CGRectMake(16, 249, APP_SCREEN_WIDTH-32, 30)];
        _slider.hideLabels = YES;
        _slider.enableStep = YES;
        _slider.lineHeight = 6;
        _slider.tintColor = [UIColor ex_colorFromHexRGB:@"EDEFF4"];
        _slider.tintColorBetweenHandles = [UIColor ex_colorFromHexRGB:@"3E3E3E"];
        _slider.handleBorderColor = [UIColor ex_colorFromHexRGB:@"3E3E3E"];
        _slider.handleBorderWidth = 8;
        _slider.handleDiameter = 24;
        _slider.selectedHandleDiameterMultiplier = 1.2;
        _slider.handleColor = [UIColor ex_colorFromHexRGB:@"44A7FB"];
        _slider.maxValue = self.registerModel.zufang?10000:600;
        _slider.minValue = 0;
        _slider.selectedMinimum = 0;
        _slider.selectedMaximum  = self.registerModel.zufang?10000:600;
        _slider.delegate = self;
        [self.view addSubview:_slider];
    }
    return _slider;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.slider.step = self.registerModel.zufang?500:10;
    self.navigationBar.hidden = YES;
    if (self.registerModel.zufang) {
        self.unitLabel.text = @"单位:元";
    } else {
        self.unitLabel.text = @"单位:万元";
    }
    if (self.edit) {
        self.slider.selectedMinimum = [self.registerModel.uw_price_min floatValue];
        self.slider.selectedMaximum = [self.registerModel.uw_price_max floatValue]>self.slider.maxValue?self.slider.maxValue:[self.registerModel.uw_price_max floatValue];
        [self updateCurpirce:self.slider.selectedMinimum and:self.slider.selectedMaximum];
    } else {
        self.slider.selectedMinimum = 0;
        self.slider.selectedMaximum  =self.slider.maxValue;
        [self updateCurpirce:0 and:self.slider.maxValue];
    }
}
- (void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum {
    [self updateCurpirce:selectedMinimum and:selectedMaximum];
}
- (void)updateCurpirce:(CGFloat)selectedMinimum and:(CGFloat)selectedMaximum {
    if (selectedMinimum ==0 &&selectedMaximum == self.slider.maxValue) {
        self.curPrice.text = @"不限";
    } else if (selectedMinimum == 0 && selectedMaximum!=self.slider.maxValue) {
        if (self.registerModel.zufang) {
            self.curPrice.text = [NSString stringWithFormat:@"低于%.0f元",selectedMaximum];
        } else {
            self.curPrice.text = [NSString stringWithFormat:@"低于%.0f万",selectedMaximum];
        }
    } else if (selectedMaximum == self.slider.maxValue  &&selectedMinimum != 0 ){
        if (self.registerModel.zufang) {
            self.curPrice.text = [NSString stringWithFormat:@"高于%.0f元",selectedMinimum];
        } else {
            self.curPrice.text = [NSString stringWithFormat:@"高于%.0f万",selectedMinimum];
        }
    } else {
        if (self.registerModel.zufang) {
            self.curPrice.text = [NSString stringWithFormat:@"%.0f元 - %.0f元",selectedMinimum,selectedMaximum];
        } else {
            self.curPrice.text = [NSString stringWithFormat:@"%.0f万 - %.0f万",selectedMinimum,selectedMaximum];
        }
    }
    [self.curPrice mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat centerX = 16+((APP_SCREEN_WIDTH - 32.0) / (self.registerModel.zufang?10000.0:600.0)) *((selectedMinimum + selectedMaximum) / 2.0);
        if (centerX<56) {
            make.centerX.mas_equalTo(56 - APP_SCREEN_WIDTH /2.0);
        } else if (APP_SCREEN_WIDTH - centerX<56){
            make.centerX.mas_equalTo(APP_SCREEN_WIDTH - 56- (APP_SCREEN_WIDTH / 2.0));
        } else {
            make.centerX.mas_equalTo(centerX - (APP_SCREEN_WIDTH / 2.0));
        }
    }];
}
- (IBAction)nextAction:(id)sender {
    if (self.slider.selectedMinimum != self.slider.maxValue && self.slider.selectedMaximum != self.slider.maxValue ) {
        if (self.slider.selectedMinimum == self.slider.selectedMaximum && self.slider.selectedMaximum !=self.slider.maxValue) {
            [YJApplicationUtil alertHud:@"请正确设置价格区间" afterDelay:1];
            return;
        }
    }
    YJFourthStepViewController *vc = [[YJFourthStepViewController alloc] init];
    if (self.slider.selectedMinimum == self.slider.selectedMaximum) {
        self.slider.selectedMaximum = self.slider.selectedMaximum *10;
    }
    self.registerModel.uw_price_min = [NSString stringWithFormat:@"%.0f",self.slider.selectedMinimum];
    self.registerModel.uw_price_max = [NSString stringWithFormat:@"%.0f",self.slider.selectedMaximum==self.slider.maxValue?self.slider.selectedMaximum*10:self.slider.selectedMaximum];
    self.registerModel.uw_price_rank_weight = @"10";
    vc.registerModel = self.registerModel;
    vc.edit = self.edit;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
