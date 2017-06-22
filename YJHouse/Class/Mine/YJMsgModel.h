//
//  YJMsgModel.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/6/6.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface YJMsgModel : MTLModel<MTLJSONSerializing>
@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) int count;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) id time;
@property (nonatomic,copy) id type;
@property (nonatomic,copy) id msgId;
@end
