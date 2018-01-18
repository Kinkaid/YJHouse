//
//  YJRecommondViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/6/9.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJRecommondViewController.h"
#import "YJHouseListModel.h"
#import "YJHomePageViewCell.h"
#import "YJHouseDetailViewController.h"
static NSString *const kCellIdentifier = @"YJHomePageViewCell";
@interface YJRecommondViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YJRecommondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:self.mainTitle];
    [self registerTabelView];
}
- (void)registerTabelView {
    [self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.houseAry.count;
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
    [cell showDataWithModel:self.houseAry[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YJHouseListModel *model = self.houseAry[indexPath.row];
    YJHouseDetailViewController *vc = [[YJHouseDetailViewController alloc] init];
    vc.site_id = model.site;
    if (model.zufang) {
        vc.type = type_zufang;
    } else {
        vc.type = type_maifang;
    }
    vc.house_id = model.house_id;
    vc.score = model.total_score;
    PushController(vc);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
