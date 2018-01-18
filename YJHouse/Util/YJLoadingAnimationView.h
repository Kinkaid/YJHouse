//
//  YJLoadingAnimationView.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/26.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJLoadingView.h"
@interface YJLoadingAnimationView : UIView

//显示方法
+(void)showInView:(UIView*)view frame:(CGRect)frame;
//隐藏方法
+(void)hideInView:(UIView*)view;

-(void)start;

-(void)stop;

@end
