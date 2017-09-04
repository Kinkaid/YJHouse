//
//  YJHouseCommentSectionHeaderView.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/8/16.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJHouseCommentModel.h"

@protocol YJSectionHeaderActionDelegate <NSObject>

- (void)sectionHeaderAction:(NSInteger)section;
- (void)commentLikeAction:(UIButton *)sender section:(NSInteger)section;

@end

@interface YJHouseCommentSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic,weak) id<YJSectionHeaderActionDelegate>delegate;
@property (nonatomic,assign) NSInteger section;
//@property (nonatomic,strong) UIView *lineView;
- (void)showDataWithModel:(YJHouseCommentModel *)model;

@end
