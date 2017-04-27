//
//  YJXiaoquDetailModel.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/9.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface YJXiaoquDetailModel : MTLModel<MTLJSONSerializing>
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSNumber *age;
@property (nonatomic,copy) NSString *area;
@property (nonatomic,copy) NSNumber *avg_price;
@property (nonatomic,copy) NSNumber *bus_stop_count;
@property (nonatomic,copy) NSNumber *date;
@property (nonatomic,copy) NSNumber *ershou_in;
@property (nonatomic,copy) NSNumber *first_time;
@property (nonatomic,copy) NSNumber *green_rate;
@property (nonatomic,copy) NSNumber *hospital_count;
@property (nonatomic,copy) NSNumber *xiaoquId;
@property (nonatomic,copy) NSString *main_img;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *page;
@property (nonatomic,copy) NSNumber *parking;
@property (nonatomic,copy) NSString *plate;
@property (nonatomic,copy) NSNumber *plate_id;
@property (nonatomic,copy) NSNumber *plot_ratio;
@property (nonatomic,copy) NSString *property_type;
@property (nonatomic,copy) NSString *region;
@property (nonatomic,copy) NSNumber *region_id;
@property (nonatomic,copy) NSNumber *school_count;
@property (nonatomic,copy) NSNumber *score;
@property (nonatomic,copy) NSNumber *shop_count;
@property (nonatomic,copy) NSNumber *total_family;
@property (nonatomic,copy) NSNumber *update_time;
@property (nonatomic,copy) NSNumber *volume;
@property (nonatomic,copy) NSNumber *zufang_in;

@end
