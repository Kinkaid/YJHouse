//
//  YJMessageDetailViewCell.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/22.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJMessageDetailViewCell.h"

@implementation YJMessageDetailViewCell {

    __weak IBOutlet UILabel *_title;
    __weak IBOutlet UILabel *_content;
    __weak IBOutlet UILabel *_time;
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
    switch ([model.type intValue]) {
        case 1:
        {
            _title.text = @"系统消息";
        }
            break;
        case 4:
        {
            _title.text = @"用户举报";
        }
            break;
        case 5:
        {
            _title.text = @"用户反馈";
        }
            break;
        case 8:
        {
            _title.text = @"评论回复";
        }
            break;
        default:
            break;
    }
    _content.text = model.content;
    _time.text = [LJKHelper dateStringFromNumberTimer:model.time];
}

@end
