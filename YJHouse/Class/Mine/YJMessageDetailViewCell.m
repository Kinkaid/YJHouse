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
        case 0:
        {
          _title.text = @"客服消息";
        }
            break;
        case 1:
        {
          _title.text = @"系统消息";
        }
            break;
        case 2:
        {
          _title.text = @"二手房推荐";
        }
            break;
        case 3:
        {
          _title.text = @"租房推荐";
        }
            break;
        default:
            break;
    }
    _content.text = model.content;
    _time.text = [LJKHelper dateStringFromNumberTimer:model.time];
}

@end
