//
//  YJXiaoQuViewCell.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/3/20.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJXiaoQuViewCell.h"
#import "YQFiveStarView.h"
#import "YJDate.h"
@implementation YJXiaoQuViewCell{

    __weak IBOutlet YQFiveStarView *_starView;
    
    __weak IBOutlet UIImageView *_img;
    
    __weak IBOutlet UILabel *_name;
    __weak IBOutlet UILabel *_date;
    
    __weak IBOutlet NSLayoutConstraint *_category;
    
    __weak IBOutlet UILabel *_region;
    
    __weak IBOutlet UILabel *_price;
    __weak IBOutlet UILabel *_score;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)showDataWithModel:(YJXiaoquModel *)model {
    [_img sd_setImageWithURL:[NSURL URLWithString:model.main_img] placeholderImage:[UIImage imageNamed:@"icon_placeholder"]];
    _name.text = model.name;
    _region.text = model.region;
    _price.text = [NSString stringWithFormat:@"%@元/平",model.avg_price];
    _score.text = [NSString stringWithFormat:@"(%@)",model.score];
    _starView.Score = model.score;
    _date.text = [NSString stringWithFormat:@"%@年建成",[YJDate parseRemoteDataToString:model.age withFormatterString:@"yyyy"]];
    
    
    
}
@end
