//
//  YJLoginTipsView.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/12/5.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJLoginTipsView.h"

@implementation YJLoginTipsView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4;
        self.clipsToBounds = YES;
        self.frame = CGRectMake(0, 0, 289, 378);
        UIButton *dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(263, 6, 20, 20)];
        dismissBtn.backgroundColor = [UIColor ex_colorFromHexRGB:@"DCD9DA"];
        dismissBtn.userInteractionEnabled = YES;
        dismissBtn.layer.cornerRadius = 10;
        [dismissBtn setTitle:@"X" forState:UIControlStateNormal];
        [self addSubview:dismissBtn];
        [dismissBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(69.5, 33, 150, 166)];
        img.image = [UIImage imageNamed:@"icon_login_tips"];
        [self addSubview:img];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 214, 289, 18)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"登陆后您将可以";
        label.textColor = [UIColor ex_colorFromHexRGB:@"000000"];
        label.font =  [UIFont fontWithName:@"SimHei" size:18];
        [self addSubview:label];
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(39, 246, 210, 55)];
        tipLabel.numberOfLines = 0;
        tipLabel.text = @"1.进行房源评论和交流\n2.提供收藏小区新上与降价房源的提醒";
        tipLabel.textColor = [UIColor ex_colorFromHexRGB:@"1D1D1D"];
        tipLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:tipLabel];
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 330, 145, 48)];
        [cancelBtn setTitle:@"暂不" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        cancelBtn.layer.borderColor = [UIColor ex_colorFromHexRGB:@"E9E9E9"].CGColor;
        cancelBtn.layer.borderWidth = 1;
        [self addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(144, 330, 145, 48)];
        [confirmBtn setTitle:@"去登录" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor ex_colorFromHexRGB:@"FF0045"] forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        confirmBtn.layer.borderColor = [UIColor ex_colorFromHexRGB:@"E9E9E9"].CGColor;
        confirmBtn.layer.borderWidth = 1;
        [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirmBtn];
    }
    return self;
}
-(void)cancelAction {
    [self.delegate cancelLoginTipsAction];
    
}
- (void)confirmAction {
    [self.delegate gotoLoginAction];
}
@end
