//
//  YJRegisterModel.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/15.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJRegisterModel.h"

@implementation YJRegisterModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"firstEnter":@"firstEnter",
             @"uw_active":@"uw_active",
             @"uw_name":@"uw_name",
             @"uw_region1_id":@"uw_region1_id",
             @"uw_region2_id":@"uw_region2_id",
             @"uw_region1_weight":@"uw_region1_weight",
             @"uw_region2_weight":@"uw_region2_weight",
             @"uw_price_min":@"uw_price_min",
             @"uw_price_max":@"uw_price_max",
             @"uw_price_rank_weight":@"uw_price_rank_weight",
             @"uw_bus_stop_weight":@"uw_bus_stop_weight",
             @"uw_hospital_weight":@"uw_hospital_weight",
             @"uw_shop_weight":@"uw_shop_weight",
             @"uw_school_weight":@"uw_school_weight",
             @"uw_env_weight":@"uw_env_weight",
             @"uw_prime":@"uw_prime"
             };
}

@end
