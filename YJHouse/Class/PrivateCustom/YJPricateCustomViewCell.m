//
//  YJPricateCustomViewCell.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/28.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJPricateCustomViewCell.h"

@implementation YJPricateCustomViewCell {
    
    __weak IBOutlet UIImageView *_icon;
    __weak IBOutlet UILabel *_priceLabel;
    __weak IBOutlet UIView *_bgView;
    
    __weak IBOutlet UILabel *_regionLabel;
    
    __weak IBOutlet UIImageView *_img1;
    
    __weak IBOutlet UIImageView *_img2;
    __weak IBOutlet UIImageView *_img3;
    
    __weak IBOutlet NSLayoutConstraint *_priceLeftConstraints;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showDataWithModel:(YJPrivateModel *)model {
    if (_cellSection>=16) {
        _icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_private_%d",arc4random() % 16]];
    } else {
        _icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_private_%ld",(long)_cellSection]];
    }
    if ([LJKHelper getDevicePlateform] == 4.0) {
        _priceLeftConstraints.constant = 6;
    } else {
        _priceLeftConstraints.constant = 26;
    }
    if (!model.zufang) {
        _priceLabel.text = [NSString stringWithFormat:@"%@-%@万",model.price_min,model.price_max];
    } else {
        _priceLabel.text = [NSString stringWithFormat:@"%@-%@元/月",model.price_min,model.price_max];
    }
    
    if (model.selected) {
        _icon.layer.borderColor = [UIColor ex_colorFromHexRGB:@"39343F"].CGColor;
        _bgView.backgroundColor = [UIColor ex_colorFromHexRGB:@"9829FA"];
        
    } else {
        _icon.layer.borderColor = [UIColor ex_colorFromHexRGB:@"9829FA"].CGColor;
        _bgView.backgroundColor = [UIColor ex_colorFromHexRGB:@"39343F"];
    }
    if ([model.bus_stop_weight intValue] == 5) {
        _img1.image = [UIImage imageNamed:@"icon_transport"];
    } else if ([model.bus_stop_weight intValue] == 4) {
        _img2.image = [UIImage imageNamed:@"icon_transport"];
    } else if ([model.bus_stop_weight intValue] == 3) {
        _img3.image = [UIImage imageNamed:@"icon_transport"];
    }
    
    if ([model.env_weight intValue] == 5) {
        _img1.image = [UIImage imageNamed:@"icon_env"];
    } else if ([model.env_weight intValue] == 4) {
        _img2.image = [UIImage imageNamed:@"icon_env"];
    } else if ([model.env_weight intValue] == 3) {
        _img3.image = [UIImage imageNamed:@"icon_env"];
    }
    if ([model.hospital_weight intValue] == 5) {
        _img1.image = [UIImage imageNamed:@"icon_hospital"];
    } else if ([model.hospital_weight intValue] == 4) {
        _img2.image = [UIImage imageNamed:@"icon_hospital"];
    } else if ([model.hospital_weight intValue] == 3) {
        _img3.image = [UIImage imageNamed:@"icon_hospital"];
    }
    if ([model.shop_weight intValue] == 5) {
        _img1.image = [UIImage imageNamed:@"icon_shop"];
    } else if ([model.shop_weight intValue] == 4) {
        _img2.image = [UIImage imageNamed:@"icon_shop"];
    } else if ([model.shop_weight intValue] == 3) {
        _img3.image = [UIImage imageNamed:@"icon_shop"];
    }
    
    if ([model.school_weight intValue] == 5) {
        _img1.image = [UIImage imageNamed:@"icon_school"];
    } else if ([model.school_weight intValue] == 4) {
        _img2.image = [UIImage imageNamed:@"icon_school"];
    } else if ([model.school_weight intValue] == 3) {
        _img3.image = [UIImage imageNamed:@"icon_school"];
    }
    _regionLabel.text = [NSString stringWithFormat:@"%@ %@",ISEMPTY(model.region1_name)?@"":model.region1_name,ISEMPTY(model.region2_name)?@"":model.region2_name];

}
- (IBAction)editAction:(id)sender {
    [self.delegate privateEditAction:self.cellSection];
}

@end
