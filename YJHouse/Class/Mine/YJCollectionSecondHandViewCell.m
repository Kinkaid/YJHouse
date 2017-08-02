//
//  YJCollectionSecondHandViewCell.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/5.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJCollectionSecondHandViewCell.h"

@implementation YJCollectionSecondHandViewCell{
    __weak IBOutlet UIImageView *_main_img;
    
    __weak IBOutlet UILabel *_name;
    
    __weak IBOutlet UILabel *_price;
    __weak IBOutlet UILabel *_totalPrice;
    __weak IBOutlet UILabel *_score;
    __weak IBOutlet UILabel *_address;
    __weak IBOutlet UIImageView *_img1;
    
    __weak IBOutlet UIImageView *_img2;
    
    __weak IBOutlet UILabel *_content;
    
    __weak IBOutlet UIView *_xiajiaView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)remarksAction:(id)sender {
    [self.deleagate remarkAction:self.cellRow];
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
        _totalPrice.text = [NSString stringWithFormat:@"%@元/月",model.rent];
    } else {
        _img1.image = [UIImage imageNamed:@"icon_price"];
        _img2.image = [UIImage imageNamed:@"icon_location"];
        _price.text = [NSString stringWithFormat:@"%.0f元/平  %@",[model.total_price floatValue] *10000 / [model.area floatValue],model.type];
        _address.text = [NSString stringWithFormat:@"%@  %@",model.region,model.toward];
        _totalPrice.text = [NSString stringWithFormat:@"%@万",model.total_price];
    }
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",[model.total_score floatValue] < 0 ?([model.total_score floatValue] / (- 10.0)):([model.total_score floatValue] / 10.0 )]];
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
                label.text = [NSString stringWithFormat:@"  %@  ",tagsAry[i-1]];
                label.hidden = NO;
            } else {
                label.hidden = YES;
            }
        }
    }
    if (!ISEMPTY(model.content)) {
        _content.text =[NSString stringWithFormat:@"  %@", model.content];
        _content.textAlignment = NSTextAlignmentLeft;
    } else {
        _content.text =@"添加备注";
        _content.textAlignment = NSTextAlignmentCenter;
    }
    if ([model.state boolValue]) {
        _xiajiaView.hidden = YES;
        _score.hidden = NO;
    } else {
        _xiajiaView.hidden = NO;
        _score.hidden = YES;
    }
}
@end
