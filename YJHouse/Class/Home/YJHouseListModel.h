//
//  YJHouseListModel.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/10.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface YJHouseListModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy) id area;
@property (nonatomic,copy) id house_id;
@property (nonatomic,copy) NSString *main_img;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *plate;
@property (nonatomic,copy) NSString *plate_id;
@property (nonatomic,copy) NSString *region;
@property (nonatomic,copy) NSString *region_id;
@property (nonatomic,copy) id site;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *topcut;
@property (nonatomic,assign) int difference;
@property (nonatomic,copy) id total_price;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *rent;
@property (nonatomic,copy) id total_score;
@property (nonatomic,copy) NSString *toward;
@property (nonatomic,copy) NSString *decoration;
@property (nonatomic,copy) NSString *tags;
@property (nonatomic,assign) BOOL zufang;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) id state;
@property (nonatomic,copy) id date;
@property (nonatomic,assign) BOOL xq_new;
@property (nonatomic,copy) NSString* time;
@property (nonatomic,assign) BOOL expire;
@end
