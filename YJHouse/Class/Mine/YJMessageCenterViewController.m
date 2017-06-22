//
//  YJMessageCenterViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/3/9.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJMessageCenterViewController.h"
#import "YJMessageCenterCell.h"
#import "YJMessageDetailViewController.h"
#define kCellIdentifier @"YJMessageCenterCell"
@interface YJMessageCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *contentAry;
@end

@implementation YJMessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    [self registerTableView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)registerTableView {
    self.contentAry = [@[] mutableCopy];
    [self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    NSArray * titleAry = @[@"客服",@"举报反馈",@"系统消息",@"二手房推荐",@"租房推荐"];
    NSArray * contentAry = @[@"查看优家客服的回复消息",@"查看举报反馈消息",@"查看系统更新提醒",@"查看收藏二手房降价和收藏小区新房源的最新资讯",@"查看收藏租房降价和收藏小区新房源的最新资讯"];
    for (int i=0; i<5; i++) {
        YJMsgModel *model = [[YJMsgModel alloc] init];
        model.content = contentAry[i];
        model.title = titleAry[i];
        model.count = [self.msgCount[i] intValue];
        [self.contentAry addObject:model];
    }
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJMessageCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[YJMessageCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showDataWithModel:self.contentAry[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YJMessageDetailViewController *vc = [[YJMessageDetailViewController alloc] init];
    switch (indexPath.row) {
        case 0:
        {
            vc.type = @"5";
        }
            break;
        case 1:
        {
            vc.type = @"4";
        }
            break;
        case 2:
        {
            vc.type = @"1";
        }
            break;
        case 3:
        {
            vc.type = @"2";
        }
            break;
        case 4:
        {
            vc.type = @"3";
        }
            break;
        default:
            break;
    }
    YJMsgModel *model = self.contentAry[indexPath.row];
    model.count = 0;
    [self.tableView reloadData];
    PushController(vc);
}
@end
