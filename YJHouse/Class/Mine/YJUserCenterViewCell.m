//
//  YJUserCenterViewCell.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/3/6.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJUserCenterViewCell.h"

@implementation YJUserCenterViewCell {
  
    __weak IBOutlet UIImageView *_img;
    __weak IBOutlet UILabel *_title;
    
    __weak IBOutlet UIView *_lineView;
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
    _img.image = [UIImage imageNamed:dic[@"img"]];
    _title.text = dic[@"title"];
    if (self.indexPath.section == 0 && self.indexPath.row == 0) {
        _title.textColor = [UIColor ex_colorFromHexRGB:@"333333"];
        if ([LJKHelper getDevicePlateform] == 4.0) {
            _title.font = [UIFont systemFontOfSize:16];
        } else {
            _title.font = [UIFont systemFontOfSize:18];
        }
    } else {
        _title.textColor = [UIColor ex_colorFromHexRGB:@"7D7D7D"];
        if ([LJKHelper getDevicePlateform] == 4.0) {
            _title.font = [UIFont systemFontOfSize:15];
        } else {
            _title.font = [UIFont systemFontOfSize:17];
        }
    }
    if ([dic[@"title"] isEqualToString:@"评分"] || [dic[@"title"] isEqualToString:@"我收藏的小区"]) {
        _lineView.hidden = YES;
    } else {
        _lineView.hidden = NO;
    }
}

@end
