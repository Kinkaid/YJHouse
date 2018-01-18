//
//  YJFourthStepPreview.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/24.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJFourthStepPreview.h"

@implementation YJFourthStepPreview

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH / 10.0 - 28, 250, 56, 58)];
        view1.backgroundColor =[UIColor clearColor];
        view1.layer.borderColor = [UIColor whiteColor].CGColor;
        view1.layer.borderWidth = 1;
        [self addSubview:view1];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH / 2.0 - 28, 250, 56, 58)];
        view.backgroundColor =[UIColor clearColor];
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        view.layer.borderWidth = 1;
        [self addSubview:view];
        UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(view1.center.x+ 24, 180, 224, 60)];
        imv.image = [UIImage imageNamed:@"icon_range_pre"];
        [self addSubview:imv];
        UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [clickBtn setTitle:@"我知道了" forState:UIControlStateNormal];
        clickBtn.frame = CGRectMake(APP_SCREEN_WIDTH / 2.0 - 50, 335, 100, 35);
        clickBtn.backgroundColor = [UIColor clearColor];
        [clickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        clickBtn.layer.borderWidth = 1;
        clickBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        clickBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [clickBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clickBtn];
    }
    return self;
}
- (void)click {
    [self removeFromSuperview];
}
@end
