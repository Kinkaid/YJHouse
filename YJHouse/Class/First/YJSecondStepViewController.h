//
//  YJSecondStepViewController.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/18.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJBaseViewController.h"
#import "YJRegisterModel.h"
@interface YJSecondStepViewController : YJBaseViewController

@property (nonatomic,strong) YJRegisterModel *registerModel;
@property (nonatomic,assign) BOOL edit;
@property (nonatomic,assign) BOOL showBackBtn;

@end
