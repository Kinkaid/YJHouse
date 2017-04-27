//
//  YJXiaoquModel.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/7.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface YJXiaoquModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy) NSNumber *avg_price;
@property (nonatomic,copy) NSNumber *xqID;
@property (nonatomic,copy) NSString *main_img;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *plate;
@property (nonatomic,copy) NSString *region;
@property (nonatomic,copy) NSNumber *score;
@property (nonatomic,copy) NSNumber *age;
@end
