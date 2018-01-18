//
//  YJFiveStepViewController.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/2.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJBaseViewController.h"
#import "YJRegisterModel.h"
@interface YJFiveStepViewController : YJBaseViewController
@property (nonatomic,strong) YJRegisterModel *registerModel;
@property (nonatomic,assign) BOOL edit;
@end
