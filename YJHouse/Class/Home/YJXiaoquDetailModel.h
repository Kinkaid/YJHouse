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
@property (nonatomic,copy) id age;
@property (nonatomic,copy) NSString *area;
@property (nonatomic,copy) id avg_price;
@property (nonatomic,copy) id bus_stop_count;
@property (nonatomic,copy) id date;
@property (nonatomic,copy) id ershou_in;
@property (nonatomic,copy) id first_time;
@property (nonatomic,copy) id green_rate;
@property (nonatomic,copy) id hospital_count;
@property (nonatomic,copy) id xiaoquId;
@property (nonatomic,copy) NSString *main_img;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *page;
@property (nonatomic,copy) NSString *good;
@property (nonatomic,copy) NSString *bad;
@property (nonatomic,copy) NSString *favourite_count;
@property (nonatomic,copy) id parking;
@property (nonatomic,copy) NSString *plate;
@property (nonatomic,copy) id plate_id;
@property (nonatomic,copy) id plot_ratio;
@property (nonatomic,copy) NSString *property_type;
@property (nonatomic,copy) NSString *region;
@property (nonatomic,copy) id region_id;
@property (nonatomic,copy) id school_count;
@property (nonatomic,copy) id score;
@property (nonatomic,copy) id shop_count;
@property (nonatomic,copy) id total_family;
@property (nonatomic,copy) id update_time;
@property (nonatomic,copy) id volume;
@property (nonatomic,copy) id zufang_in;
@property (nonatomic,copy) id site;

@end
