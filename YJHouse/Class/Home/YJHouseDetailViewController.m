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
#import "YJHouseListModel.h"
#import "YJXiaoquDetailModel.h"
#import "YJXiaoQuDetailViewController.h"
#import "YJHouseInfoDetailViewController.h"
#import "YJMapView.h"
#import "YJMapDetailViewController.h"
#import "YJHouseCommentViewController.h"
@interface YJHouseDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *mapContainerView;
@property (nonatomic,strong) YJMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

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

@property (weak, nonatomic) IBOutlet UIImageView *communityImg;

@property (weak, nonatomic) IBOutlet UILabel *communityNameLabel;//小区名称
@property (weak, nonatomic) IBOutlet UILabel *communityAveragePriceLabel;//小区均价
@property (weak, nonatomic) IBOutlet UILabel *stairsRatio;//梯户比
@property (weak, nonatomic) IBOutlet UILabel *sellInfo;

@property (weak, nonatomic) IBOutlet UILabel *communityLocationLabel;//小区位置
@property (weak, nonatomic) IBOutlet UILabel *communityCompletionTimeLabel;//小区年代
@property (weak, nonatomic) IBOutlet UILabel *communityTypeLabel;//小区类型
@property (weak, nonatomic) IBOutlet UILabel *communityInfoLabel;//小区信息
@property (weak, nonatomic) IBOutlet UILabel *manager;
@property (weak, nonatomic) IBOutlet UILabel *managerTel;
@property (weak, nonatomic) IBOutlet UILabel *uid;

@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIButton *toScoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *dislikeBtn;
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sellInfoConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationTonConstraint;

