//
//  YJLoadingView.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/26.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DotDitection)
{
    DotDitectionLeft = -1,
    DotDitectionRight = 1,
};

@interface YJLoadingView : UIView

//移动方向 就两种 左、右
@property (nonatomic,assign) DotDitection direction;
//字体颜色
@property (nonatomic,strong) UIColor *textColor;

@end
