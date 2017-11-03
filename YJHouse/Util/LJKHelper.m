//
//  LJKHelper.m
//  Connotation
//
//  Created by LJK on 14-12-20.
//  Copyright (c) 2014年 LJK. All rights reserved.
//

#import "LJKHelper.h"
@implementation LJKHelper
+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr {
    double t = [timerStr doubleValue];
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval time = currentTime - t;
    if (time < 60) {
        return @"刚刚";
    }else if (time < 3600){
        return [NSString stringWithFormat:@"%.0f分钟前",time / 60];
    } else if(time < (3600 * 24)){
        return [NSString stringWithFormat:@"%.0f小时前",time / (3600)];
    } else if (time < (3600 * 24 *2)) {
        return [NSString stringWithFormat:@"昨天"];
    } else if (time < (3600 * 24 *3)) {
        return [NSString stringWithFormat:@"2天前"];
    } else if (time < (3600 * 24 *4)) {
        return [NSString stringWithFormat:@"3天前"];
    } else {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM-dd HH:mm";
        return [df stringFromDate:date];
    }
}
+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr withFormat:(NSString *)format {
    //转化为Double
    double t = [timerStr doubleValue];
    //计算出距离1970的NSDate
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    //转化为 时间格式化字符串
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = format;
    //转化为 时间字符串
    return [df stringFromDate:date];
}
//动态 计算行高
//根据字符串的实际内容的多少 在固定的宽度和字体的大小，动态的计算出实际的高度
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size{
        /*
         第一个参数: 预设空间 宽度固定  高度预设 一个最大值
         第二个参数: 行间距
         第三个参数: 属性字典 可以设置字体大小
         */
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil];
    return rect.size.height;
}

//获取iOS版本号
+ (double)getCurrentIOS {
    return [[[UIDevice currentDevice] systemVersion] doubleValue];
}

+ (void)saveUserHeader:(NSString *)userHeaderUrl {
    [[NSUserDefaults standardUserDefaults] setObject:userHeaderUrl forKey:@"yj_userHeaderUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getUserHeaderUrl {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"yj_userHeaderUrl"];
}

+ (void)saveUserName:(NSString *)userName {
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"yj_username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getUserName {
   return [[NSUserDefaults standardUserDefaults] objectForKey:@"yj_username"];
}
+ (void)saveAuth_key:(NSString *)auth_key {
    [[NSUserDefaults standardUserDefaults] setObject:auth_key forKey:@"yj_auth_key"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getAuth_key {
   return [[NSUserDefaults standardUserDefaults] objectForKey:@"yj_auth_key"];
}

+ (void)saveZufangWeight_id:(NSString *)weight_id {
    [[NSUserDefaults standardUserDefaults] setObject:weight_id forKey:@"yj_zufang_weight_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getZufangWeight_id {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"yj_zufang_weight_id"];
}
+ (void)saveErshouWeight_id:(NSString *)weight_id {
    [[NSUserDefaults standardUserDefaults] setObject:weight_id forKey:@"yj_ershou_weight_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getErshouWeight_id {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"yj_ershou_weight_id"];
}

+ (void)saveUserID:(NSString *)userID {
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"yj_userID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getUserID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"yj_userID"];
}


+ (CGFloat)getDevicePlateform {
    NSInteger width = [UIScreen mainScreen].applicationFrame.size.width;
    if (width == 320) {
        return 4;
    } else if(width == 375){
        return 4.7;
    } else {
        return 5.5;
    }
}
+ (void)saveLastRequestMsgTime:(NSString *)time {
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"lastRequestMsgTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getLastRequestMsgTime {
   return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastRequestMsgTime"];
}

+ (UIImage*)imageFromView:(UIView*)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, view.layer.contentsScale * 3.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (void)saveThirdLoginState {
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"yj_third_login_success"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)thirdLoginSuccess {
    NSString *thridLoginTag = [[NSUserDefaults standardUserDefaults] objectForKey:@"yj_third_login_success"];
    if ([thridLoginTag isEqualToString:@"1"]) {
        return YES;
    } else {
        return NO;
    }
}
@end


