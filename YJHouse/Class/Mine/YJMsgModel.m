//
//  YJMsgModel.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/6/6.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJMsgModel.h"

@implementation YJMsgModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"msgId":@"idd",
             @"count":@"count",
             @"title":@"title",
             @"content":@"content",
             @"time":@"time",
             @"type":@"type"
             };
}


@end
