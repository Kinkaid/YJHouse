//
//  YJHouseDetailModel.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/18.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface YJHouseDetailModel : MTLModel<MTLJSONSerializing>
@property (nonatomic,copy) NSNumber *age;
@property (nonatomic,copy) NSNumber *area;
@property (nonatomic,copy) NSNumber *bad;
@property (nonatomic,copy) NSNumber *date;
@property (nonatomic,copy) NSNumber *first_time;
@property (nonatomic,copy) NSNumber *good;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *page;
@property (nonatomic,copy) NSString *plate;
@property (nonatomic,copy) NSString *region;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSNumber *total_price;
@property (nonatomic,copy) NSNumber *total_storey;
@property (nonatomic,copy) NSNumber *tour_count;
@property (nonatomic,copy) NSString *toward;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSNumber *unit_price;
@property (nonatomic,copy) NSNumber *update_time;
@property (nonatomic,copy) NSString *decoration;
@property (nonatomic,strong) NSMutableArray *imgAry;

@end
