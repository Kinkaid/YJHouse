//
//  ArticleModel.m
//  YJHouse
//
//  Created by fangkuai on 2018/2/5.
//  Copyright © 2018年 刘金凯. All rights reserved.
//

#import "ArticleModel.h"

@implementation ArticleModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"content":@"content",
             @"articleId":@"id",
             @"main_img":@"main_img",
             @"origin":@"origin",
             @"time":@"time",
             @"title":@"title"
             };
}

@end