@property (strong, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UITextView *popTextView;

@property (weak, nonatomic) IBOutlet UIView *sellInfoView;
@property (weak, nonatomic) IBOutlet UIView *supportingFacilitiesView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sellInfoViewHeight;

@property (nonatomic,strong) YJHouseDetailModel *houseModel;
@property (nonatomic,strong) YJXiaoquDetailModel *xiaoquDetailModel;

@property (nonatomic,strong) NSMutableArray *recommandList;

@property (nonatomic,strong) NSMutableArray *houseSellInfoAry;

@end

@implementation YJHouseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [YJGIFAnimationView showInView:self.view frame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    self.navigationBar.alpha = 0;
    [self setTitle:@"房源详情"];
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
}
- (void)initWithHeaderView {
    self.houseSellInfoAry= [@[] mutableCopy];
    NSMutableString *introduction = [@"" mutableCopy];
    if (!ISEMPTY(self.houseModel.around)) {
        [introduction appendString:[NSString stringWithFormat:@"        %@",self.houseModel.around]];
        [self.houseSellInfoAry addObject:@{@"content":[NSString stringWithFormat:@"        %@",self.houseModel.around],@"title":@"周边"}];
    }
    if (ISEMPTY(self.houseModel.around)) { //周边配套
        if (!ISEMPTY(self.houseModel.introduction)) {
            [introduction appendString:[NSString stringWithFormat:@"        %@",self.houseModel.introduction]];
            [self.houseSellInfoAry addObject:@{@"content":[NSString stringWithFormat:@"        %@",self.houseModel.introduction],@"title":@"介绍"}];
        }
    } else {
        if (!ISEMPTY(self.houseModel.introduction)) {
            [introduction appendString:[NSString stringWithFormat:@"\n        %@",self.houseModel.introduction]];
            [self.houseSellInfoAry addObject:@{@"content":[NSString stringWithFormat:@"        %@",self.houseModel.introduction],@"title":@"介绍"}];
        }
    }
    if (ISEMPTY(introduction)) {
        if (!ISEMPTY(self.houseModel.point)) {
            [introduction appendString:[NSString stringWithFormat:@"        %@",self.houseModel.point]];
            [self.houseSellInfoAry addObject:@{@"content":[NSString stringWithFormat:@"        %@",self.houseModel.point],@"title":@"卖点"}];
        }
    } else {
        if (!ISEMPTY(self.houseModel.point)) {
            [introduction appendString:[NSString stringWithFormat:@"\n        %@",self.houseModel.point]];
            [self.houseSellInfoAry addObject:@{@"content":[NSString stringWithFormat:@"        %@",self.houseModel.point],@"title":@"卖点"}];
        }
    }
    self.popTextView.text = introduction;
    if (self.score) {
        NSMutableAttributedString *scoreStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f",[self.score floatValue]]];
        [scoreStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:24] range:NSMakeRange(0, [self.score floatValue] >=100.0 ? 3:2)];
        [scoreStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:16] range:NSMakeRange([self.score floatValue] >=100?3:2,2)];
        self.houseScoreLabel.attributedText = scoreStr;
    } else {
        self.houseScoreLabel.hidden = YES;
    }
    if (self.type == type_zufang) {
        _supportingFacilitiesView.hidden = NO;
        NSArray *titleAry = @[@"电视",@"空调",@"冰箱",@"床",@"热水器",@"网络",@"燃气",@"洗衣机"];
        NSArray *selectImgAry = @[@"icon_d_ds_s",@"icon_d_kt_s",@"icon_d_bx_s",@"icon_d_c_s",@"icon_d_rsq_s",@"icon_d_wl_s",@"icon_d_trq_s",@"icon_d_xyj_s"];
        NSArray *notSelectimgAry = @[@"icon_d_ds",@"icon_d_kt",@"icon_d_bx",@"icon_d_c",@"icon_d_rsq",@"icon_d_wl",@"icon_d_trq",@"icon_d_xyj"];
        NSMutableArray * imgAry = [@[] mutableCopy];
        for (int i=0; i<titleAry.count; i++) {
            if ([self.tags containsObject:titleAry[i]]) {
                [imgAry addObject:selectImgAry[i]];
            } else {
                [imgAry addObject:notSelectimgAry[i]];
            }
        }
        for (int i=0; i<8; i++) {
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(16 + ((APP_SCREEN_WIDTH - 32)/ 8.0 *i), 64, (APP_SCREEN_WIDTH - 32)/ 8.0, (APP_SCREEN_WIDTH -32)/ 8.0)];
            imgV.image = [UIImage imageNamed:imgAry[i]];
            [self.supportingFacilitiesView addSubview:imgV];
        }
        
        if (ISEMPTY(introduction)) {
            self.sellInfoView.hidden = YES;
            self.locationTonConstraint.constant = 154;
            self.headerView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH * 0.66 + 180 + 12 + 260 + 12 + 130 + 12 + 200 + 12 + 250 + 12 + 50 + 132);
        } else {
            self.sellInfoView.hidden = NO;
            self.sellInfo.text = introduction;
            self.sellInfoConstraint.constant = 154;
            if ([LJKHelper textHeightFromTextString:introduction width:APP_SCREEN_WIDTH -36.0  fontSize:12] >58) {
                self.locationTonConstraint.constant = 376;
                self.headerView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH * 0.66 + 180 + 12 + 260 + 12 + 130 + 12 + 210 + 12 + 200 + 12 + 250 + 12 + 50 + 132);
            } else {
                UIButton *btn = [self.sellInfoView viewWithTag:1];
                btn.hidden = YES;
                self.locationTonConstraint.constant = 166 +71 +[LJKHelper textHeightFromTextString:introduction width:APP_SCREEN_WIDTH -36.0  fontSize:12] + 12;
                self.sellInfoViewHeight.constant = 71 +[LJKHelper textHeightFromTextString:introduction width:APP_SCREEN_WIDTH -36.0  fontSize:12] + 12;
                self.headerView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH * 0.66 + 180 + 12 + 260 + 12 + 130 + 12 + 71 +[LJKHelper textHeightFromTextString:introduction width:APP_SCREEN_WIDTH -36.0  fontSize:12] + 12 + 12 + 200 + 12 + 250 + 12 + 50 + 132);
            }
        }
    } else {
        _supportingFacilitiesView.hidden = YES;
        if (ISEMPTY(introduction)) {
            self.sellInfoView.hidden = YES;
            self.locationTonConstraint.constant = 12;
            self.headerView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH * 0.66 + 180 + 12 + 260 + 12 + 200 + 12 + 250 + 12 + 50 + 132);
        } else {
            self.sellInfoView.hidden = NO;
            self.sellInfoConstraint.constant = 12;
            self.locationTonConstraint.constant = 234;
            self.sellInfo.text = introduction;
            self.headerView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH * 0.66 + 180 + 12 + 260 + 12 + 210 + 12 + 200 + 12 + 250 + 12 + 50 + 132);
        }
    }
    [self.tableView setTableHeaderView:self.headerView];
}
- (void)loadHouseDetailData {
    __weak typeof(self) weakSelf = self;
    NSString *url ;
    if (self.type == type_zufang) {
        url = [NSString stringWithFormat:@"%@/zufang/item-info",Server_url];
    } else {
        url = [NSString stringWithFormat:@"%@/ershou/item-info",Server_url];
    }
    [[NetworkTool sharedTool] requestWithURLString:url parameters:@{@"site_id":self.site_id,@"id":self.house_id,@"auth_key":[LJKHelper getAuth_key]} method:GET callBack:^(id responseObject) {
        if (!ISEMPTY(responseObject[@"result"])) {
            [YJGIFAnimationView hideInView:self.view];
            if ([responseObject[@"result"][@"evaluate"] intValue] ==0) {
                self.dislikeBtn.selected = NO;
                self.likeBtn.selected = NO;
            } else {
                self.dislikeBtn.selected = YES;
                self.likeBtn.selected = YES;
            }
            if ([responseObject[@"result"][@"favourite"] intValue] == 1) {
                self.collectionBtn.selected = YES;
                [self.collectionBtn setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
            } else {
                self.collectionBtn.selected = NO;
            }
            NSMutableArray *imgAry = [@[] mutableCopy];
            for (int i=0; i<[responseObject[@"result"][@"img"] count]; i++) {
                [imgAry addObject:responseObject[@"result"][@"img"][i][@"url"]];
                if (i == 6) {
                    break;
                }
            }
            weakSelf.houseModel = [MTLJSONAdapter modelOfClass:[YJHouseDetailModel class] fromJSONDictionary:responseObject[@"result"][@"info"] error:nil];
            weakSelf.houseModel.imgAry = imgAry;
            weakSelf.pageControl.numberOfPages = imgAry.count;
            weakSelf.xiaoquDetailModel = [MTLJSONAdapter modelOfClass:[YJXiaoquDetailModel class] fromJSONDictionary:responseObject[@"result"][@"xiaoqu"] error:nil];
            [self initWithHeaderView];
            [self fillData];
            NSArray *houseListAry = responseObject[@"result"][@"recommand"];
            self.recommandList = [@[] mutableCopy];
            for (int i = 0; i<houseListAry.count; i++) {
                YJHouseListModel *model = [MTLJSONAdapter modelOfClass:[YJHouseListModel class] fromJSONDictionary:houseListAry[i] error:nil];
                if (weakSelf.type == type_zufang) {
                    model.zufang = YES;
                }else {
                    model.zufang = NO;
                }
                model.topcut = @"";
                [weakSelf.recommandList addObject:model];
                [weakSelf.tableView reloadData];
            }
        }
    } error:^(NSError *error) {
        [YJGIFAnimationView hideInView:self.view];
        [YJRequestTimeoutUtil showRequestErrorView];
    }];
}
- (void)fillData {
    if (self.houseModel.imgAry.count) {
        self.imgScrollView.contentSize = CGSizeMake(APP_SCREEN_WIDTH *self.houseModel.imgAry.count, 0);
        for (int i=0; i<self.houseModel.imgAry.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH *i, 0, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH *0.66)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.houseModel.imgAry[i]] placeholderImage:[UIImage imageNamed:@"icon_default_large"]];
            [self.imgScrollView addSubview:imageView];
        }
    } else {
        self.imgScrollView.contentSize = CGSizeMake(APP_SCREEN_WIDTH , 0);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH *0.66)];
        imageView.image = [UIImage imageNamed:@"icon_default_large"];
        [self.imgScrollView addSubview:imageView];
    }
    
    if (ISEMPTY(self.houseModel.tags)) {
            if (self.type == type_zufang) {
                for (int i=1; i<3; i++) {
                    UILabel *label = [self.headerView viewWithTag:i];
                    label.hidden = NO;
                    label.text = i == 1?@"随时看房":@"拎包入住";
                }
                for (int i=3; i<=5; i++) {
                    UILabel *label = [self.headerView viewWithTag:i];
                    label.hidden = YES;
                }
            } else {
                UILabel *label = [self.headerView viewWithTag:1];
                label.hidden = NO;
                label.text = @"随时看房";
                for (int i=2; i<=5; i++) {
                    UILabel *label = [self.headerView viewWithTag:i];
                    label.hidden = YES;
                }
            }
    } else {
        NSArray *tagsAry = [self.houseModel.tags componentsSeparatedByString:@";"];
        for (int i=1; i<=5; i++) {
            UILabel *label = [self.headerView viewWithTag:i];
            if (i<=tagsAry.count) {
                label.text = [NSString stringWithFormat:@" %@ ",tagsAry[i-1]];
                label.hidden = NO;
            } else {
                label.hidden = YES;
            }
        }
    }
    self.sourceLabel.text = [NSString stringWithFormat:@"    房源:%@",self.houseModel.site_name];
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
    self.sketchTimeLabel.text = [NSString stringWithFormat:@"房源更新于%@",[YJDate parseRemoteDataToString:self.houseModel.update_time withFormatterString:@"yyyy-MM-dd"]];
    NSMutableAttributedString *houseApartmentLayoutStr = [[NSMutableAttributedString alloc] initWithString:[[self.houseModel.type componentsSeparatedByString:@" "] firstObject]];
    
    for (int i=0; i<houseApartmentLayoutStr.length / 2; i++) {
        [houseApartmentLayoutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(2*i+1, 1)];
    }
    self.houseApartmentLayoutLabel.attributedText = houseApartmentLayoutStr;
    
    NSMutableAttributedString *houseAreaStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d平",[self.houseModel.area intValue]]];
    [houseAreaStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(houseAreaStr.length-1, 1)];
    self.houseAreaLabel.attributedText = houseAreaStr;
    
    NSMutableAttributedString *floorStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"楼层:%@/%@",self.houseModel.tour_count,self.houseModel.total_storey]];
    [floorStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"BABABA"] range:NSMakeRange(0, 3)];
    self.floorLabel.attributedText = floorStr;
    
    NSMutableAttributedString *putupTimeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"挂牌:%@",ISEMPTY(self.houseModel.first_time)?@"暂无":[YJDate parseRemoteDataToString:self.houseModel.first_time withFormatterString:@"yyyy-MM-dd"]]];
    [putupTimeStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"BABABA"] range:NSMakeRange(0, 3)];
    self.putupTimeLabel.attributedText = putupTimeStr;
    
    NSMutableAttributedString *faceDirectionStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"朝向:%@",self.houseModel.toward]];
    [faceDirectionStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"BABABA"] range:NSMakeRange(0, 3)];
    self.faceDirectionLabel.attributedText = faceDirectionStr;
    
    NSMutableAttributedString *repairInfoStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"装修:%@",ISEMPTY(self.houseModel.decoration)?@"暂无":self.houseModel.decoration]];
    [repairInfoStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"BABABA"] range:NSMakeRange(0, 3)];
    self.repairInfoLabel.attributedText = repairInfoStr;
    
    NSMutableAttributedString *houseTypeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"楼型:%@",ISEMPTY(self.houseModel.in_storey)?@"暂无":self.houseModel.in_storey]];
    [houseTypeStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"BABABA"] range:NSMakeRange(0, 3)];
    self.houseTypeLabel.attributedText = houseTypeStr;
    
    NSMutableAttributedString *completionTimeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"年代:%@",ISEMPTY(self.houseModel.age)?@"暂无":self.houseModel.age]];
    [completionTimeStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"BABABA"] range:NSMakeRange(0, 3)];
    self.completionTimeLabel.attributedText = completionTimeStr;
    
    NSMutableAttributedString *regionStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"区域:%@-%@",self.houseModel.region,self.houseModel.plate]];
    [regionStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"BABABA"] range:NSMakeRange(0, 3)];
    self.regionLabel.attributedText = regionStr;
    
    NSMutableAttributedString *stairsRatioStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"梯户比:%@",ISEMPTY(self.houseModel.stairs_ratio)?@"暂无":self.houseModel.stairs_ratio]];
    [stairsRatioStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"BABABA"] range:NSMakeRange(0, 4)];
    self.stairsRatio.attributedText = stairsRatioStr;
    
    NSMutableAttributedString *managerStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"经纪人:%@",ISEMPTY(self.houseModel.manager)?@"暂无":self.houseModel.manager]];
    [managerStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"BABABA"] range:NSMakeRange(0, 4)];
    self.manager.attributedText = managerStr;
    
    NSMutableAttributedString *managerTelStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"联系电话:%@",ISEMPTY(self.houseModel.manager_tel)?@"暂无":self.houseModel.manager_tel]];
    [managerTelStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"BABABA"] range:NSMakeRange(0, 5)];
    self.managerTel.attributedText = managerTelStr;
    if (!ISEMPTY(self.houseModel.manager_tel)) {
        UITapGestureRecognizer *callTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callTap)];
        self.managerTel.userInteractionEnabled = YES;
        [self.managerTel addGestureRecognizer:callTap];
    }
    NSMutableAttributedString *uidStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"房源编号:%@",ISEMPTY(self.houseModel.uid)?@"暂无":self.houseModel.uid]];
    [uidStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"BABABA"] range:NSMakeRange(0, 5)];
    self.uid.attributedText = uidStr;
    if (!ISEMPTY(self.houseModel.uid)) {
        UILongPressGestureRecognizer *houseIdTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(copyHouseCode)];
        houseIdTap.minimumPressDuration = 1;
        self.uid.userInteractionEnabled = YES;
        [self.uid addGestureRecognizer:houseIdTap];
    }
    self.addressLabel.text = [NSString stringWithFormat:@"      地址:%@-%@-%@",self.houseModel.region,self.houseModel.plate,self.xiaoquDetailModel.address];
    self.mapView = [[YJMapView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 200)];
    [self.mapContainerView addSubview:self.mapView];
    [self.mapContainerView sendSubviewToBack:self.mapView];
    UIControl *mapSender = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 200)];
    mapSender.backgroundColor = [UIColor clearColor];
    [mapSender addTarget:self action:@selector(mapClick) forControlEvents:UIControlEventTouchUpInside];
    [self.mapContainerView addSubview:mapSender];
    NSString *address = [NSString stringWithFormat:@"http://restapi.amap.com/v3/geocode/geo?key=389880a06e3f893ea46036f030c94700&s=rsv3&city=35&address=浙江省杭州市%@%@%@",self.houseModel.region,self.houseModel.plate,self.xiaoquDetailModel.address];
    NSString* encodedString = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak typeof(self)weakSelf = self;
    [[NetworkTool sharedTool]requestWithURLString:encodedString parameters:nil method:GET callBack:^(id responseObject) {
        if (!ISEMPTY(responseObject[@"geocodes"])) {
            NSArray *ary = [responseObject[@"geocodes"][0][@"location"] componentsSeparatedByString:@","];
            [weakSelf.mapView showLongitude:[ary[0] floatValue ]andLatitude:[ary[1] floatValue]];
        }
    } error:^(NSError *error) {
    }];
    
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%@",self.houseModel.good] forState:UIControlStateNormal];
    [self.dislikeBtn setTitle:[NSString stringWithFormat:@"%@",self.houseModel.bad] forState:UIControlStateNormal];
    [self.collectionBtn setTitle:[NSString stringWithFormat:@" %@",self.houseModel.favourite_count] forState:UIControlStateNormal];
    CGFloat total = ([self.houseModel.good floatValue] + [self.houseModel.bad floatValue]);
    CGFloat ratio = [self.houseModel.good floatValue] / (total == 0 ?1:total) * 100;
    [self.toScoreBtn setTitle:[NSString stringWithFormat:@" %.0f%%",ratio] forState:UIControlStateNormal];
    //小区信息
    [self.communityImg sd_setImageWithURL:[NSURL URLWithString:self.xiaoquDetailModel.main_img] placeholderImage:[UIImage imageNamed:@"icon_placeholder"]];
    self.communityNameLabel.text = self.xiaoquDetailModel.name;
    self.communityAveragePriceLabel.text = [NSString stringWithFormat:@"%@元/平",self.xiaoquDetailModel.avg_price];
    self.communityLocationLabel.text = self.xiaoquDetailModel.region;
    self.communityCompletionTimeLabel.text = [NSString stringWithFormat:@"年代:%@",[YJDate parseRemoteDataToString:self.xiaoquDetailModel.age withFormatterString:@"yyyy"]];
    self.communityTypeLabel.text = [NSString stringWithFormat:@"类型:%@",self.xiaoquDetailModel.property_type];
    NSMutableString *des = [@"" mutableCopy];
    [des appendString:@"附近有"];
    if ([self.xiaoquDetailModel.shop_count intValue]) {
        [des appendString:[NSString stringWithFormat:@"大型超市%@个 ",self.xiaoquDetailModel.shop_count]];
    }
    if ([self.xiaoquDetailModel.bus_stop_count integerValue]) {
        [des appendString:[NSString stringWithFormat:@"公交站牌%@个 ",self.xiaoquDetailModel.bus_stop_count]];
    }
    if ([self.xiaoquDetailModel.school_count integerValue]) {
        [des appendString:[NSString stringWithFormat:@"学校%@所 ",self.xiaoquDetailModel.school_count]];
    }
    if ([self.xiaoquDetailModel.hospital_count integerValue]) {
        [des appendString:[NSString stringWithFormat:@"医院%@个 ",self.xiaoquDetailModel.hospital_count]];
    }
    if ([self.xiaoquDetailModel.green_rate integerValue]) {
        [des appendString:[NSString stringWithFormat:@"绿化率达%@%% ",self.xiaoquDetailModel.green_rate]];
    }
    if ([des isEqualToString:@"附近有"]) {
        des = [NSMutableString stringWithString:@"暂无小区信息"];
    }
    self.communityInfoLabel.text = des;
}
- (void)mapClick {
    YJMapDetailViewController *vc = [[YJMapDetailViewController alloc] init];
    vc.address = [NSString stringWithFormat:@"%@%@%@",self.houseModel.region,self.houseModel.plate,self.xiaoquDetailModel.address];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recommandList.count;
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
    [cell showDataWithModel:self.recommandList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YJHouseListModel *model = self.recommandList[indexPath.row];
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
- (void)copyHouseCode {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.houseModel.uid;
    [YJApplicationUtil alertHud:@"房源编号复制成功" afterDelay:1];
}

- (void)callTap {
    // 处理电话号码
    NSString* sOriginPhoneNum = [NSString stringWithFormat:@"%@",self.houseModel.manager_tel]; // 中文分隔符－，导致无法拨打电话
    NSMutableCharacterSet *charSet = [[NSMutableCharacterSet alloc] init];
    [charSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    [charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
    [charSet formUnionWithCharacterSet:[NSCharacterSet symbolCharacterSet]];
    NSArray *arrayWithNumbers = [sOriginPhoneNum componentsSeparatedByCharactersInSet:charSet];
    NSString *numberStr = [arrayWithNumbers componentsJoinedByString:@""];
    if (! numberStr) {
        numberStr = @"";
    }
    NSString *url = [NSString stringWithFormat:@"tel:%@", numberStr];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
#pragma mark - IBActions
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)reportAction:(id)sender { //举报
    YJReportAndFeedbackViewController *vc = [[YJReportAndFeedbackViewController alloc] init];
    vc.siteId = self.site_id;
    vc.ID = self.house_id;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)moreFetureAction:(id)sender {//更多特色
    YJHouseInfoDetailViewController *vc= [[YJHouseInfoDetailViewController alloc] init];
    vc.infoAry = self.houseSellInfoAry;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)villageInfoAction:(id)sender {//小区信息
    YJXiaoQuDetailViewController *vc = [[YJXiaoQuDetailViewController alloc] init];
    vc.xiaoquId = self.xiaoquDetailModel.xiaoquId;
    PushController(vc);
}
- (IBAction)toSelectAction:(id)sender {
    [UIView animateWithDuration:0.4 animations:^{
        self.selectView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH - 160.0, 46);
        self.showView.frame = CGRectMake(0, 46, APP_SCREEN_WIDTH - 160, 46);
    } completion:^(BOOL finished) {
    }];
}
- (IBAction)collectionAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    NSString *url;
    NSDictionary *params = @{@"auth_key":[LJKHelper getAuth_key],@"site":self.site_id,@"id":self.house_id};
    if (self.collectionBtn.selected) {
        url = [NSString stringWithFormat:@"%@/user/cancel-favourite",Server_url];
    } else {
        url = [NSString stringWithFormat:@"%@/user/set-favourite",Server_url];
    }
    [[NetworkTool sharedTool] requestWithURLString:url parameters:params method:POST callBack:^(id responseObject) {
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                if (weakSelf.collectionBtn.selected) {
                    [weakSelf.collectionBtn setImage:[UIImage imageNamed:@"icon_dislike"] forState:UIControlStateNormal];
                    [weakSelf.collectionBtn setTitle:[NSString stringWithFormat:@" %d",[weakSelf.collectionBtn.titleLabel.text intValue] - 1] forState:UIControlStateNormal];
                } else {
                    [weakSelf.collectionBtn setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
                    [weakSelf.collectionBtn setTitle:[NSString stringWithFormat:@" %d",[weakSelf.collectionBtn.titleLabel.text intValue] + 1] forState:UIControlStateNormal];
                }
                weakSelf.collectionBtn.selected = !self.collectionBtn.selected;
            }
    } error:^(NSError *error) {
    }];
}
- (IBAction)shareAction:(id)sender {
    [self shareFriendWithImg:[LJKHelper imageFromView:self.view]];
}
-(void)shareFriendWithImg:(UIImage *)shareImg {
    UIActivityViewController *activityViewController =[[UIActivityViewController alloc] initWithActivityItems:@[shareImg] applicationActivities:nil];
    //去除多余的分享模块
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypePrint,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeOpenInIBooks];
    //初始化Block回调方法,此回调方法是在iOS8之后出的，代替了之前的方法
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
    {
        if (completed) {
            [YJApplicationUtil alertHud:@"分享成功" afterDelay:1];
        }
    };
    activityViewController.completionWithItemsHandler = myBlock;
    if (activityViewController) {
        [self presentViewController:activityViewController animated:TRUE completion:^{
        }];
    }
}
- (IBAction)likeAction:(id)sender {
    UIView *bottonView = [self.view viewWithTag:10];
    [UIView animateWithDuration:0.4 animations:^{
        self.selectView.frame = CGRectMake(0, 46, APP_SCREEN_WIDTH - 160.0, 46);
        self.showView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH - 160, 46);
    } completion:^(BOOL finished) {
        [bottonView bringSubviewToFront:self.selectView];
    }];
    [bottonView bringSubviewToFront:self.showView];
    if (self.dislikeBtn.selected || self.likeBtn.selected) {
        [YJApplicationUtil alertHud:@"已打过分" afterDelay:1];
        return;
    }
    NSDictionary *params = @{@"auth_key":[LJKHelper getAuth_key],@"id":self.house_id,@"site":self.site_id,@"eva":@"1"};
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/set-evaluate",Server_url] parameters:params method:POST callBack:^(id responseObject) {
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            [self.likeBtn setTitle:[NSString stringWithFormat:@" %d",[self.likeBtn.titleLabel.text intValue] +1] forState:UIControlStateNormal];
            [self.toScoreBtn setTitle:[NSString stringWithFormat:@" %.0f%%",([self.likeBtn.titleLabel.text floatValue] / ([self.dislikeBtn.titleLabel.text floatValue] +[self.likeBtn.titleLabel.text floatValue])) * 100] forState:UIControlStateNormal];
            self.likeBtn.selected = YES;
        }
    } error:^(NSError *error) {
        
    }];
}

