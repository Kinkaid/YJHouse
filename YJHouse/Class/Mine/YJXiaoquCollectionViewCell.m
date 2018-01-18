//
//  YJXiaoquCollectionViewCell.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/6/2.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJXiaoquCollectionViewCell.h"
#import "YQFiveStarView.h"
#import "YJDate.h"
@implementation YJXiaoquCollectionViewCell{
    
    __weak IBOutlet YQFiveStarView *_starView;
    
    __weak IBOutlet UIImageView *_img;
    
    __weak IBOutlet UILabel *_name;
    __weak IBOutlet UILabel *_date;
    
    __weak IBOutlet UILabel *_category;
    
    __weak IBOutlet UILabel *_region;
    
    __weak IBOutlet UILabel *_price;
    __weak IBOutlet UILabel *_score;
    
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
    if (!ISEMPTY(model.content)) {
        _content.text =[NSString stringWithFormat:@"  %@", model.content];
        _content.textAlignment = NSTextAlignmentLeft;
    } else {
        _content.text =@"添加备注";
        _content.textAlignment = NSTextAlignmentCenter;
    }
    if ([model.state boolValue]) {
        _xiajiaView.hidden = YES;
    } else {
        _xiajiaView.hidden = NO;
    }
}
@end
