//
//  YJHouseCommentModel.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/8/16.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface YJHouseCommentModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy) NSString *comment;
@property (nonatomic,copy) id commentID;
@property (nonatomic,copy) id time;
@property (nonatomic,copy) NSString *to;
@property (nonatomic,copy) id to_comment_id;
@property (nonatomic,copy) id to_user_id;
@property (nonatomic,copy) id topic_id;
@property (nonatomic,copy) id user_id;
@property (nonatomic,copy) id username;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) id good;
@property (nonatomic,assign) id bad;

@end
