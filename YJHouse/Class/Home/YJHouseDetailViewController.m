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
#import "YJHouseDetailModel.h"
#import "YJDate.h"
#import "YJWebViewController.h"
@interface YJHouseDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIScrollView *imgScrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
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
@property (nonatomic,strong) YJHouseDetailModel *houseModel;





@end

@implementation YJHouseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    [self registerTableView];
    [self loadHouseDetailData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)registerTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.headerView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH * 0.66 + 180 + 12 + 290 + 12 + 300 + 12 + 250 + 12 + 50);
    [self.tableView setTableHeaderView:self.headerView];
}
- (void)loadHouseDetailData {
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:@"https://ksir.tech/you/frontend/web/app/ershou/item-info" parameters:@{@"site_id":self.site_id,@"uid":self.uid} method:GET callBack:^(id responseObject) {
        if (responseObject) {
            NSMutableArray *imgAry = [@[] mutableCopy];
            if (!ISEMPTY(responseObject[@"result"][@"info"][@"main_img"])) {
               [imgAry addObject:responseObject[@"result"][@"info"][@"main_img"]];
            }
            for (int i=0; i<[responseObject[@"result"][@"img"] count]; i++) {
                [imgAry addObject:responseObject[@"result"][@"img"][i][@"url"]];
            }
            weakSelf.houseModel = [MTLJSONAdapter modelOfClass:[YJHouseDetailModel class] fromJSONDictionary:responseObject[@"result"][@"info"] error:nil];
            weakSelf.houseModel.imgAry = imgAry;
            weakSelf.pageControl.numberOfPages = imgAry.count;
            [self fillData];
        }
        
    }];
}
- (void)fillData {
    if (self.houseModel.imgAry.count) {
        self.imgScrollView.contentSize = CGSizeMake(APP_SCREEN_WIDTH *self.houseModel.imgAry.count, 0);
        for (int i=0; i<self.houseModel.imgAry.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH *i, 0, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH *0.66)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.houseModel.imgAry[i]] placeholderImage:[UIImage imageNamed:@"icon_placeholder"]];
            [self.imgScrollView addSubview:imageView];
        }
    } else {
        self.imgScrollView.contentSize = CGSizeMake(APP_SCREEN_WIDTH , 0);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH *0.66)];
        imageView.image = [UIImage imageNamed:@"icon_placeholder"];
        [self.imgScrollView addSubview:imageView];
    }
    
    self.houseDescriptionLabel.text = self.houseModel.title;
    self.sketchTimeLabel.text = [NSString stringWithFormat:@"房源上架于%@",[YJDate parseRemoteDataToString:self.houseModel.update_time withFormatterString:@"yyyy-MM-dd"]];
    self.housePriceLabel.text = [NSString stringWithFormat:@"%@万",self.houseModel.total_price];
    self.houseApartmentLayoutLabel.text = self.houseModel.type;
    self.houseAreaLabel.text = [NSString stringWithFormat:@"%.0f平",[self.houseModel.area floatValue]];
    self.averagePriceLabel.text = [NSString stringWithFormat:@"均价:%@元/平",self.houseModel.unit_price];
     self.sketchTimeLabel.text = [NSString stringWithFormat:@"挂牌:%@",[YJDate parseRemoteDataToString:self.houseModel.update_time withFormatterString:@"yyyy-MM-dd"]];
    self.floorLabel.text = [NSString stringWithFormat:@"楼层:%@/%@层",self.houseModel.tour_count,self.houseModel.total_storey];
    self.faceDirectionLabel.text = [NSString stringWithFormat:@"朝向:%@",self.houseModel.toward];
    self.repairInfoLabel.text = [NSString stringWithFormat:@"装修:%@",self.houseModel.decoration];
    self.houseTypeLabel.text = [NSString stringWithFormat:@"楼型:%@",@"无"];
    self.completionTimeLabel.text = [NSString stringWithFormat:@"年代:%@",self.houseModel.age];
    self.regionLabel.text = [NSString stringWithFormat:@"区域:%@-%@",self.houseModel.region,self.houseModel.plate];
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%@",self.houseModel.good] forState:UIControlStateNormal];
    [self.dislikeBtn setTitle:[NSString stringWithFormat:@"%@",self.houseModel.bad] forState:UIControlStateNormal];
    
    CGFloat total = ([self.houseModel.good floatValue] + [self.houseModel.bad floatValue]);
    CGFloat ratio = [self.houseModel.good floatValue] / total == 0 ?1:total;
    [self.toScoreBtn setTitle:[NSString stringWithFormat:@"%.0f%%",ratio] forState:UIControlStateNormal];
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
    PushController(vc);
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
- (IBAction)openUrl:(id)sender {
    YJWebViewController *vc = [[YJWebViewController alloc] init];
    vc.url = self.houseModel.page;
    PushController(vc);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.imgScrollView) {
        self.pageControl.currentPage = self.imgScrollView.contentOffset.x / APP_SCREEN_WIDTH;
    }
}
@end
