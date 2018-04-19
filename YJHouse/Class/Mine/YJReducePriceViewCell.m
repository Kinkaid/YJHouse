//
//  YJHomePageViewCell.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/20.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJReducePriceViewCell.h"

@implementation YJReducePriceViewCell {

    __weak IBOutlet UIImageView *_main_img;
    
    __weak IBOutlet UILabel *_name;
    
    __weak IBOutlet UILabel *_price;
    __weak IBOutlet UILabel *_totalPrice;
    __weak IBOutlet UILabel *_score;
    __weak IBOutlet UILabel *_address;
    __weak IBOutlet UIImageView *_img1;
    __weak IBOutlet UIImageView *_img2;
    __weak IBOutlet UIImageView *_lowPImg;
    __weak IBOutlet UILabel *_xqNewLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)showDataWithModels:(YJHouseListModel *)model {
    [_main_img sd_setImageWithURL:[NSURL URLWithString:model.main_img] placeholderImage:[UIImage imageNamed:@"icon_placeholder"]];
    _name.text = [NSString stringWithFormat:@"%@ %d平",model.name,[model.area intValue]];
    _score.backgroundColor = [UIColor colorWithHue:(100.0 - [model.total_score floatValue])/360.0 saturation:0.46 brightness:0.91 alpha:1];
    if (model.zufang) {
        _img1.image = [UIImage imageNamed:@"icon_location"];
        _img2.image = [UIImage imageNamed:@"icon_tag"];
        _price.text = [NSString stringWithFormat:@"%@  %@",model.region, model.type];
        _address.text = [NSString stringWithFormat:@"%@  %@",model.toward,ISEMPTY(model.decoration)?@"":model.decoration];

        
        NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.@元/月",model.rent]];
        [mStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, mStr.length-3)];
        _totalPrice.attributedText = mStr;
    } else {
        _img1.image = [UIImage imageNamed:@"icon_price"];
        _img2.image = [UIImage imageNamed:@"icon_location"];
        _price.text = [NSString stringWithFormat:@"%.0f元/平  %@",[model.total_price floatValue] *10000 / [model.area floatValue],model.type];
        _address.text = [NSString stringWithFormat:@"%@  %@",model.region,model.toward];
        NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@万",model.total_price]];
        [mStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, mStr.length-1)];
        _totalPrice.attributedText = mStr;
    }
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.1f",[model.total_score floatValue] < 0 ?([model.total_score floatValue] / (- 1.0)):([model.total_score floatValue] / 1.0 )]];
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:16] range:NSMakeRange(0, AttributedStr.length-2)];
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:10] range:NSMakeRange(AttributedStr.length-2, 2)];
    _score.attributedText = AttributedStr;
    if (model.xq_new) {
        _lowPImg.hidden = YES;
        _xqNewLabel.hidden = YES;
        _score.hidden = YES;
    } else {
        _score.hidden = NO;
        _lowPImg.hidden = NO;
        _xqNewLabel.hidden = NO;
        if (model.zufang) {
            _xqNewLabel.text = [NSString stringWithFormat:@"比收藏时降价%d元",model.difference];
        } else {
            _xqNewLabel.text = [NSString stringWithFormat:@"比收藏时降价%d万",model.difference];
        }
    }
    
}
@end
