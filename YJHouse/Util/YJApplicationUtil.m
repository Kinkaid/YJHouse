//
//  YJApplicationUtil.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/18.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJApplicationUtil.h"
#import "MBProgressHUD.h"
@implementation YJApplicationUtil

+(YJApplicationUtil*)sharedInstance{
    static YJApplicationUtil *singleton=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton=[[self alloc]init];
    });
    return singleton;
}


+ (void)alertHud:(NSString *)text afterDelay:(NSTimeInterval)delay {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.label.text = [NSString stringWithFormat:@"%@",text];
    hud.label.numberOfLines = 0;
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:delay];
}

@end
