//
//  YJHouseDetailViewController.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/25.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJBaseViewController.h"

typedef enum {
    type_zufang,
    type_maifang
} purchaseType;



@interface YJHouseDetailViewController : YJBaseViewController

@property (nonatomic,copy) NSString *site_id;
@property (nonatomic,copy) NSString *house_id;
@property (nonatomic,assign) purchaseType type;

@end
