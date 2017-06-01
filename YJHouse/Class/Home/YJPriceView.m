//
//  YJPriceView.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/13.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJPriceView.h"
#import "WDNoCopyTextField.h"
NSArray *zufangAry;
NSArray *maifangAry;
NSArray *xqZufangAry;
NSArray *xqMaifangAry;
WDNoCopyTextField *bTextField;
WDNoCopyTextField *eTextField;
@implementation YJPriceView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor ex_colorFromHexRGB:@"D8D8D8"].CGColor;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 280, APP_SCREEN_WIDTH,APP_SCREEN_HEIGHT - 280)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [tapView addGestureRecognizer:tap];
        [self addSubview:tapView];
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 280)];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        zufangAry = [NSMutableArray arrayWithObjects:@"不限",@"1500以下",@"1500-2500",@"2500-3500",@"3500-4500",@"4500以上", nil];
        maifangAry = [NSMutableArray arrayWithObjects:@"不限",@"100万以下",@"100-150万",@"150-200万",@"200-300万",@"300万以上", nil];
        xqZufangAry = [NSMutableArray arrayWithObjects:@"不限",@"1000以下",@"1000-1500",@"1500-2000",@"2000-2500万",@"2500-3000", nil];
        xqMaifangAry = [NSMutableArray arrayWithObjects:@"不限",@"1万以下",@"1-1.5万",@"1.5-2万",@"2-2.5万",@"2.5-3万", nil];
        for (int i=0; i<7; i++) {
            if (i>0) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40*i, APP_SCREEN_WIDTH, 1)];
                lineView.backgroundColor = [UIColor ex_colorFromHexRGB:@"EDEDED"];
                [contentView addSubview:lineView];
            }
            if (i<6) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(self.frame.size.width / 2.0 - 90, 40 * i +2, 180, 36);
                btn.tag = i+1;
          
                [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"595959"] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateSelected];
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [contentView addSubview:btn];
            }
        }
        bTextField = [[WDNoCopyTextField alloc] initWithFrame:CGRectMake(15, 245, 90, 30)];
        bTextField.keyboardType = UIKeyboardTypeNumberPad;
        bTextField.placeholder = @"最低价格(万)";
        bTextField.borderStyle = UITextBorderStyleRoundedRect;
        bTextField.backgroundColor = [UIColor ex_colorFromHexRGB:@"F6F6F6"];
        bTextField.font = [UIFont systemFontOfSize:12];
        bTextField.textAlignment = NSTextAlignmentCenter;
        [self addSubview:bTextField];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(110, 260, 10, 1)];
        lineView.backgroundColor = [UIColor ex_colorFromHexRGB:@"D8D8D8"];
        [self addSubview:lineView];
        eTextField = [[WDNoCopyTextField alloc] initWithFrame:CGRectMake(125, 245, 90, 30)];
        eTextField.keyboardType = UIKeyboardTypeNumberPad;
        eTextField.placeholder = @"最高价格(万)";
        eTextField.borderStyle = UITextBorderStyleRoundedRect;
        eTextField.backgroundColor = [UIColor ex_colorFromHexRGB:@"F6F6F6"];
        eTextField.font = [UIFont systemFontOfSize:12];
        eTextField.textAlignment = NSTextAlignmentCenter;
        [self addSubview:eTextField];
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = CGRectMake(self.frame.size.width - 75, 245, 60, 30);
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        confirmBtn.layer.cornerRadius = 3;
        confirmBtn.backgroundColor = [UIColor ex_colorFromHexRGB:@"A646E8"];
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirmBtn];
    }
    return self;
}

- (void)tapClick {
    self.hidden = YES;
    [self.delegate hiddenPriceView];
}
- (void)setHouseType:(YJHouseType)houseType {
    switch (houseType) {
        case houseRent:
        {
            for (int i=1; i<7; i++) {
                UIButton *btn = [self viewWithTag:i];
                btn.selected = NO;
                [btn setTitle:[NSString stringWithFormat:@"%@",zufangAry[i-1]] forState:UIControlStateNormal];
            }
            bTextField.placeholder = @"最低价格(元)";
            eTextField.placeholder = @"最高价格(元)";
        }
            break;
        case houseBuy:
        {
            for (int i=1; i<7; i++) {
                UIButton *btn = [self viewWithTag:i];
                btn.selected = NO;
                [btn setTitle:[NSString stringWithFormat:@"%@",maifangAry[i-1]] forState:UIControlStateNormal];
            }
            bTextField.placeholder = @"最低价格(万)";
            eTextField.placeholder = @"最高价格(万)";
        }
            break;
        case xiaoquRent:
        {
            for (int i=1; i<7; i++) {
                UIButton *btn = [self viewWithTag:i];
                btn.selected = NO;
                [btn setTitle:[NSString stringWithFormat:@"%@",xqZufangAry[i-1]] forState:UIControlStateNormal];
            }
            bTextField.placeholder = @"最低价格(元)";
            eTextField.placeholder = @"最高价格(元)";
        }
            break;
        case xiaoquBuy:
        {
            for (int i=1; i<7; i++) {
                UIButton *btn = [self viewWithTag:i];
                btn.selected = NO;
                [btn setTitle:[NSString stringWithFormat:@"%@",xqMaifangAry[i-1]] forState:UIControlStateNormal];
            }
            bTextField.placeholder = @"最低价格(万)";
            eTextField.placeholder = @"最高价格(万)";
        }
            break;
        default:
            break;
    }
}

- (void)btnClick:(UIButton *)sender {
    for (int i=1; i<7; i++) {
        UIButton *btn = [self viewWithTag:i];
        btn.selected = NO;
    }
    sender.selected = YES;
    self.hidden = YES;
    [self.delegate priceSortByTag:sender.tag];
}
- (void)confirmAction:(UIButton *)sender {
    if (!bTextField.text.length || !eTextField.text.length) {
        return;
    } else if([bTextField.text integerValue] >= [eTextField.text integerValue]){
        [YJApplicationUtil alertHud:@"最低价格不能高于最高价格" afterDelay:1];
    } else {
        self.hidden = YES;
        [bTextField resignFirstResponder];
        [eTextField resignFirstResponder];
        for (int i=1; i<7; i++) {
            UIButton *btn = [self viewWithTag:i];
            btn.selected = NO;
        }
        [self.delegate priceSortWithMinPrice:bTextField.text maxPrice:eTextField.text];
    }
}
@end
