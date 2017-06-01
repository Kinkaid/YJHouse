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
    //转化为Double
    double t = [timerStr doubleValue];
    //计算出距离1970的NSDate
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    //转化为 时间格式化字符串
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
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
        NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
        CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil];
        return rect.size.height;
}

//获取iOS版本号
+ (double)getCurrentIOS {
    
    return [[[UIDevice currentDevice] systemVersion] doubleValue];
}

+ (void)saveUserHeader:(NSString *)userHeaderUrl {
    [[NSUserDefaults standardUserDefaults] setObject:userHeaderUrl forKey:@"userHeaderUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getUserHeaderUrl {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userHeaderUrl"];
}

+ (void)saveUserName:(NSString *)userName {
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getUserName {
   return [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
}
+ (void)saveAuth_key:(NSString *)auth_key {
    [[NSUserDefaults standardUserDefaults] setObject:auth_key forKey:@"auth_key"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getAuth_key {
   return [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_key"];
}

+ (void)saveZufangWeight_id:(NSString *)weight_id {
    [[NSUserDefaults standardUserDefaults] setObject:weight_id forKey:@"zufang_weight_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getZufangWeight_id {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"zufang_weight_id"];
}
+ (void)saveErshouWeight_id:(NSString *)weight_id {
    [[NSUserDefaults standardUserDefaults] setObject:weight_id forKey:@"ershou_weight_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getErshouWeight_id {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"ershou_weight_id"];
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
@end


