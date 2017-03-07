//
//  YJDate.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/18.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJDate.h"

@implementation YJDate

+ (NSString *)parseRemoteDataToString:(id)remoteData withFormatterString:(NSString*)formatter {
    long long dateTime =[remoteData longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateTime];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:formatter];
    return [f stringFromDate:date];
}
+ (NSString *)distanceTimeWithBeforeTime:(NSString *)serviceTime {
    double beTime = [serviceTime doubleValue];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    double distanceTime = now - beTime;
    NSString * distanceStr;
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    if (distanceTime < 60) {//小于一分钟
        distanceStr = @"刚刚";
    } else if (distanceTime < 60 * 60) {//时间小于一个小时
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
    } else if (distanceTime < 24 * 60 * 60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
        distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
    } else if (distanceTime < 24 * 60 * 60 * 2 && [nowDay integerValue] != [lastDay integerValue]){
        if ([nowDay integerValue] - [lastDay integerValue] == 1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        } else {
            [df setDateFormat:@"yyyy-MM-dd HH:mm"];
            distanceStr = [df stringFromDate:beDate];
        }
        
    } else if (distanceTime < 24 * 60 * 60 * 365) {
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    } else {
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}

+ (BOOL)insideOneHourFromDistanceTime:(NSString *)localCallTime {
    double beTime = [localCallTime doubleValue];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    double distanceTime = now - beTime;
    if (distanceTime < 60 * 60) {
        return YES;
    } else {
        return NO;
    }
}
+ (long)testinsideOneHourFromDistanceTime:(NSString *)localCallTime {
    double beTime = [localCallTime doubleValue];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    double distanceTime = now - beTime;
    if (distanceTime < 60 * 60) {
        return (long) distanceTime / 60;
    } else {
        return 61;
    }
}

@end
