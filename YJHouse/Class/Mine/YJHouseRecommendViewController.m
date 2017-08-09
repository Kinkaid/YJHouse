//
//  YJHouseRecommendViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/8/6.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJHouseRecommendViewController.h"
#import "YJHomePageViewCell.h"
#import "YJHouseListModel.h"
#import "YJHouseDetailViewController.h"
#import "YJNoSearchDataView.h"
#import "YJNoSearchDataView.h"
#define kCellIdentifier @"YJHomePageViewCell"

@interface YJHouseRecommendViewController ()<UITableViewDelegate,UITableViewDataSource,YJRequestTimeoutDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) NSInteger homePage;
@property (nonatomic,strong) NSMutableArray *homeHouseAry;
@property (nonatomic,strong) YJNoSearchDataView *noSearchResultView;
@end

@implementation YJHouseRecommendViewController


- (YJNoSearchDataView *)noSearchResultView {
    if (!_noSearchResultView) {
        _noSearchResultView = [[YJNoSearchDataView alloc] initWithFrame:CGRectMake(0, 64, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 64)];
        [self.view addSubview:_noSearchResultView];
        _noSearchResultView.content = @"暂无推荐";
    }
    return _noSearchResultView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [YJRequestTimeoutUtil shareInstance].delegate = self;
    [YJGIFAnimationView showInView:self.view frame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    [self registerRefresh];
    [self registerTableView];
    [self loadHouseData];
}
- (void)requestTimeoutAction {
    if (self.isVisible) {
        [self loadHouseData];
    }
}
- (void)registerRefresh {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.homePage = 0;
        [weakSelf loadHouseData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.homePage ++;
        [weakSelf loadHouseData];
    }];
}
- (void)registerTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.homePage = 0;
    self.homeHouseAry = [@[] mutableCopy];
    if ([self.type isEqualToString:@"6"]) {
        [self setTitle:@"二手房推荐"];
    } else {
        [self setTitle:@"租房推荐"];
    }
}
- (void)loadHouseData {
    __weak typeof(self)weakSelf = self;
    NSDictionary *params = @{@"page":@(self.homePage),@"type":self.type,@"auth_key":[LJKHelper getAuth_key]};
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/get-message-list",Server_url] parameters:params method:POST callBack:^(id responseObject) {
        if (!ISEMPTY(responseObject)) {
            [YJGIFAnimationView hideInView:self.view];
            if (weakSelf.homePage == 0) {
                [YJGIFAnimationView hideInView:self.view];
                [weakSelf.homeHouseAry removeAllObjects];
                [weakSelf.tableView.mj_header endRefreshing];
                if (![responseObject[@"result"] count]) {
                    self.noSearchResultView.hidden = NO;
                }
            }
            NSArray *ary = responseObject[@"result"];
            for (int i=0; i<ary.count; i++) {
                for (int i = 0; i<ary.count; i++) {
                    YJHouseListModel *model = [MTLJSONAdapter modelOfClass:[YJHouseListModel class] fromJSONDictionary:ary[i][@"content"] error:nil];
                    if ([self.type isEqualToString:@"6"]) {
                        model.zufang = NO;
                    } else {
                        model.zufang = YES;
                    }
                    model.topcut = @"";
                    [weakSelf.homeHouseAry addObject:model];
                }
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeHouseAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 97;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJHomePageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showDataWithModel:self.homeHouseAry[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YJHouseListModel *model = self.homeHouseAry[indexPath.row];
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
@end
