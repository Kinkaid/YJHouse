//
//  YJNickEditViewController.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/27.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJBaseViewController.h"

typedef void(^nickBlock)(NSString *nickName);

@interface YJNickEditViewController : YJBaseViewController

@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,strong) nickBlock nBlock;

- (void)returnNickName:(nickBlock)block;
@end