- (IBAction)dislikeAction:(id)sender {
    UIView *bottonView = [self.view viewWithTag:10];
    [bottonView bringSubviewToFront:self.showView];
    [UIView animateWithDuration:0.4 animations:^{
        self.selectView.frame = CGRectMake(0, 46, APP_SCREEN_WIDTH - 160.0, 46);
        self.showView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH - 160, 46);
    } completion:^(BOOL finished) {
        [bottonView bringSubviewToFront:self.selectView];
    }];
    if (self.dislikeBtn.selected ||self.likeBtn.selected) {
        [YJApplicationUtil alertHud:@"已打过分" afterDelay:1];
        return;
    }
    NSDictionary *params = @{@"auth_key":[LJKHelper getAuth_key],@"id":self.house_id,@"site":self.site_id,@"eva":@"-1"};
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/set-evaluate",Server_url] parameters:params method:POST callBack:^(id responseObject) {
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            [self.dislikeBtn setTitle:[NSString stringWithFormat:@"  %d",[self.dislikeBtn.titleLabel.text intValue] +1] forState:UIControlStateNormal];
            [self.toScoreBtn setTitle:[NSString stringWithFormat:@"  %.0f%%",([self.likeBtn.titleLabel.text floatValue] / ([self.dislikeBtn.titleLabel.text floatValue] +[self.likeBtn.titleLabel.text floatValue])) * 100] forState:UIControlStateNormal];
            self.dislikeBtn.selected = YES;
        }
    } error:^(NSError *error) {
        
    }];
}
- (IBAction)commentAction:(id)sender {
    YJHouseCommentViewController *vc = [[YJHouseCommentViewController alloc] init];
    vc.house_id = self.house_id;
    vc.site_id = self.site_id;
    PushController(vc);
}

- (IBAction)openUrl:(id)sender {
    YJWebViewController *vc = [[YJWebViewController alloc] init];
    vc.url = self.houseModel.page;
    PushController(vc);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.imgScrollView) {
        self.pageControl.currentPage = self.imgScrollView.contentOffset.x / APP_SCREEN_WIDTH;
    } else {
        self.navigationBar.alpha = (scrollView.contentOffset.y - 64) / 64.0;
    }
}
@end
