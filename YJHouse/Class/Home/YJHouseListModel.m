//
//  YJHouseListModel.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/10.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJHouseListModel.h"

@implementation YJHouseListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"area":@"area",
             @"house_id":@"id",
             @"main_img":@"main_img",
             @"name":@"name",
             @"plate":@"plate",
             @"plate_id":@"plate_id",
             @"region":@"region",
             @"region_id":@"region_id",
             @"site":@"site",
             @"title":@"title",
             @"topcut":@"topcut",
             @"difference":@"difference",
             @"total_price":@"total_price",
             @"type":@"type",
             @"uid":@"uid",
             @"rent":@"rent",
             @"total_score":@"total_score",
             @"toward":@"toward",
             @"zufang":@"zufang",
             @"tags":@"tags",
             @"decoration":@"decoration",
             @"content":@"content",
             @"state":@"state",
             @"date":@"date",
             @"time":@"time"
             };
}

@end
