//
//  WDXiaoquCollectionViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/5.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJXiaoquCollectionViewController.h"
#import "YJXiaoquCollectionViewCell.h"
#import "YJXiaoQuDetailViewController.h"
#define cellId @"YJXiaoquCollectionViewCell"
#import "YJNoSearchDataView.h"
#import "YJRemarkViewController.h"
@interface YJXiaoquCollectionViewController ()<UITableViewDelegate,UITableViewDataSource,YJRequestTimeoutDelegate,YJRemarkActionDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) NSInteger xiaoquPage;
@property (nonatomic,strong) NSMutableArray *xiaoquAry;
@property (nonatomic,strong) YJNoSearchDataView *noSearchResultView;
@end

@implementation YJXiaoquCollectionViewController


- (YJNoSearchDataView *)noSearchResultView {
    if (!_noSearchResultView) {
        _noSearchResultView = [[YJNoSearchDataView alloc] initWithFrame:CGRectMake(0, 64, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 64)];
        [self.view addSubview:_noSearchResultView];
        _noSearchResultView.content = @"暂无收藏小区";
    }
    return _noSearchResultView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [YJRequestTimeoutUtil shareInstance].delegate = self;
    [YJGIFAnimationView showInView:self.view frame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    [self setTitle:@"收藏的小区"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self registerTableView];
    [self registerRefresh];
    [self loadXiaoquListData];
}
- (void)requestTimeoutAction {
    if (self.isVisible) {
        [self loadXiaoquListData];
    }
}
- (void)registerTableView {
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    self.xiaoquPage = 0;
    self.xiaoquAry = [@[] mutableCopy];
}
- (void)registerRefresh {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.xiaoquPage = 0;
        [weakSelf loadXiaoquListData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.xiaoquPage ++;
        [weakSelf loadXiaoquListData];
    }];
}
- (void)loadXiaoquListData {
    __weak typeof(self) weakSelf = self;
    NSDictionary *params = @{@"page":@(self.xiaoquPage),@"limit":@"20",@"type":@"3",@"auth_key":[LJKHelper getAuth_key]};
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/get-favourite",Server_url] parameters:params method:POST callBack:^(id responseObject) {
        if (responseObject) {
            if (weakSelf.xiaoquPage == 0) {
                [YJGIFAnimationView hideInView:self.view];
                [weakSelf.xiaoquAry removeAllObjects];
                if (![responseObject[@"result"] count]) {
                    self.noSearchResultView.hidden = NO;
                }
            }
            NSArray *ary = responseObject[@"result"];
            for (int i=0; i<ary.count; i++) {
                YJXiaoquModel *model = [MTLJSONAdapter modelOfClass:[YJXiaoquModel class] fromJSONDictionary:ary[i][@"info"] error:nil];
                model.content =ary[i][@"content"];
                model.state = ary[i][@"state"];
                [weakSelf.xiaoquAry addObject:model];
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
    return 138;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.xiaoquAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJXiaoquCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if(!cell) {
        cell = [[YJXiaoquCollectionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.deleagate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellRow = indexPath.section;
    [cell showDataWithModel:self.xiaoquAry[indexPath.section]];
    return cell;
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
        YJXiaoquModel *model = self.xiaoquAry[indexPath.section];
        NSDictionary *params = @{@"auth_key":[LJKHelper getAuth_key],@"site":model.site,@"id":model.xqID};
        [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/cancel-favourite",Server_url] parameters:params method:POST callBack:^(id responseObject) {
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                [self.xiaoquAry removeObjectAtIndex:indexPath.section];
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
            }
        } error:^(NSError *error) {
            
        }];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YJXiaoQuDetailViewController *vc = [[YJXiaoQuDetailViewController alloc] init];
    YJXiaoquModel *model = self.xiaoquAry[indexPath.section];
    vc.xiaoquId = model.xqID;
    PushController(vc);
}
- (void)remarkAction:(NSInteger)cellRow {
    YJXiaoquModel *model = self.xiaoquAry[cellRow];
    YJRemarkViewController *vc = [[YJRemarkViewController alloc] init];
    vc.site = model.site;
    vc.ID = model.xqID;
    vc.content = ISEMPTY(model.content) ? @"" : model.content;
    [vc returnContent:^(NSString *content) {
        model.content = content;
        [self.tableView reloadData];
    }];
    PushController(vc);
}
@end
