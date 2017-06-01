//
//  YJPrivateModel.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/16.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJPrivateModel.h"

@implementation YJPrivateModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"active":@"active",
             @"bus_stop_weight":@"bus_stop_weight",
             @"env_weight":@"env_weight",
             @"hospital_weight":@"hospital_weight",
             @"privateId":@"id",
             @"name":@"name",
             @"price_max":@"price_max",
             @"price_min":@"price_min",
             @"price_rank_weight":@"price_rank_weight",
             @"prime":@"prime",
             @"region1_id":@"region1_id",
             @"region1_weight":@"region1_weight",
             @"region1_name":@"region1_name",
             @"region2_id":@"region2_id",
             @"region2_weight":@"region2_weight",
             @"region2_name":@"region2_name",
             @"school_weight":@"school_weight",
             @"shop_weight":@"shop_weight",
             @"user_id":@"user_id",
             @"zufang":@"zufang",
             @"selected":@"selected"
             };
}

@end
