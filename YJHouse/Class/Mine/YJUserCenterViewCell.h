//
//  YJUserCenterViewCell.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/3/6.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJUserCenterViewCell : UITableViewCell

@property (nonatomic,strong) NSIndexPath *indexPath;

- (void)showDataWithDic:(NSDictionary *)dic;
@end
