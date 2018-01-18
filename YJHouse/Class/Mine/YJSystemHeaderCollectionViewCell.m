//
//  YJSystemHeaderCollectionViewCell.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/19.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJSystemHeaderCollectionViewCell.h"

@implementation YJSystemHeaderCollectionViewCell {

    __weak IBOutlet UIImageView *_headerImg;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showDataWithIndexPath:(NSInteger)cellRow  withSec:(NSInteger)sec {
    _headerImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_header_%ld",cellRow+1]];
    _headerImg.layer.cornerRadius = (APP_SCREEN_WIDTH -100.0) / 8.0;
    if (sec > cellRow) {
        _headerImg.layer.borderWidth = 0;
        _headerImg.layer.borderColor = [UIColor ex_colorFromHexRGB:@"FFFFFF"].CGColor;
    } else {
        if (sec == cellRow) {
            _headerImg.layer.borderWidth = 2;
            _headerImg.layer.borderColor = [UIColor ex_colorFromHexRGB:@"44A7FB"].CGColor;
        } else {
            _headerImg.layer.borderWidth = 0;
            _headerImg.layer.borderColor = [UIColor ex_colorFromHexRGB:@"FFFFFF"].CGColor;
        }
    }
}

@end
