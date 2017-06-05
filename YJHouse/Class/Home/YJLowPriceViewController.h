//
//  YJLowPriceViewController.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/10.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJBaseViewController.h"
typedef void(^returnHouseOperationType)(void);
@interface YJLowPriceViewController : YJBaseViewController

@property (nonatomic,assign) BOOL isLowPrice;
@property (nonatomic,strong) returnHouseOperationType houseTypeBlock;
@end
