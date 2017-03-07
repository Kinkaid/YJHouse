//
//  YJUserCenterViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/17.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJUserCenterViewController.h"
#import "YJUserCenterViewCell.h"
#define kcellIdentifier  @"YJUserCenterViewCell"
@interface YJUserCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic,strong) NSMutableArray *titleAry;

@end

@implementation YJUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self registerTableView];
}

- (void)registerTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kcellIdentifier bundle:nil] forCellReuseIdentifier:kcellIdentifier];
    self.headerView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH *0.67);
    [self.tableView setTableHeaderView:self.headerView];
    self.titleAry = [NSMutableArray arrayWithObjects:
       @[@{@"title":@"我的收藏",@"img":@"icon_collection"},
         @{@"title":@"我收藏的租房",@"img":@""},
         @{@"title":@"我收藏的二手房",@"img":@""},
         @{@"title":@"我收藏的小区",@"img":@""}],
       @[@{@"title":@"浏览记录",@"img":@"icon_scanlist"}],
       @[@{@"title":@"关于我们",@"img":@"icon_aboutYJ"},
         @{@"title":@"意见反馈",@"img":@"icon_feedback"},
         @{@"title":@"推荐",@"img":@"icon_recommend"},
         @{@"title":@"评分",@"img":@"icon_score"}],nil];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleAry.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titleAry[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 38;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 0.01;
    }
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJUserCenterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kcellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[YJUserCenterViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kcellIdentifier];
    }
    cell.indexPath = indexPath;
    [cell showDataWithDic:self.titleAry[indexPath.section][indexPath.row]];
    if (indexPath.section == 0 &&indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YJUserCenterViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     
}
@end
