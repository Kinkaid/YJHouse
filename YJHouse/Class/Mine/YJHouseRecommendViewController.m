//
//  YJHouseRecommendViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/8/6.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJHouseRecommendViewController.h"
#import "YJReducePriceViewCell.h"
#import "YJHouseListModel.h"
#import "YJHouseDetailViewController.h"
#import "YJNoSearchDataView.h"
#import "YJNoSearchDataView.h"
#define kCellIdentifier @"YJReducePriceViewCell"

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
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.homePage = 0;
    self.homeHouseAry = [@[] mutableCopy];
    if ([self.type isEqualToString:@"6"]) {
        [self setTitle:@"收藏二手房降价"];
    } else if ([self.type isEqualToString:@"7"]){
        [self setTitle:@"收藏租房降价"];
    }else if ([self.type isEqualToString:@"9"]){
        [self setTitle:@"收藏小区新上二手房"];
    }else if ([self.type isEqualToString:@"10"]){
        [self setTitle:@"收藏小区新上租房"];
    }
}
- (void)loadHouseData {
    __weak typeof(self)weakSelf = self;
    NSDictionary *params = @{@"page":@(self.homePage),@"type":self.type,@"auth_key":@"GMyK87fb8TZHtGYTwXzxm117i9Q_ew4i"};
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
            for (int i = 0; i<ary.count; i++) {
                if([self.type isEqualToString:@"6"]||[self.type isEqualToString:@"7"]){
                    YJHouseListModel * model = [MTLJSONAdapter modelOfClass:[YJHouseListModel class] fromJSONDictionary:ary[i][@"content"] error:nil];
                    model.xq_new = NO;
                    model.time =ary[i][@"time"];
                    if ([self.type isEqualToString:@"6"]||[self.type isEqualToString:@"9"]) {
                        model.zufang = NO;
                    } else {
                        model.zufang = YES;
                    }
                    [weakSelf.homeHouseAry addObject:model];
                } else {
//                    NSArray *sameDateAry = [LJKHelper stringToJSON:ary[i][@"content"]];
//                    for (int j=0; j<[sameDateAry count]; j++) {
//                        YJHouseListModel *model = [MTLJSONAdapter modelOfClass:[YJHouseListModel class] fromJSONDictionary:sameDateAry[j] error:nil];
//                        model.time = sameDateAry[j][@"date"];
//                        model.xq_new = YES;
//                        if ([self.type isEqualToString:@"6"]||[self.type isEqualToString:@"9"]) {
//                            model.zufang = NO;
//                        } else {
//                            model.zufang = YES;
//                        }
//                        [weakSelf.homeHouseAry addObject:model];
//                    }
                    YJHouseListModel * model = [MTLJSONAdapter modelOfClass:[YJHouseListModel class] fromJSONDictionary:[LJKHelper stringToJSON:ary[i][@"content"]] error:nil];
                    model.xq_new = YES;
                    model.time =ary[i][@"time"];
                    if ([self.type isEqualToString:@"6"]||[self.type isEqualToString:@"9"]) {
                        model.zufang = NO;
                    } else {
                        model.zufang = YES;
                    }
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
    return self.homeHouseAry.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 97;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJReducePriceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showDataWithModels:self.homeHouseAry[indexPath.section]];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section >=1) {
        YJHouseListModel *fir = self.homeHouseAry[section-1];
        YJHouseListModel *sec = self.homeHouseAry[section];
        if ([[LJKHelper dateStringFromNumberTimer:sec.time withFormat:@"yyyy.MM.dd"] isEqualToString:[LJKHelper dateStringFromNumberTimer:fir.time withFormat:@"yyyy.MM.dd"]]) {
            return nil;
        } else {
            UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
            return headerView;
        }
    } else {
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
        return headerView;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.textLabel.font = [UIFont systemFontOfSize:12];
    headerView.textLabel.textColor = [UIColor ex_colorFromHexRGB:@"C8CACE"];
    headerView.textLabel.textAlignment = NSTextAlignmentCenter;
    YJHouseListModel *model = self.homeHouseAry[section];
    headerView.textLabel.text = [LJKHelper dateStringFromNumberTimer:model.time withFormat:@"yyyy.MM.dd"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section >=1) {
        YJHouseListModel *fir = self.homeHouseAry[section-1];
        YJHouseListModel *sec = self.homeHouseAry[section];
        if ([[LJKHelper dateStringFromNumberTimer:sec.time withFormat:@"yyyy.MM.dd"] isEqualToString:[LJKHelper dateStringFromNumberTimer:fir.time withFormat:@"yyyy.MM.dd"]]) {
            return 0.01;
        } else {
            return 30.0;
        }
    } else {
        return 30.0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger) section {
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YJHouseListModel *model = self.homeHouseAry[indexPath.section];
    YJHouseDetailViewController *vc = [[YJHouseDetailViewController alloc] init];
    vc.site_id =model.site;
    vc.house_id = model.house_id;
    if (model.zufang) {
        vc.type = type_zufang;
    } else {
        vc.type = type_maifang;
    }
    PushController(vc);
}
@end
