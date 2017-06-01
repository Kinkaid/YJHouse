//
//  YJRemarkViewController.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/5.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJBaseViewController.h"

typedef void(^returnRemarkBlock)(NSString *content);

@interface YJRemarkViewController : YJBaseViewController

@property (nonatomic,copy) NSString *site;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,strong) returnRemarkBlock contentBlock;

- (void)returnContent:(returnRemarkBlock)block;
@end
