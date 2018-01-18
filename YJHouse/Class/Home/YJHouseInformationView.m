//
//  YJHouseInformationView.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/12/11.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJHouseInformationView.h"
#import "YJHouseInformationViewCell.h"
#import "YJHouseArticleWebViewController.h"
@interface YJHouseInformationView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger curPage;
@property (nonatomic,strong) NSMutableArray *dataAry;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIImageView *mainImg;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@end
static NSString *const kYJHouseInformationViewCell = @"YJHouseInformationViewCell";
@implementation YJHouseInformationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        [self initTableView];
        [self registerRefresh];
        [SVProgressHUD show];
    }
    return self;
}
- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, self.frame.size.height) style:UITableViewStylePlain];
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, (APP_SCREEN_WIDTH - 20) * 0.48 + 60)];
    self.headerView.clipsToBounds = YES;
    [self.tableView setTableHeaderView:self.headerView];
    self.mainImg = [[UIImageView alloc] init];
    self.mainImg.contentMode = UIViewContentModeScaleToFill;
    self.mainImg.image = [UIImage imageNamed:@"icon_homeheader"];
    [self.headerView addSubview:self.mainImg ];
    [self.mainImg  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).with.offset(10);
        make.right.equalTo(self.headerView).with.offset(-10);
        make.top.equalTo(self.headerView);
        make.height.mas_equalTo((APP_SCREEN_WIDTH - 20) * 0.48);
    }];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor ex_colorFromHexRGB:@"262525"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.numberOfLines = 2;
    [self.headerView addSubview:self.titleLabel];
    [self.self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.mainImg.mas_bottom).with.offset(10);
    }];
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.textColor = [UIColor ex_colorFromHexRGB:@"9C9C9C"];
    self.dateLabel.font = [UIFont systemFontOfSize:14];
    [self.headerView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).with.offset(10);
    }];
    UIView *line = [[UIView alloc] init];
    [self.headerView addSubview:line];
    line.backgroundColor = [UIColor ex_colorFromHexRGB:@"F7F7F7"];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.headerView.mas_bottom);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTap)];
    [self.headerView addGestureRecognizer:tap];
    [self.tableView registerNib:[UINib nibWithNibName:kYJHouseInformationViewCell bundle:nil] forCellReuseIdentifier:kYJHouseInformationViewCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.dataAry = [@[] mutableCopy];
    self.curPage = 0;
}
- (void)headerTap {
    if (self.dataAry.count) {
        YJHouseArticleWebViewController *vc = [[YJHouseArticleWebViewController alloc] init];
        vc.articleId = self.dataAry[0][@"id"];
        [[self viewController].navigationController pushViewController:vc animated:YES];
    }
}
- (void)registerRefresh {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.curPage = 0;
        [weakSelf loadTableViewData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.curPage ++;
        [weakSelf loadTableViewData];
    }];
}
- (void)loadTableViewData {
    __weak typeof(self) weakSelf = self;
    NSDictionary *params = @{@"type":@(self.type),@"page":@(self.curPage)};
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/news/list",Server_url] parameters:params method:GET callBack:^(id responseObject) {
        if (weakSelf.curPage == 0) {
            [weakSelf.dataAry removeAllObjects];
            [weakSelf.tableView.mj_header endRefreshing];
            [SVProgressHUD dismiss];
            if (!ISEMPTY(responseObject[@"result"])) {
                [self.mainImg sd_setImageWithURL:[NSURL URLWithString:responseObject[@"result"][0][@"main_img"]] placeholderImage:[UIImage imageNamed:@"icon_homeheader"]];
                self.titleLabel.text = responseObject[@"result"][0][@"title"];
                self.dateLabel.text =  [LJKHelper dateStringFromNumberTimer: responseObject[@"result"][0][@"time"] withFormat:@"MM-dd"];
            }
        }
        NSArray *ary = responseObject[@"result"];
        for (int i = 0; i<ary.count; i++) {
            [weakSelf.dataAry addObject:ary[i]];
        }
        if (ary.count<20) {
            weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        [weakSelf.tableView reloadData];
    } error:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJHouseInformationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYJHouseInformationViewCell forIndexPath:indexPath];
    if (!cell) {
        cell = [[YJHouseInformationViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kYJHouseInformationViewCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showDataWithDictionary:self.dataAry[indexPath.row+1]];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count?(self.dataAry.count-1):0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YJHouseArticleWebViewController *vc = [[YJHouseArticleWebViewController alloc] init];
    vc.articleId = self.dataAry[indexPath.row+1][@"id"];
     [[self viewController].navigationController pushViewController:vc animated:YES];
}
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
