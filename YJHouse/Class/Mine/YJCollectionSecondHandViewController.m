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
#define kSecondHandCellIdentifier @"YJCollectionSecondHandViewCell"
@interface YJCollectionSecondHandViewController ()<UITableViewDelegate,UITableViewDataSource,YJRemarkActionDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) NSInteger secondPage;
@property (nonatomic,strong) NSMutableArray *secondAry;

@end

@implementation YJCollectionSecondHandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setTitle:@"我收藏的二手房"];
    [self registerTableView];
    [self registerRefresh];
    [self loadSecondData];
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
    [[NetworkTool sharedTool] requestWithURLString:@"https://ksir.tech/you/frontend/web/app/user/get-favourite" parameters:params method:POST callBack:^(id responseObject) {
        if (responseObject) {
            if (weakSelf.secondPage == 0) {
                [weakSelf.secondAry removeAllObjects];
            }
            NSArray *ary = responseObject[@"result"];
            for (int i=0; i<ary.count; i++) {
                YJHouseListModel *model = [MTLJSONAdapter modelOfClass:[YJHouseListModel class] fromJSONDictionary:ary[i] error:nil];
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
    return self.secondAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJCollectionSecondHandViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSecondHandCellIdentifier forIndexPath:indexPath];
    if(!cell) {
        cell = [[YJCollectionSecondHandViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSecondHandCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellRow = indexPath.row;
    cell.deleagate = self;
    [cell showDataWithModel:self.secondAry[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
        YJHouseListModel *model = self.secondAry[indexPath.row];
        NSDictionary *params = @{@"auth_key":[LJKHelper getAuth_key],@"site":model.site,@"id":model.house_id};
        [[NetworkTool sharedTool] requestWithURLString:@"https://ksir.tech/you/frontend/web/app/user/cancel-favourite" parameters:params method:POST callBack:^(id responseObject) {
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                [self.secondAry removeObjectAtIndex:indexPath.row];
               [self.tableView reloadData];
                [SVProgressHUD dismiss];
            }
        } error:^(NSError *error) {
            
        }];
    }
}

- (void)remarkAction:(NSInteger)cellRow {
    YJHouseListModel *model = self.secondAry[cellRow];
    YJRemarkViewController *vc = [[YJRemarkViewController alloc] init];
    vc.site = model.site;
    vc.ID = model.house_id;
    PushController(vc);
}
@end
