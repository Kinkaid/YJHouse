//
//  YJCollectionSecondHandViewCell.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/5.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJCollectionSecondHandViewCell.h"

@implementation YJCollectionSecondHandViewCell

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

@end
