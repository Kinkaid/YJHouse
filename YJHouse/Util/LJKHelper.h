//
//  LJKHelper.h
//  Connotation
//
//  Created by LJK on 14-12-20.
//  Copyright (c) 2014年 LJK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface LJKHelper : NSObject
//把一个秒字符串 转化为真正的本地时间
//@"1419055200" -> 转化 日期字符串
+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr;
//根据字符串内容的多少  在固定宽度 下计算出实际的行高
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size;
//获取 当前设备版本
+ (double)getCurrentIOS;

+ (void)saveUserHeader:(NSString *)userHeaderUrl;
+ (NSString *)getUserHeaderUrl;
+ (void)saveUserName:(NSString *)userName;
+ (NSString *)getUserName;
+ (void)saveAuth_key:(NSString *)auth_key;
+ (NSString *)getAuth_key;
+ (void)saveZufangWeight_id:(NSString *)weight_id;
+ (NSString *)getZufangWeight_id;
+ (void)saveErshouWeight_id:(NSString *)weight_id;
+ (NSString *)getErshouWeight_id;
+ (void)saveUserID:(NSString *)userID;
+ (NSString *)getUserID;

+ (CGFloat)getDevicePlateform;

+ (void)saveLastRequestMsgTime:(NSString *)time;
+ (NSString *)getLastRequestMsgTime;

+ (UIImage*)imageFromView:(UIView*)view;

+ (void)saveThirdLoginState;
+ (BOOL)thirdLoginSuccess;


@end





