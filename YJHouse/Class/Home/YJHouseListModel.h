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
@property (nonatomic,copy) NSString *main_img;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *plate;
@property (nonatomic,copy) NSNumber *plate_id;
@property (nonatomic,copy) NSString *region;
@property (nonatomic,copy) NSNumber *region_id;
@property (nonatomic,copy) id site;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *topcut;
@property (nonatomic,copy) id total_price;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSNumber *rent;
@property (nonatomic,copy) id total_score;
@property (nonatomic,assign) BOOL zufang;
@end
