//
//  YJHouseInformationViewCell.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/12/11.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJHouseInformationViewCell.h"

@implementation YJHouseInformationViewCell{
    
    __weak IBOutlet UILabel *_title;
    __weak IBOutlet UIImageView *_img;
    __weak IBOutlet UILabel *_date;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showDataWithDictionary:(NSDictionary *)dic {
    _title.text = dic[@"title"];
    [_img sd_setImageWithURL:[NSURL URLWithString:dic[@"main_img"]]];
    _date.text = [LJKHelper dateStringFromNumberTimer:dic[@"time"] withFormat:@"MM-dd"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
