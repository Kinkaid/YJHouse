//
//  YJNoSearchDataView.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/25.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJNoSearchDataView.h"

@implementation YJNoSearchDataView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor ex_colorFromHexRGB:@"E8E8E8"];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((APP_SCREEN_WIDTH - 196) / 2.0, 100, 196, 145)];
        img.image = [UIImage imageNamed:@"icon_noSearchResult"];
        [self addSubview:img];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, APP_SCREEN_WIDTH, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor ex_colorFromHexRGB:@"B3B3B3"];
        label.font = [UIFont systemFontOfSize:22];
        label.text = @"没有任何搜索记录";
        [self addSubview:label];
    }
    return self;
}
@end
