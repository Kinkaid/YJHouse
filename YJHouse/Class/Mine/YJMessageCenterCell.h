//
//  YJMessageCenterCell.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/3/9.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJMsgModel.h"
@interface YJMessageCenterCell : UITableViewCell

//- (void)showDataWithTitle:(NSString *)title content:(NSString *)content;
- (void)showDataWithModel:(YJMsgModel *)model;
@end
