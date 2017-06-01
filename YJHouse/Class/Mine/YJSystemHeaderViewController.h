//
//  YJSystemHeaderViewController.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/19.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJBaseViewController.h"

typedef void(^headerImgBlock)(UIImage *headerImg);

@interface YJSystemHeaderViewController : YJBaseViewController

@property (nonatomic,strong) headerImgBlock imgBlock;

- (void)returnHeaderImgBlock:(headerImgBlock)block;

@end
