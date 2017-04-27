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
    
    
    __weak IBOutlet UILabel *_label1;
    
    __weak IBOutlet UILabel *_label2;
    
    __weak IBOutlet UILabel *_label3;
    __weak IBOutlet UILabel *_label4;
    
    
    
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
    if (model.zufang) {
        _price.text = model.type;
        _totalPrice.text = [NSString stringWithFormat:@"%@元/月",model.rent];
    } else {
        _price.text = [NSString stringWithFormat:@"%.0f元/平  %@",[model.total_price floatValue] *10000 / [model.area floatValue],model.type];
        _totalPrice.text = [NSString stringWithFormat:@"%@万",model.total_price];
    }
    _address.text = model.region;
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",[model.total_score floatValue] / 10.0]];
//    [AttributedStr addAttribute:NSFontAttributeName
//                          value:[UIFont systemFontOfSize:10]
//                          range:NSMakeRange(2, 2)];
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:16] range:NSMakeRange(0, 2)];
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:10] range:NSMakeRange(2, 2)];
    _score.attributedText = AttributedStr;
    

}
@end
