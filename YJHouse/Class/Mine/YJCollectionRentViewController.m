//
//  YJCollectionRentViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/21.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJCollectionRentViewController.h"
#import "YJHomePageViewCell.h"
#import "YJHouseDetailViewController.h"
#define kCellIdentifier @"YJHomePageViewCell"
@interface YJCollectionRentViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) NSInteger rentPage;
@property (nonatomic,strong) NSMutableArray *rentAry;

@end

@implementation YJCollectionRentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerRefresh];
    [self setTitle:@"我收藏的租房"];
    [self registerTableView];
    [self registerRefresh];
    [self loadRentData];
    
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
    [[NetworkTool sharedTool] requestWithURLString:@"https://ksir.tech/you/frontend/web/app/user/get-favourite" parameters:params method:POST callBack:^(id responseObject) {
        if (responseObject) {
            if (weakSelf.rentPage == 0) {
                [weakSelf.rentAry removeAllObjects];
                [weakSelf.tableView.mj_header endRefreshing];
                [SVProgressHUD dismiss];
            }
            NSArray *ary = responseObject[@"result"];
            for (int i = 0; i<ary.count; i++) {
                YJHouseListModel *model = [MTLJSONAdapter modelOfClass:[YJHouseListModel class] fromJSONDictionary:ary[i] error:nil];
                model.zufang = YES;
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rentAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 97;
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
        YJHouseListModel *model = self.rentAry[indexPath.row];
        NSDictionary *params = @{@"auth_key":[LJKHelper getAuth_key],@"site":model.site,@"id":model.house_id};
        [[NetworkTool sharedTool] requestWithURLString:@"https://ksir.tech/you/frontend/web/app/user/cancel-favourite" parameters:params method:POST callBack:^(id responseObject) {
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                [self.rentAry removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
            }
        } error:^(NSError *error) {
            
        }];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJHomePageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showDataWithModel:self.rentAry[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YJHouseListModel *model = self.rentAry[indexPath.row];
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
