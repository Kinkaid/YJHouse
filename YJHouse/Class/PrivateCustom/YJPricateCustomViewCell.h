//
//  YJPricateCustomViewCell.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/28.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJPrivateCustomEditDelegate <NSObject>

- (void)privateEditAction:(NSInteger)cellSection;

@end

@interface YJPricateCustomViewCell : UITableViewCell
@property (nonatomic,assign) NSInteger cellSection;
@property (nonatomic,assign) id<YJPrivateCustomEditDelegate>delegate;
- (void)showDataWithDic:(NSDictionary *)dic;
@end
