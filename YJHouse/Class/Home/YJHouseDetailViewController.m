//
//  YJHouseDetailViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/25.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJHouseDetailViewController.h"
#import "YJHomePageViewCell.h"
#import "YJReportAndFeedbackViewController.h"
#define kCellIdentifier @"YJHomePageViewCell"
@interface YJHouseDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *houseImg;//图片
@property (weak, nonatomic) IBOutlet UILabel *houseDescriptionLabel;//房源介绍
@property (weak, nonatomic) IBOutlet UILabel *houseScoreLabel;//评分
@property (weak, nonatomic) IBOutlet UILabel *sketchTimeLabel;//房源上架时间

@property (weak, nonatomic) IBOutlet UILabel *housePriceLabel;//售价
@property (weak, nonatomic) IBOutlet UILabel *houseApartmentLayoutLabel;//户型
@property (weak, nonatomic) IBOutlet UILabel *houseAreaLabel;//面积

@property (weak, nonatomic) IBOutlet UILabel *averagePriceLabel;//均价
@property (weak, nonatomic) IBOutlet UILabel *putupTimeLabel;//挂牌时间
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;//楼层

@property (weak, nonatomic) IBOutlet UILabel *faceDirectionLabel;//朝向
@property (weak, nonatomic) IBOutlet UILabel *repairInfoLabel;//装修
@property (weak, nonatomic) IBOutlet UILabel *houseTypeLabel;//楼型
@property (weak, nonatomic) IBOutlet UILabel *completionTimeLabel;//年代
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;//区域
@property (weak, nonatomic) IBOutlet UILabel *communityNameLabel;//小区名称
@property (weak, nonatomic) IBOutlet UILabel *communityAveragePriceLabel;//小区均价
@property (weak, nonatomic) IBOutlet UILabel *communityLocationLabel;//小区位置
@property (weak, nonatomic) IBOutlet UILabel *communityCompletionTimeLabel;//小区年代
@property (weak, nonatomic) IBOutlet UILabel *communityTypeLabel;//小区类型
@property (weak, nonatomic) IBOutlet UILabel *communityInfoLabel;//小区信息

@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIButton *toScoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *dislikeBtn;
@property (weak, nonatomic) IBOutlet UIView *showView;






@end

@implementation YJHouseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerTableView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)registerTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.headerView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH * 0.66 + 180 + 12 + 290 + 12 + 300 + 12 + 250 + 12 + 50);
    [self.tableView setTableHeaderView:self.headerView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
    YJHouseDetailViewController *vc = [[YJHouseDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - IBActions
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)reportAction:(id)sender { //举报
    YJReportAndFeedbackViewController *vc = [[YJReportAndFeedbackViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)moreParamsAction:(id)sender {//更多参数
}
- (IBAction)moreFetureAction:(id)sender {//更多特色
}
- (IBAction)villageInfoAction:(id)sender {//小区信息
}
- (IBAction)toSelectAction:(id)sender {
    [UIView animateWithDuration:0.4 animations:^{
        self.selectView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH - 160.0, 46);
        self.showView.frame = CGRectMake(0, 46, APP_SCREEN_WIDTH - 160, 46);
    } completion:^(BOOL finished) {
    }];
}
- (IBAction)collectionAction:(id)sender {
    [self.collectionBtn setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
    [self.collectionBtn setTitle:[NSString stringWithFormat:@" %d",[self.collectionBtn.titleLabel.text intValue] + 1] forState:UIControlStateNormal];
}
- (IBAction)shareAction:(id)sender {
    
}
- (IBAction)likeAction:(id)sender {
    [self.likeBtn setTitle:[NSString stringWithFormat:@" %d",[self.likeBtn.titleLabel.text intValue] +1] forState:UIControlStateNormal];
    [self.toScoreBtn setTitle:[NSString stringWithFormat:@" %.0f%%",([self.likeBtn.titleLabel.text floatValue] / ([self.dislikeBtn.titleLabel.text floatValue] +[self.likeBtn.titleLabel.text floatValue])) * 100] forState:UIControlStateNormal];
    UIView *bottonView = [self.view viewWithTag:10];
    [bottonView bringSubviewToFront:self.showView];
    [UIView animateWithDuration:0.4 animations:^{
        self.selectView.frame = CGRectMake(0, 46, APP_SCREEN_WIDTH - 160.0, 46);
        self.showView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH - 160, 46);
    } completion:^(BOOL finished) {
        [bottonView bringSubviewToFront:self.selectView];
    }];
}

- (IBAction)dislikeAction:(id)sender {
    [self.dislikeBtn setTitle:[NSString stringWithFormat:@" %d",[self.dislikeBtn.titleLabel.text intValue] +1] forState:UIControlStateNormal];
    [self.toScoreBtn setTitle:[NSString stringWithFormat:@" %.0f%%",([self.likeBtn.titleLabel.text floatValue] / ([self.dislikeBtn.titleLabel.text floatValue] +[self.likeBtn.titleLabel.text floatValue])) * 100] forState:UIControlStateNormal];
    UIView *bottonView = [self.view viewWithTag:10];
    [bottonView bringSubviewToFront:self.showView];
    [UIView animateWithDuration:0.4 animations:^{
        self.selectView.frame = CGRectMake(0, 46, APP_SCREEN_WIDTH - 160.0, 46);
        self.showView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH - 160, 46);
    } completion:^(BOOL finished) {
        [bottonView bringSubviewToFront:self.selectView];
    }];
}


@end
