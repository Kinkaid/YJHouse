//
//  YJLoginView.m
//  YJHouse
//
//  Created by fangkuai on 2018/1/20.
//  Copyright © 2018年 刘金凯. All rights reserved.
//

#import "YJLoginView.h"

@implementation YJLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 4;
        self.clipsToBounds = YES;
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor ex_colorFromHexRGB:@"1F2D3D"];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"优家选房";
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(30);
            make.height.mas_equalTo(16);
        }];
        UILabel *subTitle = [[UILabel alloc] init];
        subTitle.font = [UIFont systemFontOfSize:14];
        subTitle.textAlignment = NSTextAlignmentCenter;
        subTitle.textColor = [UIColor ex_colorFromHexRGB:@"475669"];
        subTitle.text = @"年轻人都爱用的定制选房app";
        [self addSubview:subTitle];
        [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(16);
        }];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor ex_colorFromHexRGB:@"E0E6ED"];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(subTitle.mas_bottom).offset(30);
            make.bottom.mas_equalTo(-30);
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(1);
        }];
        UIButton *wxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [wxBtn setImage:[UIImage imageNamed:@"icon_QQ"] forState:UIControlStateNormal];
        wxBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:wxBtn];
        [wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(lineView.mas_left);
            make.top.mas_equalTo(lineView.mas_top);
            make.bottom.mas_equalTo(lineView.mas_bottom).offset(-10);
        }];
        [wxBtn addTarget:self action:@selector(wxLoginClick) forControlEvents:UIControlEventTouchUpInside];
        UILabel *wxLabel = [[UILabel alloc] init];
        [wxBtn addSubview:wxLabel];
        wxLabel.text = @"QQ登陆";
        wxLabel.font = [UIFont systemFontOfSize:14];
        wxLabel.textColor = [UIColor ex_colorFromHexRGB:@"475669"];
        [wxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        UIButton *sinaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sinaBtn setImage:[UIImage imageNamed:@"icon_wb"] forState:UIControlStateNormal];
        sinaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:sinaBtn];
        [sinaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lineView.mas_right).offset(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(lineView.mas_top);
            make.bottom.mas_equalTo(lineView.mas_bottom).offset(-10);
        }];
        [sinaBtn addTarget:self action:@selector(sinaLoginClick) forControlEvents:UIControlEventTouchUpInside];
        UILabel *wbLabel = [[UILabel alloc] init];
        [sinaBtn addSubview:wbLabel];
        wbLabel.text = @"微博登陆";
        wbLabel.font = [UIFont systemFontOfSize:14];
        wbLabel.textColor = [UIColor ex_colorFromHexRGB:@"475669"];
        [wbLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
    }
    return self;
}
- (void)wxLoginClick {
    [self.delegate wxLoginAction];
}
- (void)sinaLoginClick {
    [self.delegate sinaLoginAction];
}
@end
