//
//  YJXiaoquCollectionViewCell.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/6/2.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJXiaoquModel.h"

@protocol YJRemarkActionDelegate <NSObject>

- (void)remarkAction:(NSInteger)cellRow;

@end
@interface YJXiaoquCollectionViewCell : UITableViewCell
@property (nonatomic,assign) NSInteger cellRow;
@property(nonatomic,weak)id<YJRemarkActionDelegate>deleagate;
- (void)showDataWithModel:(YJXiaoquModel *)model;
@end
