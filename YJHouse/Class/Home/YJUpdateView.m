//
//  YJUpdateView.m
//  YJHouse
//
//  Created by fangkuai on 2018/3/24.
//  Copyright © 2018年 刘金凯. All rights reserved.
//

#import "YJUpdateView.h"
#import "YJUpdateCell.h"
static NSString *cellId = @"YJUpdateCell";
@implementation YJUpdateView{
    UITableView *_tableView;
    UILabel *secTitle;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        UILabel *title = [[UILabel alloc] init];
        title.text = @"发现新版本";
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor blackColor];
        title.font = [UIFont systemFontOfSize:20];
        [self addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(16);
        }];
        secTitle = [[UILabel alloc] init];
        [self addSubview:secTitle];
        secTitle.font = [UIFont systemFontOfSize:14];
        secTitle.textColor = [UIColor blackColor];
        [secTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.top.mas_equalTo(title.mas_bottom).offset(6);
        }];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setTitle:@"更新" forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor ex_colorFromHexRGB:@"f0f0f0"].CGColor;
        btn.layer.borderWidth = 1;
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"2791F2"] forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(updateClick) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(-1);
            make.right.mas_equalTo(1);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.height.mas_equalTo(48);
        }];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 10;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:[YJUpdateCell class] forCellReuseIdentifier:cellId];
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(0);
            make.top.mas_equalTo(secTitle.mas_bottom);
            make.bottom.mas_equalTo(btn.mas_top);
        }];
        
    }
    return self;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YJUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[YJUpdateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.dic = @{@"row":@(indexPath.row+1),@"content":_text[indexPath.row]};
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _text.count;
}
- (void)setText:(NSArray *)text {
    _text = text;
    [_tableView reloadData];
}

- (void)updateClick {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/linkmore/id1241832323?mt=8"]];
    [[UIApplication sharedApplication] openURL:url];
}
- (void)setVersion:(NSString *)version {
    _version = version;
    secTitle.text = [NSString stringWithFormat:@"What's new in Version %@",_version];
}
@end
