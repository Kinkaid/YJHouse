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
    
    __weak IBOutlet UILabel *_category;
    
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
    NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元/平",model.avg_price]];
    [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [model.avg_price isKindOfClass:[NSNumber class]] ? [model.avg_price stringValue].length : [model.avg_price length])];
    _price.attributedText = priceStr;
    
    if (!ISEMPTY(model.score)) {
        _score.text = [NSString stringWithFormat:@"(%@)",model.score];
        _starView.Score = model.score;
    }
    _date.text = [NSString stringWithFormat:@"%@年建成",[YJDate parseRemoteDataToString:model.age withFormatterString:@"yyyy"]];
}
@end
