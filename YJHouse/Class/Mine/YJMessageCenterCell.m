//
//  YJMessageCenterCell.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/3/9.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJMessageCenterCell.h"

@implementation YJMessageCenterCell {

    __weak IBOutlet UILabel *_title;
    __weak IBOutlet UILabel *_content;
    __weak IBOutlet UIView *_lineView;
    __weak IBOutlet UILabel *_badgeLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showDataWithModel:(YJMsgModel *)model {
    _title.text = model.title;
    _content.text = model.content;
    if (model.count) {
        _badgeLabel.hidden = NO;
        _badgeLabel.text = [NSString stringWithFormat:@"%d",model.count];
        
    } else {
        _badgeLabel.hidden = YES;
    }
    if ([_title.text isEqualToString:@"系统消息"]) {
        _lineView.hidden = YES;
    } else {
        _lineView.hidden = NO;
    }
}

@end
