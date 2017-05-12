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
@property (weak, nonatomic) IBOutlet UILabel *shoujiaOrjunjiaLabel;

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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sellInfoConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xiaoquInfoConstraint;

@property (weak, nonatomic) IBOutlet UIView *sellInfoView;
@property (weak, nonatomic) IBOutlet UIView *supportingFacilitiesView;

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
    if (self.type == type_zufang) {
        _supportingFacilitiesView.hidden = NO;
        NSArray *imgAry = @[@"icon_d_ds_s",@"icon_d_wl_s",@"icon_d_bx_s",@"icon_d_xyj_s",@"icon_d_rsq_s",@"icon_d_kt_s",@"icon_d_trq_s",@"icon_d_c_s"];
        for (int i=0; i<8; i++) {
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH / 8.0 *i, 64, APP_SCREEN_WIDTH / 8.0, APP_SCREEN_WIDTH / 8.0)];
            imgV.image = [UIImage imageNamed:imgAry[i]];
            [self.supportingFacilitiesView addSubview:imgV];
        }
        if (arc4random() % 2 ) {
            self.sellInfoView.hidden = NO;
            self.sellInfoConstraint.constant = 154;
            self.xiaoquInfoConstraint.constant = 466;
            self.headerView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH * 0.66 + 180 + 12 + 290 + 12 + 130 + 12 + 300 + 12 + 250 + 12 + 50);
        } else {
            self.sellInfoView.hidden = YES;
            self.xiaoquInfoConstraint.constant = 154;
            self.headerView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH * 0.66 + 180 + 12 + 290 + 12 + 130 + 12 + 250 + 12 + 50);
        }
    } else {
        _supportingFacilitiesView.hidden = YES;
        if (arc4random() % 2 ) {
            self.sellInfoView.hidden = NO;
            self.sellInfoConstraint.constant = 12;
            self.xiaoquInfoConstraint.constant = 324;
            self.headerView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH * 0.66 + 180 + 12 + 290 + 12 + 300 + 12 + 250 + 12 + 50);
        } else {
            self.sellInfoView.hidden = YES;
            self.xiaoquInfoConstraint.constant = 12;
            self.headerView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH * 0.66 + 180 + 12 + 290 + 12 + 250 + 12 + 50);
        }
    }
    [self.tableView setTableHeaderView:self.headerView];
}
- (void)loadHouseDetailData {
    __weak typeof(self) weakSelf = self;
    NSString *url ;
    if (self.type == type_zufang) {
        url = @"https://ksir.tech/you/frontend/web/app/zufang/item-info";
    } else {
        url = @"https://ksir.tech/you/frontend/web/app/ershou/item-info";
    }
    [[NetworkTool sharedTool] requestWithURLString:url parameters:@{@"site_id":self.site_id,@"uid":self.uid} method:GET callBack:^(id responseObject) {
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
    if (self.type == type_zufang) {
       self.shoujiaOrjunjiaLabel.text = @"租金";
        NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元/月",self.houseModel.rent]];
        [mStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange([[self.houseModel.rent stringValue] length], 3)];
        self.housePriceLabel.attributedText = mStr;
        
        NSMutableAttributedString *averagePriceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"方式:%@",@"整租"]];
        [averagePriceStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"BABABA"] range:NSMakeRange(0, 3)];
        self.averagePriceLabel.attributedText = averagePriceStr;
    } else {
       self.shoujiaOrjunjiaLabel.text = @"售价";
        NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@万",self.houseModel.total_price]];
        [mStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange([[self.houseModel.total_price stringValue] length], 1)];
        self.housePriceLabel.attributedText = mStr;
        NSMutableAttributedString *averagePriceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"均价:%@元/平",self.houseModel.unit_price]];
        [averagePriceStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"BABABA"] range:NSMakeRange(0, 3)];
        self.averagePriceLabel.attributedText = averagePriceStr;
    }
    self.houseDescriptionLabel.text = self.houseModel.title;
    self.sketchTimeLabel.text = [NSString stringWithFormat:@"房源上架于%@",[YJDate parseRemoteDataToString:self.houseModel.update_time withFormatterString:@"yyyy-MM-dd"]];
    NSMutableAttributedString *houseApartmentLayoutStr = [[NSMutableAttributedString alloc] initWithString:[[self.houseModel.type componentsSeparatedByString:@" "] firstObject]];
    
    for (int i=0; i<houseApartmentLayoutStr.length / 2; i++) {
        [houseApartmentLayoutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(2*i+1, 1)];
    }
    self.houseApartmentLayoutLabel.attributedText = houseApartmentLayoutStr;
    
    NSMutableAttributedString *houseAreaStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.0f平",[self.houseModel.area floatValue]]];
    [houseAreaStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(houseAreaStr.length-1, 1)];
    self.houseAreaLabel.attributedText = houseAreaStr;
    
    NSMutableAttributedString *floorStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"楼层:%@/%@层",self.houseModel.tour_count,self.houseModel.total_storey]];
    [floorStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"BABABA"] range:NSMakeRange(0, 3)];
    self.floorLabel.attributedText = floorStr;
    
    NSMutableAttributedString *putupTimeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"挂牌:%@",[YJDate parseRemoteDataToString:self.houseModel.update_time withFormatterString:@"yyyy-MM-dd"]]];
    [putupTimeStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"BABABA"] range:NSMakeRange(0, 3)];
    self.putupTimeLabel.attributedText = putupTimeStr;
    
    NSMutableAttributedString *faceDirectionStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"朝向:%@",self.houseModel.toward]];
    [faceDirectionStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"BABABA"] range:NSMakeRange(0, 3)];
    self.faceDirectionLabel.attributedText = faceDirectionStr;
    
    NSMutableAttributedString *repairInfoStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"装修:%@",self.houseModel.decoration]];
    [repairInfoStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"BABABA"] range:NSMakeRange(0, 3)];
    self.repairInfoLabel.attributedText = repairInfoStr;
    
    NSMutableAttributedString *houseTypeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"楼型:%@",self.houseModel.in_storey]];
    [houseTypeStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"BABABA"] range:NSMakeRange(0, 3)];
    self.houseTypeLabel.attributedText = houseTypeStr;
    
    NSMutableAttributedString *completionTimeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"年代:%@",self.houseModel.age]];
    [completionTimeStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"BABABA"] range:NSMakeRange(0, 3)];
    self.completionTimeLabel.attributedText = completionTimeStr;
    
    NSMutableAttributedString *regionStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"区域:%@-%@",self.houseModel.region,self.houseModel.plate]];
    [regionStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"BABABA"] range:NSMakeRange(0, 3)];
    self.regionLabel.attributedText = regionStr;


    
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
