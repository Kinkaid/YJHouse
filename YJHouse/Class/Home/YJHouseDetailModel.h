//
//  YJHouseDetailModel.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/18.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface YJHouseDetailModel : MTLModel<MTLJSONSerializing>
@property (nonatomic,copy) id age;
@property (nonatomic,copy) id area;
@property (nonatomic,copy) id bad;
@property (nonatomic,copy) id date;
@property (nonatomic,copy) id first_time;
@property (nonatomic,copy) id good;
@property (nonatomic,copy) id favourite_count;
@property (nonatomic,copy) id name;
@property (nonatomic,copy) id page;
@property (nonatomic,copy) id plate;
@property (nonatomic,copy) id region;
@property (nonatomic,copy) id title;
@property (nonatomic,copy) id total_price;
@property (nonatomic,copy) id total_storey;
@property (nonatomic,copy) id tour_count;
@property (nonatomic,copy) id toward;
@property (nonatomic,copy) id type;
@property (nonatomic,copy) id unit_price;
@property (nonatomic,copy) id update_time;
@property (nonatomic,copy) id decoration;
@property (nonatomic,copy) id rent;
@property (nonatomic,copy) id in_storey;
@property (nonatomic,copy) NSString * site_name;
@property (nonatomic,strong) NSMutableArray *imgAry;
@property (nonatomic,copy) id stairs_ratio;
@property (nonatomic,copy) id around;
@property (nonatomic,copy) id introduction;
@property (nonatomic,copy) id point;
@property (nonatomic,copy) id manager;
@property (nonatomic,copy) id manager_tel;
@property (nonatomic,copy) id uid;
@property (nonatomic,copy) id tags;
@property (nonatomic,copy) id total_score;
@property (nonatomic,strong) NSArray *addition;
@end
