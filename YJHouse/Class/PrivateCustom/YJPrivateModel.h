//
//  YJPrivateModel.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/16.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface YJPrivateModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy) id active;
@property (nonatomic,copy) id bus_stop_weight;
@property (nonatomic,copy) id env_weight;
@property (nonatomic,copy) id hospital_weight;
@property (nonatomic,copy) id privateId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) id price_max;
@property (nonatomic,copy) id price_min;
@property (nonatomic,copy) id price_rank_weight;
@property (nonatomic,copy) id prime;
@property (nonatomic,copy) id region1_id;
@property (nonatomic,copy) NSString *region1_name;
@property (nonatomic,copy) id region1_weight;
@property (nonatomic,copy) id region2_id;
@property (nonatomic,copy) NSString *region2_name;
@property (nonatomic,copy) id region2_weight;
@property (nonatomic,copy) id school_weight;
@property (nonatomic,copy) id shop_weight;
@property (nonatomic,copy) id user_id;
@property (nonatomic,assign) BOOL zufang;
@property (nonatomic,assign) BOOL selected;

@end
