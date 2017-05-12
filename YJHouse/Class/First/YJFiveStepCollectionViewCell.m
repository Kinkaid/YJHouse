//
//  YJFiveStepCollectionViewCell.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/2.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJFiveStepCollectionViewCell.h"

@implementation YJFiveStepCollectionViewCell {

    __weak IBOutlet UIImageView *_img;
    __weak IBOutlet UILabel *_title;
    __weak IBOutlet UIImageView *_preImg;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)showDataWithTitle:(NSString *)title andImg:(NSString *)img andSelect:(BOOL)select {
    _title.text = title;
    _img.image = [UIImage imageNamed:img];
    if (select) {
        _preImg.hidden = NO;
    } else {
        _preImg.hidden = YES;
    }
}

@end
