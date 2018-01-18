//
//  YJHouseCommentSectionHeaderView.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/8/16.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJHouseCommentSectionHeaderView.h"

@implementation YJHouseCommentSectionHeaderView{
    UIImageView *_headerImg;
    UILabel *_nickLabel;
    UILabel *_dateLabel;
    UILabel *_content;
    UIButton *_favBtn;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        _headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(16, 23, 42, 42)];
        _headerImg.userInteractionEnabled = YES;
        _headerImg.image = [UIImage imageNamed:@"icon_header_8"];
        _headerImg.layer.cornerRadius = 21;
        _headerImg.clipsToBounds = YES;
        [self addSubview:_headerImg];
        _nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 26, 100,13)];
        _nickLabel.font = [UIFont systemFontOfSize:14];
        _nickLabel.textColor = [UIColor ex_colorFromHexRGB:@"303030"];
        _nickLabel.text = @"我是昵称";
        [self addSubview:_nickLabel];
        _favBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _favBtn.frame = CGRectMake(APP_SCREEN_WIDTH - 100, 6, 80, 40);
        [_favBtn setImage:[UIImage imageNamed:@"icon_comment_diszan"] forState:UIControlStateNormal];
        [_favBtn setImage:[UIImage imageNamed:@"icon_comment_zan"] forState:UIControlStateSelected];
        [_favBtn setTitleColor:[UIColor ex_colorFromHexRGB:@"888888"] forState:UIControlStateNormal];
        [_favBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 4, 0)];
        [_favBtn addTarget:self action:@selector(zanAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_favBtn];
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 51, 200, 13)];
        _dateLabel.text = @"时间";
        _dateLabel.textColor = [UIColor ex_colorFromHexRGB:@"868686"];
        _dateLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_dateLabel];
        _content = [[UILabel alloc] init];
        _content.text = @"我是内容";
        _content.textColor = [UIColor ex_colorFromHexRGB:@"666666"];
        _content.font = [UIFont systemFontOfSize:15];
        _content.numberOfLines = 0;
        [self addSubview:_content];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)zanAction:(UIButton *)sender {
    [self.delegate commentLikeAction:sender section:self.section];
}
- (void)tapClick {
    [self.delegate sectionHeaderAction:self.section];
}
- (void)showDataWithModel:(YJHouseCommentModel *)model {
    [_headerImg sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"icon_header_8"]];
    if ([model.eva boolValue]) {
        _favBtn.selected = YES;
    } else {
        _favBtn.selected = NO;
    }
    [_favBtn setTitle:[NSString stringWithFormat:@"%d",[model.good intValue]] forState:UIControlStateNormal];
    _favBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    CGSize size = [[NSString stringWithFormat:@"%d",[model.good intValue]] sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    [_favBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 16 - size.width, 0, 0)];
    _content.frame = CGRectMake(75, 80, APP_SCREEN_WIDTH - 95, model.height);
    _nickLabel.text = model.username;
    _content.text = model.comment;
    _dateLabel.text = [NSString stringWithFormat:@"%@",[LJKHelper dateStringFromNumberTimer:model.time]];
}
@end
