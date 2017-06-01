//
//  YJXiaoquDetailModel.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/9.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJXiaoquDetailModel.h"

@implementation YJXiaoquDetailModel
+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"address":@"address",
             @"age":@"age",
             @"area":@"area",
             @"avg_price":@"avg_price",
             @"bus_stop_count":@"bus_stop_count",
             @"date":@"date",
             @"ershou_in":@"ershou_in",
             @"first_time":@"first_time",
             @"green_rate":@"green_rate",
             @"hospital_count":@"hospital_count",
             @"xiaoquId":@"id",
             @"main_img":@"main_img",
             @"name":@"name",
             @"page":@"page",
             @"parking":@"parking",
             @"plate":@"plate",
             @"plate_id":@"plate_id",
             @"plot_ratio":@"plot_ratio",
             @"property_type":@"property_type",
             @"region":@"region",
             @"region_id":@"region_id",
             @"school_count":@"school_count",
             @"score":@"score",
             @"shop_count":@"shop_count",
             @"total_family":@"total_family",
             @"update_time":@"update_time",
             @"volume":@"volume",
             @"zufang_in":@"zufang_in",
             @"good":@"good",
             @"bad":@"bad",
             @"site":@"site"
             };
}

@end
