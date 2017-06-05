//
//  YJHouseInfoDetailViewCell.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/6/1.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJHouseInfoDetailViewCell.h"

@implementation YJHouseInfoDetailViewCell {

    __weak IBOutlet UILabel *_title;
    __weak IBOutlet UILabel *_content;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)showDataWithDic:(NSDictionary *)dic {
    _title.text = dic[@"title"];
    _content.text = dic[@"content"];
}

@end
