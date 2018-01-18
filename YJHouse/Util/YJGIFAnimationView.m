//
//  YJGIFAnimationView.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/26.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJGIFAnimationView.h"

@implementation YJGIFAnimationView

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1];
        self.backgroundColor = [UIColor ex_colorFromHexRGB:@"D8D8D8"];
        [self buildUI];
    }
    return self;
}
- (void)buildUI {
    UIImageView *gifImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH / 2.0, APP_SCREEN_WIDTH / 2.0 * (401.0 /546.0))];
    gifImg.center = self.center;
    [self addSubview:gifImg];
    gifImg.animationImages = @[[UIImage imageNamed:@"icon_gif_1"],[UIImage imageNamed:@"icon_gif_2"]];
    gifImg.animationDuration = 1;
    gifImg.animationRepeatCount = 0;
    [gifImg startAnimating];
    
}
+ (void)showInView:(UIView*)view frame:(CGRect)frame{
    YJGIFAnimationView *loading = [[YJGIFAnimationView alloc] initWithFrame:frame];
    [view addSubview:loading];
}
+ (void)hideInView:(UIView *)view {
    YJGIFAnimationView *loading = [YJGIFAnimationView getLoadingInView:view];
    if (loading) {
        [UIView animateWithDuration:0.6 animations:^{
            loading.alpha = 0;
        } completion:^(BOOL finished) {
            [loading removeFromSuperview];
        }];
        
    }
}
+ (YJGIFAnimationView *)getLoadingInView:(UIView *)view {
    YJGIFAnimationView *loading = nil;
    for (YJGIFAnimationView *subview in view.subviews) {
        if ([subview isKindOfClass:[YJGIFAnimationView class]]) {
            loading = subview;
        }
    }
    return loading;
}
@end
