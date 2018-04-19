//
//  YJUpdateView.h
//  YJHouse
//
//  Created by fangkuai on 2018/3/24.
//  Copyright © 2018年 刘金凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJUpdateView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray *text;
@property (nonatomic,copy) NSString *version;
@end
