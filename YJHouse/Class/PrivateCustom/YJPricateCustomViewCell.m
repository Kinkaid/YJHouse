//
//  YJPricateCustomViewCell.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/28.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJPricateCustomViewCell.h"

@implementation YJPricateCustomViewCell {
    
    __weak IBOutlet UIView *_bgView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showDataWithDic:(NSDictionary *)dic {
    if ([dic[@"select"] boolValue]) {
        _bgView.backgroundColor = [UIColor ex_colorFromHexRGB:@"9829FA"];
    } else {
        _bgView.backgroundColor = [UIColor ex_colorFromHexRGB:@"39343F"];
    }
 
}
- (IBAction)editAction:(id)sender {
    [self.delegate privateEditAction:self.cellSection];
}

@end
