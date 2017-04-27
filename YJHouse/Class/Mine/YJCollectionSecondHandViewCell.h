//
//  YJCollectionSecondHandViewCell.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/5.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJRemarkActionDelegate <NSObject>

- (void)remarkAction:(NSInteger)cellRow;

@end

@interface YJCollectionSecondHandViewCell : UITableViewCell
@property (nonatomic,assign) NSInteger cellRow;
@property(nonatomic,weak)id<YJRemarkActionDelegate>deleagate;

@end
