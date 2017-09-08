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
    NSString *nickToNick = [[model.comment componentsSeparatedByString:@":"] firstObject];
    if ([nickToNick containsString:@"回复"]) {
        NSArray *ary = [nickToNick componentsSeparatedByString:@"回复"];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"44A7FB"] range:NSMakeRange(0,[ary[0] length])];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"44A7FB"] range:NSMakeRange([ary[0] length]+2,[[ary lastObject] length])];
    } else {
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"44A7FB"] range:NSMakeRange(0,nickToNick.length)];
    }

    _contentLabel.attributedText = attributedStr;
}
@end
