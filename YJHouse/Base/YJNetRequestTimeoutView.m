//
//  YJNetRequestTimeoutView.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/26.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJNetRequestTimeoutView.h"

@implementation YJNetRequestTimeoutView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *imageview = [[UIImageView alloc] init];
        [self addSubview:imageview];
        imageview.image = [UIImage imageNamed:@"icon_timeout"];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(100);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(200, 200));
        }];
        UILabel *label = [[UILabel alloc] init];
        label.text = @"加载失败,点击刷新重试";
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor ex_colorFromHexRGB:@"5B5858"];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageview.mas_bottom).with.offset(30);
            make.centerX.equalTo(self);
        }];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"重新加载" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.backgroundColor = MainColor;
        btn.layer.cornerRadius = 4;
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).with.offset(25);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(100, 33));
        }];
    }
    return self;
}

- (void)btnClick {
    [self removeFromSuperview];
    [self.delegate requestTimeoutAction];
    
}

@end
