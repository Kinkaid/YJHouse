//
//  WDXiaoquCollectionViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/5.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJXiaoquCollectionViewController.h"
#import "YJXiaoQuViewCell.h"
#import "YJXiaoQuDetailViewController.h"
#define cellId @"YJXiaoQuViewCell"
@interface YJXiaoquCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) NSInteger xiaoquPage;
@property (nonatomic,strong) NSMutableArray *xiaoquAry;

@end

@implementation YJXiaoquCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"收藏的小区"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self registerTableView];
    [self registerRefresh];
    [self loadXiaoquListData];
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
    [[NetworkTool sharedTool] requestWithURLString:@"https://ksir.tech/you/frontend/web/app/user/get-favourite" parameters:params method:POST callBack:^(id responseObject) {
        if (responseObject) {
            if (weakSelf.xiaoquPage == 0) {
                [weakSelf.xiaoquAry removeAllObjects];
            }
            NSArray *ary = responseObject[@"result"];
            for (int i=0; i<ary.count; i++) {
                YJXiaoquModel *model = [MTLJSONAdapter modelOfClass:[YJXiaoquModel class] fromJSONDictionary:ary[i] error:nil];
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
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.xiaoquAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJXiaoQuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if(!cell) {
        cell = [[YJXiaoQuViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showDataWithModel:self.xiaoquAry[indexPath.row]];
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
        YJXiaoquModel *model = self.xiaoquAry[indexPath.row];
        NSDictionary *params = @{@"auth_key":[LJKHelper getAuth_key],@"site":model.site,@"id":model.xqID};
        [[NetworkTool sharedTool] requestWithURLString:@"https://ksir.tech/you/frontend/web/app/user/cancel-favourite" parameters:params method:POST callBack:^(id responseObject) {
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                [self.xiaoquAry removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
            }
        } error:^(NSError *error) {
            
        }];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    YJXiaoQuDetailViewController *vc = [[YJXiaoQuDetailViewController alloc] init];
//    PushController(vc);
}

@end
