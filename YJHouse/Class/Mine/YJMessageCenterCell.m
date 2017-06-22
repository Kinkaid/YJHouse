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
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)showDataWithTitle:(NSString *)title content:(NSString *)content {
    _title.text = title;
    _content.text = content;
}
- (void)showDataWithModel:(YJMsgModel *)model {
    _title.text = model.title;
    _content.text = model.content;
    if (model.count) {
        self.badgeView.hidden = NO;
    } else {
        self.badgeView.hidden = YES;
    }
}

@end
