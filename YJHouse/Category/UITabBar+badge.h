//
//  UITabBar+badge.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/9/11.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)

-(void)showBadgeOnItemIndex:(int)index;
-(void)hideBadgeOnItemIndex:(int)index;

@end
