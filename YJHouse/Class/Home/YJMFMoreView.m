//
//  YJMFMoreView.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/17.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJMFMoreView.h"
NSArray *valueAry;
CGFloat btnWidth;
@implementation YJMFMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UIScrollView *scoll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, frame.size.height)];
        scoll.contentSize = CGSizeMake(APP_SCREEN_WIDTH, 480);
        [self addSubview:scoll];
        for (int i=0; i<3; i++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 120 *(i+1), APP_SCREEN_WIDTH - 40, 1)];
            lineView.backgroundColor = [UIColor ex_colorFromHexRGB:@"D8D8D8"];
            [scoll addSubview:lineView];
        }
        btnWidth = (APP_SCREEN_WIDTH - 20 * 2.0 - 12 * 3.0) / 4.0;
        UILabel *fLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 12, 60, 20)];
        fLabel.text = @"朝向";
        fLabel.textColor = [UIColor ex_colorFromHexRGB:@"444B4E"];
        fLabel.font = [UIFont systemFontOfSize:15];
        [scoll addSubview:fLabel];
        NSArray *faceAry = @[@"朝东",@"朝南",@"朝西",@"朝北"];
        for (int i=0; i<faceAry.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(20 + (i % 4 * (12 + btnWidth)), i / 4  * 36 + 50, btnWidth, 22);
            [btn setTitle:faceAry[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"ACABBF"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"BD00E9"] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:11];
            btn.layer.borderWidth = 1;
            btn.tag = i+1;
            btn.layer.borderColor = [UIColor ex_colorFromHexRGB:@"ACABBF"].CGColor;
            [scoll addSubview:btn];
            btn.selected = NO;
            [btn addTarget:self action:@selector(tagSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UILabel *sLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 132, 80, 20)];
        sLabel.text = @"面积（平）";
        sLabel.textColor = [UIColor ex_colorFromHexRGB:@"444B4E"];
        sLabel.font = [UIFont systemFontOfSize:15];
        [scoll addSubview:sLabel];
        NSArray *sAry = @[@"50以下",@"50-70",@"70-90",@"90-120",@"120-140",@"140-160",@"160-200",@"200以上"];
        for (int i=0; i<sAry.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(20 + (i % 4 * (12 + btnWidth)), i / 4  * 36 + 44 + 120, btnWidth, 22);
            [btn setTitle:sAry[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"ACABBF"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"BD00E9"] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:11];
            btn.layer.borderWidth = 1;
            btn.tag = i+5;
            btn.selected = NO;
            btn.layer.borderColor = [UIColor ex_colorFromHexRGB:@"ACABBF"].CGColor;
            [scoll addSubview:btn];
            [btn addTarget:self action:@selector(tagSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UILabel *oLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 252, 80, 20)];
        oLabel.text = @"楼龄";
        oLabel.textColor = [UIColor ex_colorFromHexRGB:@"444B4E"];
        oLabel.font = [UIFont systemFontOfSize:15];
        [scoll addSubview:oLabel];
        NSArray *oAry = @[@"5年以内",@"10年以内",@"15年以内",@"20年以内",@"20年以上"];
        for (int i=0; i<oAry.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(20 + (i % 4 * (12 + btnWidth)), i / 4  * 36 + 44 + 120 *2, btnWidth, 22);
            [btn setTitle:oAry[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"ACABBF"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"BD00E9"] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:11];
            btn.layer.borderWidth = 1;
            btn.tag = i+13;
            btn.selected = NO;
            btn.layer.borderColor = [UIColor ex_colorFromHexRGB:@"ACABBF"].CGColor;
            [scoll addSubview:btn];
            [btn addTarget:self action:@selector(tagSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UILabel *floorLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 372, 80, 20)];
        floorLabel.text = @"楼层";
        floorLabel.textColor = [UIColor ex_colorFromHexRGB:@"444B4E"];
        floorLabel.font = [UIFont systemFontOfSize:15];
        [scoll addSubview:floorLabel];
        NSArray *floorAry = @[@"低楼层",@"中楼层",@"高楼层"];
        for (int i=0; i<floorAry.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(20 + (i % 4 * (12 + btnWidth)), i / 4  * 36 + 44 + 120 *3, btnWidth, 22);
            [btn setTitle:floorAry[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"ACABBF"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"BD00E9"] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:11];
            btn.layer.borderWidth = 1;
            btn.tag = i+18;
            btn.selected = NO;
            btn.layer.borderColor = [UIColor ex_colorFromHexRGB:@"ACABBF"].CGColor;
            [scoll addSubview:btn];
            [btn addTarget:self action:@selector(tagSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = CGRectMake(20, 440, APP_SCREEN_WIDTH - 40, 30);
        [scoll addSubview:confirmBtn];
        [confirmBtn setTitleColor:[UIColor ex_colorFromHexRGB:@"BD00E9"] forState:UIControlStateNormal];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        confirmBtn.layer.cornerRadius = 4;
        confirmBtn.layer.borderColor = [UIColor ex_colorFromHexRGB:@"BD00E9"].CGColor;
        confirmBtn.layer.borderWidth = 1;
        valueAry = [NSArray arrayWithObjects:@"2",@"3",@"5",@"7",@"0-50",@"50-70",@"70-90",@"90-120",@"120-140",@"140-160",@"160-200",@"-200",@"5",@"10",@"15",@"20",@"-20",@"1",@"2",@"3", nil];
    }
    return self;
}
- (void)tagSelectClick:(UIButton *)sender {
    if (sender.tag >=13 && sender.tag <=17) {
        for (int i=13; i<=17; i++) {
            UIButton *btn = [self viewWithTag:i];
            if (btn != sender) {
                btn.selected = NO;
                btn.layer.borderColor = [UIColor ex_colorFromHexRGB:@"ACABBF"].CGColor;
            }
        }
        sender.selected = !sender.selected;
    } else {
        sender.selected = !sender.selected;
    }
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
    for (int i=1; i<=4; i++) {
        UIButton *btn = [self viewWithTag:i];
        if (btn.selected) {
            [para setValue:valueAry[i-1] forKey:[NSString stringWithFormat:@"toward[%d]",a]];
            a++;
        }
    }
    int b = 0;
    for (int i=5; i<=12; i++) {
        UIButton *btn = [self viewWithTag:i];
        if (btn.selected) {
            [para setValue:valueAry[i-1] forKey:[NSString stringWithFormat:@"area[%d]",b]];
            b++;
        }
    }
    for (int i=13; i<=17; i++) {
        UIButton *btn = [self viewWithTag:i];
        if (btn.selected) {
            [para setValue:valueAry[i-1] forKey:[NSString stringWithFormat:@"age[0]"]];
            break;
        }
    }
    int c = 0;
    for (int i=18; i<=20; i++) {
        UIButton *btn = [self viewWithTag:i];
        if (btn.selected) {
            [para setValue:valueAry[i-1] forKey:[NSString stringWithFormat:@"storey[%d]",c]];
            c++;
        }
    }
    [self.delegate mfSortWithParams:para];
}
- (void)initWithMFBtn {
    for (int i=1; i<21; i++) {
        UIButton *btn = [self viewWithTag:i];
        btn.layer.borderColor = [UIColor ex_colorFromHexRGB:@"ACABBF"].CGColor;
        btn.selected = NO;
    }
}
@end
