//
//  YJZFMoreView.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/17.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJZFMoreView.h"
NSArray *zfValueAry;
CGFloat btnWidth1;
@implementation YJZFMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, APP_SCREEN_WIDTH,self.frame.size.height - 200)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [tapView addGestureRecognizer:tap];
        [self addSubview:tapView];
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 280)];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 120, APP_SCREEN_WIDTH - 40, 1)];
        lineView.backgroundColor = [UIColor ex_colorFromHexRGB:@"D8D8D8"];
        [contentView addSubview:lineView];
        btnWidth1 = (APP_SCREEN_WIDTH - 20 * 2.0 - 12 * 3.0) / 4.0;
        UILabel *fLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(18, 12, 60, 20)];
        fLabel1.text = @"朝向";
        fLabel1.textColor = [UIColor ex_colorFromHexRGB:@"444B4E"];
        fLabel1.font = [UIFont systemFontOfSize:15];
        [contentView addSubview:fLabel1];
        NSArray *faceAry1 = @[@"朝东",@"朝南",@"朝西",@"朝北",@"南北"];
        for (int i=0; i<faceAry1.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(20 + (i % 4 * (12 + btnWidth1)), i / 4  * 36 + 44, btnWidth1, 22);
            [btn setTitle:faceAry1[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"ACABBF"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"BD00E9"] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:11];
            btn.layer.borderWidth = 1;
            btn.tag = i+1;
            btn.layer.borderColor = [UIColor ex_colorFromHexRGB:@"ACABBF"].CGColor;
            [contentView addSubview:btn];
            btn.selected = NO;
            [btn addTarget:self action:@selector(tagSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UILabel *sLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(18, 132, 80, 20)];
        sLabel1.text = @"面积（平）";
        sLabel1.textColor = [UIColor ex_colorFromHexRGB:@"444B4E"];
        sLabel1.font = [UIFont systemFontOfSize:15];
        [contentView addSubview:sLabel1];
        NSArray *sAry1 = @[@"50以下",@"50-70",@"70-90",@"90-120",@"120-140",@"140-160",@"160-200",@"200以上"];
        for (int i=0; i<sAry1.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(20 + (i % 4 * (12 + btnWidth1)), i / 4  * 36 + 44 + 120, btnWidth1, 22);
            [btn setTitle:sAry1[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"ACABBF"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"BD00E9"] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:11];
            btn.layer.borderWidth = 1;
            btn.tag = i+6;
            btn.selected = NO;
            btn.layer.borderColor = [UIColor ex_colorFromHexRGB:@"ACABBF"].CGColor;
            [contentView addSubview:btn];
            [btn addTarget:self action:@selector(tagSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = CGRectMake(20, 240, APP_SCREEN_WIDTH - 40, 30);
        [contentView addSubview:confirmBtn];
        [confirmBtn setTitleColor:[UIColor ex_colorFromHexRGB:@"BD00E9"] forState:UIControlStateNormal];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        confirmBtn.layer.cornerRadius = 4;
        confirmBtn.layer.borderColor = [UIColor ex_colorFromHexRGB:@"BD00E9"].CGColor;
        confirmBtn.layer.borderWidth = 1;
        zfValueAry = [NSArray arrayWithObjects:@"2",@"3",@"5",@"7",@"21",@"0-50",@"50-70",@"70-90",@"90-120",@"120-140",@"140-160",@"160-200",@"-200", nil];
    }
    return self;
}
- (void)tapClick {
    self.hidden = YES;
}
- (void)tagSelectClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.layer.borderColor = [UIColor ex_colorFromHexRGB:@"BD00E9"].CGColor;
    } else {
        sender.layer.borderColor = [UIColor ex_colorFromHexRGB:@"ACABBF"].CGColor;
    }
}
- (void)confirmAction {
    self.hidden = YES;
    NSMutableDictionary *para = [@{} mutableCopy];
    int a = 0;
    for (int i=1; i<=5; i++) {
        UIButton *btn = [self viewWithTag:i];
        if (btn.selected) {
            [para setValue:zfValueAry[i-1] forKey:[NSString stringWithFormat:@"toward[%d]",a]];
            a++;
        }
    }
    int b = 0;
    for (int i=6; i<=13; i++) {
        UIButton *btn = [self viewWithTag:i];
        if (btn.selected) {
            [para setValue:zfValueAry[i-1] forKey:[NSString stringWithFormat:@"area[%d]",b]];
            b++;
        }
    }
    [self.delegate zfSortWithParams:para];
}
@end
