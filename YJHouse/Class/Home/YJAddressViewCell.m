//
//  YJAddressViewCell.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/12.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJAddressViewCell.h"

@implementation YJAddressViewCell{

    __weak IBOutlet UILabel *_textLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
