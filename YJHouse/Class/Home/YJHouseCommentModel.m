//
//  YJHouseCommentModel.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/8/16.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJHouseCommentModel.h"

@implementation YJHouseCommentModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"comment":@"comment",
             @"commentID":@"id",
             @"time":@"time",
             @"to":@"to",
             @"to_comment_id":@"to_comment_id",
             @"to_user_id":@"to_user_id",
             @"topic_id":@"topic_id",
             @"user_id":@"user_id",
             @"username":@"username",
             @"height":@"height",
             @"good":@"good",
             @"bad":@"bad"
             };
}

@end
