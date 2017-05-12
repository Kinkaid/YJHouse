//
//  YJHouseDetailModel.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/18.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJHouseDetailModel.h"

@implementation YJHouseDetailModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"age":@"age",
             @"area":@"area",
             @"bad":@"bad",
             @"date":@"date",
             @"first_time":@"first_time",
             @"good":@"good",
             @"name":@"name",
             @"page":@"page",
             @"plate":@"plate",
             @"region":@"region",
             @"title":@"title",
             @"total_price":@"total_price",
             @"total_storey":@"total_storey",
             @"tour_count":@"tour_count",
             @"toward":@"toward",
             @"type":@"type",
             @"unit_price":@"unit_price",
             @"update_time":@"update_time",
             @"imgAry":@"imgAry",
             @"decoration":@"decoration",
             @"rent":@"rent",
             @"in_storey":@"in_storey"
             };
}

@end
