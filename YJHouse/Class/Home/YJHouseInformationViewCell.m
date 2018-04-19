//
//  YJHouseInformationViewCell.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/12/11.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJHouseInformationViewCell.h"
#import "UIImage+GIF.h"
@implementation YJHouseInformationViewCell{
    
    __weak IBOutlet UILabel *_title;
    __weak IBOutlet UIImageView *_img;
    __weak IBOutlet UILabel *_date;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showDataWithModel:(ArticleModel *)model {
    _title.text = model.title;
//    _title.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    _title.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:16];
    [_img sd_setImageWithURL:[NSURL URLWithString:model.main_img] placeholderImage:[UIImage imageNamed:@"icon_placeholder2"]];
    _date.text = [LJKHelper dateStringFromNumberTimer:model.time withFormat:@"yyyy-MM-dd"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
