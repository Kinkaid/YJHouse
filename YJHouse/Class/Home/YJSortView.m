//
//  YJSortView.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/17.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJSortView.h"
NSArray *houseTypeAry;
NSArray *xiaoquTypeAry;
@implementation YJSortView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor ex_colorFromHexRGB:@"D8D8D8"].CGColor;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, APP_SCREEN_WIDTH,self.frame.size.height - 200)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [tapView addGestureRecognizer:tap];
        [self addSubview:tapView];
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 200)];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        houseTypeAry = @[@"默认排序",@"价格从高到低",@"价格从低到高",@"面积从大到小",@"面积从小到大"];
        xiaoquTypeAry = @[@"默认排序",@"均价从高到低",@"均价从低到高",@"小区年代从远到近",@"小区年代从近到远"];
        for (int i=0; i<5; i++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40*(i+1), APP_SCREEN_WIDTH, 1)];
            lineView.backgroundColor = [UIColor ex_colorFromHexRGB:@"EDEDED"];
            [self addSubview:lineView];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 40 * i +2, self.frame.size.width, 36);
            btn.tag = i+1;
            [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"595959"] forState:UIControlStateNormal];
            [btn setTitleColor:MainColor forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}
- (void)tapClick {
    self.hidden = YES;
    [self.delegate hiddenSortView];
}
- (void)setSortType:(YJSortType)sortType {
    switch (sortType) {
        case houseType:
        {
            for (int i=0; i<5; i++) {
                UIButton *btn = [self viewWithTag:i+1];
                btn.selected = NO;
                [btn setTitle:houseTypeAry[i] forState:UIControlStateNormal];
            }
        }
            break;
        case xiaoquType:
        {
            for (int i=0; i<5; i++) {
                UIButton *btn = [self viewWithTag:i+1];
                btn.selected = NO;
                [btn setTitle:xiaoquTypeAry[i] forState:UIControlStateNormal];
            }
        }
            break;
        default:
            break;
    }
}
- (void)btnClick:(UIButton *)sender  {
    self.hidden = YES;
    for (int i=1; i<6; i++) {
        UIButton *btn = [self viewWithTag:i];
        btn.selected = NO;
    }
    sender.selected = YES;
    [self.delegate sortByTag:sender.tag];
}
- (void)initWithSortBtn {
    for (int i=1; i<6; i++) {
        UIButton *btn = [self viewWithTag:i];
        btn.selected = NO;
    }
}
@end
