//
//  YJUpdateCell.m
//  YJHouse
//
//  Created by fangkuai on 2018/3/24.
//  Copyright © 2018年 刘金凯. All rights reserved.
//

#import "YJUpdateCell.h"

@implementation YJUpdateCell{
    UILabel *row;
    UILabel *label;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        row = [[UILabel alloc] init];
        [self.contentView addSubview:row];
        [row mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(15);
        }];
        row.textAlignment = NSTextAlignmentRight;
        row.font = [UIFont systemFontOfSize:14];
        label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(row.mas_right);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(6);
            make.bottom.mas_equalTo(0);
        }];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:14];
    }
    return self;
}
- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    label.text = dic[@"content"];
    row.text = [NSString stringWithFormat:@"%@.",dic[@"row"]];
}

@end
