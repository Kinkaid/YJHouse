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
@property (nonatomic,strong)NSMutableArray *priceSectionAry;
@end

@implementation YJThirdStepViewController

- (TTRangeSlider *)slider {
    if (!_slider) {
        _slider = [[TTRangeSlider alloc] initWithFrame:CGRectMake(10, 249, APP_SCREEN_WIDTH-20, 30)];
        _slider.hideLabels = YES;
        _slider.enableStep = YES;
        _slider.lineHeight = 6;
        _slider.tintColor = [UIColor ex_colorFromHexRGB:@"3E3E3E"];
        _slider.tintColorBetweenHandles = [UIColor ex_colorFromHexRGB:@"3E3E3E"];
        _slider.handleBorderColor = [UIColor ex_colorFromHexRGB:@"3E3E3E"];
        _slider.handleBorderWidth = 8;
        _slider.handleDiameter = 24;
        _slider.selectedHandleDiameterMultiplier = 1.2;
        _slider.handleColor = [UIColor ex_colorFromHexRGB:@"B100FC"];
        _slider.maxValue = 4;
        _slider.minValue = 0;
        _slider.selectedMinimum = 0;
        _slider.selectedMaximum = 3;
        _slider.delegate = self;
        [self.view addSubview:_slider];
    }
    return _slider;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.slider.step = 1;
    self.navigationBar.hidden = YES;
    self.priceSectionAry = [@[] mutableCopy];
    [self.priceSectionAry addObjectsFromArray:@[@"0",@"150",@"300",@"500",@"不限"]];
    for (int i=0; i<_priceSectionAry.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40 , 20)];
        label.text = _priceSectionAry[i];
        if (i==0) {
            label.center = CGPointMake(30, CGRectGetMaxY(self.slider.frame) +30);
        } else if (i == 4) {
            label.center = CGPointMake(APP_SCREEN_WIDTH - 30, CGRectGetMaxY(self.slider.frame) +30);
        } else {
            label.center = CGPointMake(20+((APP_SCREEN_WIDTH - 40) / 4.0 *i), CGRectGetMaxY(self.slider.frame) +30);
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor ex_colorFromHexRGB:@"3E3E3E"];
        label.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:label];
    }
}
- (void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum {
    
    if (selectedMinimum == selectedMaximum) {
        self.slider.selectedMinimum = selectedMaximum - 1;
    }
}
- (IBAction)nextAction:(id)sender {
//    int min = self.slider.selectedMinimum;
//    int max = self.slider.selectedMaximum;
//    [YJApplicationUtil alertHud:[NSString stringWithFormat:@"%@ - %@",self.priceSectionAry[min],self.priceSectionAry[max]] afterDelay:1];
    YJFourthStepViewController *vc = [[YJFourthStepViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
