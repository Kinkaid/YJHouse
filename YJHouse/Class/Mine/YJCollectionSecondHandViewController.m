//
//  YJCollectionSecondHandViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/5.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJCollectionSecondHandViewController.h"
#import "YJCollectionSecondHandViewCell.h"
#import "YJRemarkViewController.h"
#import "YJHouseListModel.h"
#import "YJNoSearchDataView.h"
#import "YJHouseDetailViewController.h"
#define kSecondHandCellIdentifier @"YJCollectionSecondHandViewCell"
@interface YJCollectionSecondHandViewController ()<UITableViewDelegate,UITableViewDataSource,YJRemarkActionDelegate,YJRequestTimeoutDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) NSInteger secondPage;
@property (nonatomic,strong) NSMutableArray *secondAry;
@property (nonatomic,strong) YJNoSearchDataView *noSearchResultView;
@end

@implementation YJCollectionSecondHandViewController


- (YJNoSearchDataView *)noSearchResultView {
    if (!_noSearchResultView) {
        _noSearchResultView = [[YJNoSearchDataView alloc] initWithFrame:CGRectMake(0, 64, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 64)];
        [self.view addSubview:_noSearchResultView];
        _noSearchResultView.content = @"暂无收藏二手房";
    }
    return _noSearchResultView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [YJRequestTimeoutUtil shareInstance].delegate = self;
    [YJGIFAnimationView showInView:self.view frame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    [self setTitle:@"我收藏的二手房"];
    [self registerTableView];
    [self registerRefresh];
    [self loadSecondData];
}
- (void)requestTimeoutAction {
    if (self.isVisible) {
        [self loadSecondData];
    }
}
- (void)registerTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kSecondHandCellIdentifier bundle:nil] forCellReuseIdentifier:kSecondHandCellIdentifier];
    self.secondPage = 0;
    self.secondAry = [@[] mutableCopy];
}
- (void)registerRefresh {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.secondPage = 0;
        [weakSelf loadSecondData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.secondPage ++;
        [weakSelf loadSecondData];
    }];
}
- (void)loadSecondData {
    __weak typeof(self) weakSelf = self;
    NSDictionary *params = @{@"page":@(self.secondPage),@"limit":@"20",@"type":@"2",@"auth_key":[LJKHelper getAuth_key],@"page":@(self.secondPage)};
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/get-favourite",Server_url] parameters:params method:POST callBack:^(id responseObject) {
        if (responseObject) {
            if (weakSelf.secondPage == 0) {
                [YJGIFAnimationView hideInView:self.view];
                [weakSelf.secondAry removeAllObjects];
                if (![responseObject[@"result"] count]) {
                    self.noSearchResultView.hidden = NO;
                }
            }
            NSArray *ary = responseObject[@"result"];
            for (int i=0; i<ary.count; i++) {
                YJHouseListModel *model = [MTLJSONAdapter modelOfClass:[YJHouseListModel class] fromJSONDictionary:ary[i][@"info"] error:nil];
                model.content = ary[i][@"content"];
                model.state = ary[i][@"state"];
                [weakSelf.secondAry addObject:model];
            }
            if (ary.count<20) {
                weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
            [SVProgressHUD dismiss];
        }
    } error:^(NSError *error) {
        
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 128;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.secondAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJCollectionSecondHandViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSecondHandCellIdentifier forIndexPath:indexPath];
    if(!cell) {
        cell = [[YJCollectionSecondHandViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSecondHandCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellRow = indexPath.section;
    cell.deleagate = self;
    [cell showDataWithModel:self.secondAry[indexPath.section]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YJHouseListModel *model = self.secondAry[indexPath.section];
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
        YJHouseListModel *model = self.secondAry[indexPath.section];
        NSDictionary *params = @{@"auth_key":[LJKHelper getAuth_key],@"site":model.site,@"id":model.house_id};
        [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/cancel-favourite",Server_url] parameters:params method:POST callBack:^(id responseObject) {
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                [self.secondAry removeObjectAtIndex:indexPath.section];
               [self.tableView reloadData];
                [SVProgressHUD dismiss];
            }
        } error:^(NSError *error) {
            
        }];
    }
}

- (void)remarkAction:(NSInteger)cellRow {
    YJHouseListModel *model = self.secondAry[cellRow];
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
