//
//  YJDate.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/18.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJDate : NSObject
+ (NSString *)parseRemoteDataToString:(id)remoteData withFormatterString:(NSString*)formatter;
+ (NSString *)distanceTimeWithBeforeTime:(NSString *)serviceTime;

+ (BOOL)insideOneHourFromDistanceTime:(NSString *)localCallTime;

@end
