//
//  YJNoSearchDataView.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/25.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJNoSearchDataView.h"

@implementation YJNoSearchDataView{
    UILabel *label;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((APP_SCREEN_WIDTH / 3.0) , (APP_SCREEN_HEIGHT - 160 - (APP_SCREEN_WIDTH / 3.0)) / 2.0, (APP_SCREEN_WIDTH / 3.0), (APP_SCREEN_WIDTH / 3.0))];
        img.image = [UIImage imageNamed:@"icon_collection_placeholder"];
        [self addSubview:img];
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, (APP_SCREEN_HEIGHT - 100 - (APP_SCREEN_WIDTH / 3.0)) / 2.0 +(APP_SCREEN_WIDTH / 3.0), APP_SCREEN_WIDTH, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor ex_colorFromHexRGB:@"B3B3B3"];
        label.font = [UIFont systemFontOfSize:16];
        [self addSubview:label];
    }
    return self;
}
- (void)setContent:(NSString *)content {
    label.text = content;
}
@end
