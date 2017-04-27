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
@interface YJCollectionRentViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YJCollectionRentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerRefresh];
    [self registerTableView];
    
}
- (void)registerRefresh {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
    }];
}
- (void)registerTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
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
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    YJHouseListModel *model = self.homeHouseAry[indexPath.row];
//    YJHouseDetailViewController *vc = [[YJHouseDetailViewController alloc] init];
//    vc.site_id =model.site;
//    vc.uid = model.uid;
//    PushController(vc);
}
@end
