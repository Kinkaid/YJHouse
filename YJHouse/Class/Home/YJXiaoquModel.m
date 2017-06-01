//
//  YJXiaoquModel.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/7.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJXiaoquModel.h"

@implementation YJXiaoquModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"avg_price":@"avg_price",
             @"xqID":@"id",
             @"main_img":@"main_img",
             @"name":@"name",
             @"plate":@"plate",
             @"region":@"region",
             @"score":@"score",
             @"age":@"age",
             @"site":@"site"
             };
}

@end
