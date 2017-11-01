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
#import "YJHouseRecommendViewController.h"
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
    NSArray * titleAry = @[@"收藏二手房降价",@"收藏出租房降价",@"收藏小区新上二手房",@"收藏小区新上出租房",@"评论回复",@"反馈",@"举报",@"系统消息"];
    NSArray * contentAry = @[@"查看收藏二手房降价",@"查看收藏租房降价",@"查看收藏小区新上二手房最新资讯",@"查看收藏小区新上租房最新资讯",@"查看评论回复",@"查看反馈消息",@"查看举报消息",@"查看系统更新提醒"];
    for (int i=0; i<titleAry.count; i++) {
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
    YJMsgModel *model = self.contentAry[indexPath.row];
    model.count = 0;
    YJHouseRecommendViewController *vcR = [[YJHouseRecommendViewController alloc] init];
    if (indexPath.row == 0) {
        vcR.type = @"6"; // 收藏二手房降价
        PushController(vcR);
    } else if (indexPath.row == 1){
        vcR.type = @"7"; // 收藏租房降价
        PushController(vcR);
        
    }else if (indexPath.row == 2){
        vcR.type = @"9"; //收藏小区二手房上新
        PushController(vcR);
        
    }else if (indexPath.row == 3){
        vcR.type = @"10"; //收藏小区出租房上新
        PushController(vcR);
        
    } else {
        YJMessageDetailViewController *vc = [[YJMessageDetailViewController alloc] init];
        switch (indexPath.row) {
            case 4:
            {
                vc.type = @"8"; //评论回复
            }
                break;
            case 5:
            {
                vc.type = @"5"; //反馈
            }
                break;
            case 6:
            {
                vc.type = @"4";  //举报
            }
                break;
            case 7:
            {
                vc.type = @"1"; //系统消息
            }
                break;
            default:
                break;
        }
        PushController(vc);
    }
     [self.tableView reloadData];
}
@end
