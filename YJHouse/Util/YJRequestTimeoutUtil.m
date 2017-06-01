//
//  YJRequestTimeoutUtil.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/26.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJRequestTimeoutUtil.h"

@implementation YJRequestTimeoutUtil

+ (YJNetRequestTimeoutView *)shareInstance {
    static dispatch_once_t  onceToken;
    static YJNetRequestTimeoutView * _WDNetRequestTimeoutView;
    dispatch_once(&onceToken, ^{
        _WDNetRequestTimeoutView = [[YJNetRequestTimeoutView alloc] initWithFrame:CGRectMake(0,0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    });
    return _WDNetRequestTimeoutView;
}


+ (void)showRequestErrorView {
    [[[UIApplication sharedApplication].windows lastObject] addSubview:[YJRequestTimeoutUtil shareInstance]];
}
+ (void)hiddenRequestErrorView {
    [[YJRequestTimeoutUtil shareInstance] removeFromSuperview];
}


@end
