//
//  YJHouseCommentCell.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/8/14.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJHouseCommentCell.h"

@implementation YJHouseCommentCell{

    __weak IBOutlet UILabel *_contentLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)showDataWithModel:(YJHouseCommentModel *)model {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:model.comment];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"44A7FB"] range:NSMakeRange(0,[[[model.comment componentsSeparatedByString:@":"] firstObject] length])];
    _contentLabel.attributedText = attributedStr;
}
@end
