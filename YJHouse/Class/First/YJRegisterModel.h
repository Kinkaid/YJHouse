//
//  YJRegisterModel.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/15.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface YJRegisterModel : MTLModel<MTLJSONSerializing>


@property (nonatomic,assign) BOOL zufang;
@property (nonatomic,assign) BOOL firstEnter;
@property (nonatomic,copy) NSString* uw_active;
@property (nonatomic,copy) NSString* uw_name;
@property (nonatomic,copy) NSString* uw_region1_id;
@property (nonatomic,copy) NSString* uw_region2_id;
@property (nonatomic,copy) NSString* uw_region1_weight;
@property (nonatomic,copy) NSString* uw_region2_weight;
@property (nonatomic,copy) NSString* uw_price_min;
@property (nonatomic,copy) NSString* uw_price_max;
@property (nonatomic,copy) NSString* uw_price_rank_weight;
@property (nonatomic,copy) NSString* uw_bus_stop_weight;
@property (nonatomic,copy) NSString* uw_hospital_weight;
@property (nonatomic,copy) NSString* uw_shop_weight;
@property (nonatomic,copy) NSString* uw_school_weight;
@property (nonatomic,copy) NSString* uw_env_weight;
@property (nonatomic,copy) NSString* uw_prime;
@end
