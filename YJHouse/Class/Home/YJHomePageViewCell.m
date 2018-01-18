//
//  YJHomePageViewCell.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/20.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJHomePageViewCell.h"

@implementation YJHomePageViewCell {

    __weak IBOutlet UIImageView *_main_img;
    
    __weak IBOutlet UILabel *_name;
    
    __weak IBOutlet UILabel *_price;
    __weak IBOutlet UILabel *_totalPrice;
    __weak IBOutlet UILabel *_score;
    __weak IBOutlet UILabel *_address;
    __weak IBOutlet UIImageView *_img1;
    
    __weak IBOutlet UIImageView *_img2;
    
    __weak IBOutlet UIView *_reducePriceView;
    
    __weak IBOutlet UILabel *_reduceRatioLabel;
    
    __weak IBOutlet UILabel *_oldPrice;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)showDataWithModel:(YJHouseListModel *)model {
    [_main_img sd_setImageWithURL:[NSURL URLWithString:model.main_img] placeholderImage:[UIImage imageNamed:@"icon_placeholder"]];
    _name.text = [NSString stringWithFormat:@"%@ %d平",model.name,[model.area intValue]];
    _score.backgroundColor = [UIColor colorWithHue:(100.0 - [model.total_score floatValue])/360.0 saturation:0.46 brightness:0.91 alpha:1];
    if (model.zufang) {
        _img1.image = [UIImage imageNamed:@"icon_location"];
        _img2.image = [UIImage imageNamed:@"icon_tag"];
        _price.text = [NSString stringWithFormat:@"%@  %@",model.region, model.type];
        _address.text = [NSString stringWithFormat:@"%@  %@",model.toward,ISEMPTY(model.decoration)?@"":model.decoration];

        NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元/月",model.rent]];
        [mStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, model.rent.length)];
        _totalPrice.attributedText = mStr;
    } else {
        _img1.image = [UIImage imageNamed:@"icon_price"];
        _img2.image = [UIImage imageNamed:@"icon_location"];
        _price.text = [NSString stringWithFormat:@"%.0f元/平  %@",[model.total_price floatValue] *10000 / [model.area floatValue],model.type];
        _address.text = [NSString stringWithFormat:@"%@  %@",model.region,model.toward];
        NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@万",model.total_price]];
        [mStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, [model.total_price isKindOfClass:[NSString class]]?[model.total_price length]:[model.total_price stringValue].length)];
        _totalPrice.attributedText = mStr;
    }
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.1f",[model.total_score floatValue] < 0 ?([model.total_score floatValue] / (- 1.0)):([model.total_score floatValue] / 1.0 )]];
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:16] range:NSMakeRange(0, AttributedStr.length-2)];
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:10] range:NSMakeRange(AttributedStr.length-2, 2)];
    _score.attributedText = AttributedStr;
    if (ISEMPTY(model.tags)) {
        for (int i=1; i<5; i++) {
            UILabel *label = [self viewWithTag:i];
            label.hidden = YES;
        }
    } else {
        NSArray *tagsAry = [model.tags componentsSeparatedByString:@";"];
        for (int i=1; i<=4; i++) {
            UILabel *label = [self viewWithTag:i];
            if (i<=tagsAry.count) {
                label.text = [NSString stringWithFormat:@" %@ ",tagsAry[i-1]];
                label.hidden = NO;
            } else {
                label.hidden = YES;
            }
        }
    }
    if (ISEMPTY(model.topcut)) {
        _reducePriceView.hidden = YES;
        _score.hidden = NO;
        _oldPrice.hidden = YES;
    } else {
        _reducePriceView.hidden = NO;
        _oldPrice.hidden = NO;
        _score.hidden = YES;
        if ([model.topcut floatValue] *(-100.0)>=10) {
            _reduceRatioLabel.text = [NSString stringWithFormat:@"%.0f%%",[model.topcut floatValue] * (- 100)];
        } else {
            _reduceRatioLabel.text = [NSString stringWithFormat:@"%.1f%%",[model.topcut floatValue] * (- 100)];
        }
        NSMutableAttributedString *mStr;
        if (model.zufang) {
            mStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.0f元/月",[model.rent floatValue] / (1.0+[model.topcut floatValue])]];
        } else {
            mStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.0f万",[model.total_price floatValue] / (1.0+[model.topcut floatValue])]];
        }

        [mStr setAttributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,mStr.length)];
        _oldPrice.attributedText = mStr;
    }
}
@end
