//
//  YJCollectionRentViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/21.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJCollectionRentViewController.h"
#import "YJCollectionSecondHandViewCell.h"
#import "YJHouseDetailViewController.h"
#import "YJNoSearchDataView.h"
#import "YJRemarkViewController.h"
#define kCellIdentifier @"YJCollectionSecondHandViewCell"
@interface YJCollectionRentViewController ()<UITableViewDataSource,UITableViewDelegate,YJRequestTimeoutDelegate,YJRemarkActionDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) NSInteger rentPage;
@property (nonatomic,strong) NSMutableArray *rentAry;
@property (nonatomic,strong) YJNoSearchDataView *noSearchResultView;
@end

@implementation YJCollectionRentViewController


- (YJNoSearchDataView *)noSearchResultView {
    if (!_noSearchResultView) {
        _noSearchResultView = [[YJNoSearchDataView alloc] initWithFrame:CGRectMake(0, 64, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 64)];
        [self.view addSubview:_noSearchResultView];
        _noSearchResultView.content = @"亲，暂时没有任何收藏哦";
    }
    return _noSearchResultView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [YJRequestTimeoutUtil shareInstance].delegate = self;
    [YJGIFAnimationView showInView:self.view frame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    [self registerRefresh];
    [self setTitle:@"我收藏的租房"];
    [self registerTableView];
    [self registerRefresh];
    [self loadRentData];
}
- (void)requestTimeoutAction {
    if (self.isVisible) {
        [self loadRentData];
    }
}
- (void)registerRefresh {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.rentPage = 0;
        [self loadRentData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.rentPage ++;
        [self loadRentData];
    }];
}
- (void)registerTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.rentAry = [@[] mutableCopy];
    self.rentPage = 0;
}
- (void)loadRentData {
    __weak typeof(self) weakSelf = self;
    NSDictionary *params = @{@"page":@(self.rentPage),@"limit":@"20",@"type":@"1",@"auth_key":[LJKHelper getAuth_key]};
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/get-favourite",Server_url] parameters:params method:POST callBack:^(id responseObject) {
        if (responseObject) {
            if (weakSelf.rentPage == 0) {
                [YJGIFAnimationView hideInView:self.view];
                if (![responseObject[@"result"] count]) {
                    self.noSearchResultView.hidden = NO;
                }
                [weakSelf.rentAry removeAllObjects];
                [weakSelf.tableView.mj_header endRefreshing];
                [SVProgressHUD dismiss];
            }
            NSArray *ary = responseObject[@"result"];
            for (int i = 0; i<ary.count; i++) {
                YJHouseListModel *model = [MTLJSONAdapter modelOfClass:[YJHouseListModel class] fromJSONDictionary:ary[i][@"info"] error:nil];
                model.zufang = YES;
                model.content = ary[i][@"content"];
                model.state = ary[i][@"state"];
                [weakSelf.rentAry addObject:model];
            }
            if (ary.count<20) {
                weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            [weakSelf.tableView reloadData];
        }
    } error:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.rentAry.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 128;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.0;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"取消关注";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [SVProgressHUD show];
        YJHouseListModel *model = self.rentAry[indexPath.section];
        NSDictionary *params = @{@"auth_key":[LJKHelper getAuth_key],@"site":model.site,@"id":model.house_id};
        [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/cancel-favourite",Server_url] parameters:params method:POST callBack:^(id responseObject) {
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                [self.rentAry removeObjectAtIndex:indexPath.section];
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
            }
        } error:^(NSError *error) {
            
        }];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJCollectionSecondHandViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showDataWithModel:self.rentAry[indexPath.section]];
    cell.deleagate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YJHouseListModel *model = self.rentAry[indexPath.section];
    if (![model.state boolValue]) {
        return;
    }
    YJHouseDetailViewController *vc = [[YJHouseDetailViewController alloc] init];
    vc.site_id =model.site;
    vc.score = model.total_score;
    vc.house_id = model.house_id;
    if (model.zufang) {
        vc.type = type_zufang;
        vc.tags = [model.tags componentsSeparatedByString:@";"];
    } else {
        vc.type = type_maifang;
    }
    PushController(vc);
}
- (void)remarkAction:(NSInteger)cellRow {
    YJHouseListModel *model = self.rentAry[cellRow];
    if (![model.state boolValue]) {
        return;
    }
    YJRemarkViewController *vc = [[YJRemarkViewController alloc] init];
    vc.site = model.site;
    vc.ID = model.house_id;
    vc.content = ISEMPTY(model.content) ? @"" : model.content;
    [vc returnContent:^(NSString *content) {
        model.content = content;
        [self.tableView reloadData];
    }];
    PushController(vc);
}
@end
