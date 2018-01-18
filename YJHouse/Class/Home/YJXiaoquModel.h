//
//  YJXiaoquModel.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/7.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface YJXiaoquModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy) id avg_price;
@property (nonatomic,copy) id xqID;
@property (nonatomic,copy) id main_img;
@property (nonatomic,copy) id name;
@property (nonatomic,copy) id plate;
@property (nonatomic,copy) id region;
@property (nonatomic,copy) id score;
@property (nonatomic,copy) id age;
@property (nonatomic,copy) id site;
@property (nonatomic,copy) id content;
@property (nonatomic,copy) id state;
@end
