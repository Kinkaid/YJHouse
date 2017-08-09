//
//  YJMessageDetailViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/22.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJMessageDetailViewController.h"
#import "YJMessageDetailViewCell.h"
#import "YJMsgModel.h"
#import "YJNoSearchDataView.h"
#define kCellIdentifier @"YJMessageDetailViewCell"
@interface YJMessageDetailViewController ()<UITableViewDelegate,UITableViewDataSource,YJRequestTimeoutDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *msgAry;
@property (nonatomic,strong) YJNoSearchDataView *noSearchResultView;
@end

@implementation YJMessageDetailViewController

- (YJNoSearchDataView *)noSearchResultView {
    if (!_noSearchResultView) {
        _noSearchResultView = [[YJNoSearchDataView alloc] initWithFrame:CGRectMake(0, 64, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 64)];
        [self.view addSubview:_noSearchResultView];
        _noSearchResultView.content = @"暂无消息";
    }
    return _noSearchResultView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"消息列表"];
    [YJRequestTimeoutUtil shareInstance].delegate = self;
    [YJGIFAnimationView showInView:self.view frame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    [self registerTableView];
    [self registerRefresh];
    [self loadMsgData];
}

- (void)registerTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    self.page = 0;
    self.msgAry = [@[] mutableCopy];
}

- (void)registerRefresh {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 0;
        [weakSelf loadMsgData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf loadMsgData];
    }];
}
- (void)requestTimeoutAction {
    if (self.isVisible) {
        [self loadMsgData];
    }
}
- (void)loadMsgData {
    __weak typeof(self)weakSelf = self;
    NSDictionary *params = @{@"page":@(self.page),@"type":self.type,@"auth_key":[LJKHelper getAuth_key]};
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/get-message-list",Server_url] parameters:params method:POST callBack:^(id responseObject) {
        if (!ISEMPTY(responseObject)) {
            if (weakSelf.page == 0) {
                [YJGIFAnimationView hideInView:self.view];
                [weakSelf.msgAry removeAllObjects];
                [weakSelf.tableView.mj_header endRefreshing];
                NSArray *ary = responseObject[@"result"];
                if (![ary count]) {
                    self.noSearchResultView.hidden = NO;
                } else {
                    [LJKHelper saveLastRequestMsgTime:responseObject[@"result"][0][@"time"]];
                }
            }
            NSArray *ary =responseObject[@"result"];
            for (int i=0; i<[ary count]; i++) {
                YJMsgModel *model = [MTLJSONAdapter modelOfClass:[YJMsgModel class] fromJSONDictionary:ary[i] error:nil];
                [weakSelf.msgAry addObject:model];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJMsgModel *model = self.msgAry[indexPath.section];
    return 30 + [LJKHelper textHeightFromTextString:model.content width:APP_SCREEN_WIDTH - 20 fontSize:13] + 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.msgAry.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJMessageDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[YJMessageDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showDataWithModel:self.msgAry[indexPath.section]];
    return cell;
}
@end
