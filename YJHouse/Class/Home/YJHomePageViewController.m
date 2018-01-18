//
//  YJHomePageViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/17.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJHomePageViewController.h"
#import "YJHomePageViewCell.h"
#import "KLCPopup.h"
#import "YJSearchViewController.h"
#import "YJHouseDetailViewController.h"
#import "YJXiaoQuListViewController.h"
#import "YJLowPriceViewController.h"
#import "YJAddressView.h"
#import "YJPriceView.h"
#import "YJSortView.h"
#import "YJMFMoreView.h"
#import "YJZFMoreView.h"
#import "YJHouseListModel.h"
#import "YJSecondStepViewController.h"
#import "YJMapViewController.h"
#import "YJHouseInformationViewController.h"
#define kCellIdentifier @"YJHomePageViewCell"
static NSString *const kReloadHomeDataNotif = @"kReloadHomeDataNotif";
static NSString *const houseTypeKey = @"houseTypeKey";
@interface YJHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,YJAddressClickDelegate,YJSortDelegate,YJPriceSortDelegate,YJMFSortDelegate,YJZFSortDelegate,YJRequestTimeoutDelegate>
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (nonatomic,assign) BOOL zufang;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet KLCPopup *popupView;
@property (nonatomic,strong)KLCPopup *klcManager;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (nonatomic,strong) YJAddressView *addressView;
@property (nonatomic,strong) YJPriceView *priceView;
@property (nonatomic,strong) YJSortView *sortView;
@property (nonatomic,strong) YJMFMoreView *mfMoreView;
@property (nonatomic,strong) YJZFMoreView *zfMoreView;
@property (nonatomic,assign) NSInteger homePage;
@property (nonatomic,strong) NSMutableArray *homeHouseAry;
@property (nonatomic,copy) NSString *regionID;
@property (nonatomic,copy) NSString *plateID;
@property (nonatomic,copy) NSString *sortKey;
@property (nonatomic,copy) NSString *sortValue;
@property (nonatomic,copy) NSString *minPrice;
@property (nonatomic,copy) NSString *maxPrice;
@property (nonatomic,strong) NSDictionary *mfParams;
@property (nonatomic,assign) NSInteger sortTapLastTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHeightLayout;
@property (weak, nonatomic) IBOutlet UIScrollView *houseInfoSV;
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation YJHomePageViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (YJPriceView *)priceView {
    if (!_priceView) {
        _priceView = [[YJPriceView alloc] initWithFrame:CGRectMake(0, KIsiPhoneX?126:100, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - (KIsiPhoneX?126:100) - 49)];
        _priceView.hidden = YES;
        _priceView.delegate = self;
        _priceView.houseType = houseBuy;
        [self.view addSubview:_priceView];
    }
    return _priceView;
}
- (YJAddressView *)addressView {
    if (!_addressView) {
        _addressView = [[YJAddressView alloc] initWithFrame:CGRectMake(0, KIsiPhoneX?126:100, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - (KIsiPhoneX?126:100) - 49)];
        _addressView.delegate = self;
        _addressView.hidden = YES;
        [self.view addSubview:_addressView];
    }
    return _addressView;
}
- (YJSortView *)sortView {
    if (!_sortView) {
        _sortView = [[YJSortView alloc] initWithFrame:CGRectMake(0, KIsiPhoneX?126:100, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - (KIsiPhoneX?126:100) - 49)];
        _sortView.hidden = YES;
        _sortView.delegate = self;
        _sortView.sortType = houseType;
        [self.view addSubview:_sortView];
    }
    return _sortView;
}
- (YJMFMoreView *)mfMoreView {
    if (!_mfMoreView) {
        _mfMoreView = [[YJMFMoreView alloc] initWithFrame:CGRectMake(0, KIsiPhoneX?126:100, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - (KIsiPhoneX?126:100) - 49)];
        _mfMoreView.hidden = YES;
        _mfMoreView.delegate = self;
        [self.view addSubview:_mfMoreView];
    }
    return _mfMoreView;
}
- (YJZFMoreView *)zfMoreView {
    if (!_zfMoreView) {
        _zfMoreView = [[YJZFMoreView alloc] initWithFrame:CGRectMake(0, KIsiPhoneX?126:100, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - (KIsiPhoneX?126:100) - 49)];
        _zfMoreView.hidden = YES;
        _zfMoreView.delegate = self;
        [self.view addSubview:_zfMoreView];
    }
    return _zfMoreView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMsgCount];
    [YJRequestTimeoutUtil shareInstance].delegate = self;
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    self.navigationBar.hidden = YES;
    self.navHeightLayout.constant = KIsiPhoneX?88:64;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHomeData) name:kReloadHomeDataNotif object:nil];
    [self registerTableView];
    self.sortTapLastTime = 51;
    [self.view bringSubviewToFront:self.topView];
    [self registerRefresh];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:houseTypeKey] intValue]) {
        self.zufang = YES;
        self.priceView.houseType = houseRent;
        [self initWithBtnWithType:1];
    } else {
        self.zufang = NO;
        self.priceView.houseType = houseBuy;
        [self initWithBtnWithType:0];
    }
    [self loadHomeData];
    [self loadHouseInfo];
}
- (void)loadHouseInfo {
    __weak typeof(self) weakSelf = self;
    NSDictionary *params = @{@"type":@(1),@"page":@(0)};
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/news/list",Server_url] parameters:params method:GET callBack:^(id responseObject) {
        if (!ISEMPTY(responseObject[@"result"])) {
            NSArray *ary = responseObject[@"result"];
            weakSelf.houseInfoSV.contentSize = CGSizeMake(self.houseInfoSV.frame.size.width, 44*((ary.count)>6?6:ary.count));
            for (int i=0; i<((ary.count)>6?6:ary.count); i++) {
                UILabel *label = [[UILabel alloc] init];
                label.text = [NSString stringWithFormat:@"%@",ary[i][@"title"]];
                label.textColor = [UIColor ex_colorFromHexRGB:@"212121"];
                label.frame = CGRectMake(0, 44*i, weakSelf.houseInfoSV.frame.size.width, 44);
                label.font = [UIFont systemFontOfSize:14];
                [weakSelf.houseInfoSV addSubview:label];
            }
            [weakSelf setGCDTimerWithCount:((ary.count)>6?6:ary.count)];
        }
    } error:^(NSError *error) {
        
    }];
}
- (void)setGCDTimerWithCount:(NSUInteger)msgCount {
    __block int count = -1;
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(3.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    __block float dur = 0.2;
    dispatch_source_set_event_handler(self.timer, ^{
        count ++;
        if (count == 0) {
            dur = 0;
        } else {
            dur = 0.2;
        }
        [UIView animateWithDuration:dur animations:^{
            self.houseInfoSV.contentOffset = CGPointMake(0, 44*count);
            if (count >=msgCount-1) {
                count = -1;
            }
        }];
    });
    dispatch_resume(self.timer);
}
#pragma mark -YJRequestTimeoutDelegate 
- (void)requestTimeoutAction {
    if (self.isVisible) {
        [self loadHomeData];
    }
}
- (void)loadMsgCount {
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/get-message-count",Server_url] parameters:@{@"time":ISEMPTY([LJKHelper getLastRequestMsgTime])?@"0":[LJKHelper getLastRequestMsgTime],@"auth_key":[LJKHelper getAuth_key]} method:POST callBack:^(id responseObject) {
        if (ISEMPTY(responseObject[@"error"])) {
            if ([responseObject[@"result"][@"total_count"] intValue]) {
                [self.tabBarController.tabBar showBadgeOnItemIndex:2];
            } else {
                [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
            }
        }
    } error:^(NSError *error) {
    }];
}
- (void)reloadHomeData {
    self.mfParams = nil;
    self.sortKey = @"";
    self.regionID = @"";
    self.maxPrice = 0;
    [self.mfMoreView initWithMFBtn];
    [self.zfMoreView initWithZFBtn];
    [self.addressView refreshTabelView];
    [self.sortView initWithSortBtn];
    [self initWithSortBtn];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:houseTypeKey] intValue]) {
        self.zufang = YES;
        self.priceView.houseType = houseRent;
        [self initWithBtnWithType:1];
    } else {
        self.zufang = NO;
        self.priceView.houseType = houseBuy;
        [self initWithBtnWithType:0];
    }
    [self.tableView.mj_header beginRefreshing];
}
- (void)initWithBtnWithType:(NSInteger)type {
    UIButton *typeBtn = [self.view viewWithTag:103];
    UIButton *btn1 = [self.popupView viewWithTag:101];
    UIButton *btn2 = [self.popupView viewWithTag:102];
    if (type == 1) {
        [typeBtn setTitle:@"租房" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"3F3F3F"] forState:UIControlStateNormal];
    } else {
        [typeBtn setTitle:@"买房" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"3F3F3F"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (void)registerRefresh {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.homePage = 0;
        [weakSelf loadHomeData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.homePage ++;
        [weakSelf loadHomeData];
    }];
}
- (void)registerTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    self.headerView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH *0.66 + 150 +46 +50);
    [self.tableView setTableHeaderView:self.headerView];
    self.navView.backgroundColor = [[UIColor ex_colorFromHexRGB:@"FF0000"] colorWithAlphaComponent:0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.homePage = 0;
    self.homeHouseAry = [@[] mutableCopy];
}

- (void)loadHomeData {
    __weak typeof(self)weakSelf = self;
    NSMutableDictionary *params = [@{} mutableCopy];
    [params setValue:[LJKHelper getAuth_key] forKey:@"auth_key"];
    [params setValue:@(self.homePage) forKey:@"page"];
    if (self.regionID.length > 1) {
        if (self.plateID.length > 1) {
            [params setValue:self.plateID forKey:@"plate_id[0]"];
        }
        [params setValue:self.regionID forKey:@"region_id[0]"];
    }
    if (self.sortKey.length) {
        [params setValue:self.sortValue forKey:self.sortKey];
    }
    if (!ISEMPTY(self.maxPrice)) {
        if ([self.maxPrice intValue] < 0) {
            [params setObject:[NSString stringWithFormat:@"%@",self.maxPrice] forKey:@"price[0]"];
        } else {
            [params setObject:[NSString stringWithFormat:@"%ld-%ld",[self.minPrice integerValue],[self.maxPrice integerValue]] forKey:@"price[0]"];
        }
    }
    if (!ISEMPTY(self.mfParams)) {
        [params setValuesForKeysWithDictionary:self.mfParams];
    }
    NSString *url;
    if (self.zufang) {
        url = [NSString stringWithFormat:@"%@/zufang/custom-list",Server_url];
        if (!ISEMPTY([LJKHelper getZufangWeight_id])) {
            [params setObject:[LJKHelper getZufangWeight_id] forKey:@"weight_id"];
        }
    } else {
        url = [NSString stringWithFormat:@"%@/ershou/custom-list",Server_url];
        if (!ISEMPTY([LJKHelper getErshouWeight_id])) {
            [params setObject:[LJKHelper getErshouWeight_id] forKey:@"weight_id"];
        }
    }
    [[NetworkTool sharedTool] requestWithURLString:url parameters:params method:GET callBack:^(id responseObject) {
        if (weakSelf.homePage == 0) {
            [weakSelf.homeHouseAry removeAllObjects];
            [weakSelf.tableView.mj_header endRefreshing];
            [SVProgressHUD dismiss];
        }
        NSArray *ary = responseObject[@"result"];
        for (int i = 0; i<ary.count; i++) {
            YJHouseListModel *model = [MTLJSONAdapter modelOfClass:[YJHouseListModel class] fromJSONDictionary:ary[i] error:nil];
            model.zufang = weakSelf.zufang;
            model.topcut = @"";
            [weakSelf.homeHouseAry addObject:model];
        }
        if (ary.count<20) {
            weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        [weakSelf.tableView reloadData];
    } error:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeHouseAry.count ? self.homeHouseAry.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.homeHouseAry.count ? 97 : APP_SCREEN_WIDTH / 3.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.homeHouseAry.count) {
        static NSString *cellId = @"cellId";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH / 3.0, 0, APP_SCREEN_WIDTH / 3.0, APP_SCREEN_WIDTH / 3.0)];
        img.image = [UIImage imageNamed:@"icon_search_placeholder"];
        [cell addSubview:img];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, APP_SCREEN_WIDTH / 3.0, APP_SCREEN_WIDTH, 12)];
        label.text = @"暂无匹配房源";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor ex_colorFromHexRGB:@"8A8A8A"];
        label.font = [UIFont systemFontOfSize:14];
        [cell addSubview:label];
        return cell;
    } else {
        YJHomePageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showDataWithModel:self.homeHouseAry[indexPath.row]];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.homeHouseAry.count) {
        return;
    }
    YJHouseListModel *model = self.homeHouseAry[indexPath.row];
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
#pragma mark - IBActions
- (IBAction)scanTypeAction:(id)sender {
    self.klcManager = [KLCPopup popupWithContentView:self.popupView];
    [self.klcManager showAtCenter:CGPointMake(40, KIsiPhoneX?126:100) inView:self.view];
}
- (IBAction)mapAction:(id)sender {
//    YJMapViewController *vc =[[YJMapViewController alloc] init];
//    PushController(vc);
}


- (IBAction)selectType:(id)sender {
    self.mfParams = nil;
    self.sortKey = @"";
    self.regionID = @"";
    self.maxPrice = 0;
    self.priceView.hidden = YES;
    self.addressView.hidden = YES;
    self.sortView.hidden = YES;
    self.zfMoreView.hidden = YES;
    self.mfMoreView.hidden = YES;
    UIButton *lastBtn = [self.view viewWithTag:self.sortTapLastTime];
    UIButton *lastBtn1 = [self.view viewWithTag:self.sortTapLastTime+4];
    [UIView animateWithDuration:0.2 animations:^{
        lastBtn.imageView.transform = CGAffineTransformMakeRotation(0);
        lastBtn1.imageView.transform = CGAffineTransformMakeRotation(0);
    }];
    [self.mfMoreView initWithMFBtn];
    [self.zfMoreView initWithZFBtn];
    [self.addressView refreshTabelView];
    [self.sortView initWithSortBtn];
    [self.klcManager dismiss:YES];
    UIButton *selectBtn = sender;
    UIButton *typeBtn = [self.view viewWithTag:103];
    if (selectBtn.tag == 101) {
        if ([typeBtn.titleLabel.text isEqualToString:@"租房"]) {
            return;
        }
        if (!ISEMPTY([LJKHelper getZufangWeight_id])) {
            [selectBtn setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
            [typeBtn setTitle:@"租房" forState:UIControlStateNormal];
            UIButton *btn = [self.popupView viewWithTag:102];
            [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"3F3F3F"] forState:UIControlStateNormal];
            self.zufang = YES;
            self.priceView.houseType = houseRent;
            [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:houseTypeKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            YJSecondStepViewController *vc = [[YJSecondStepViewController alloc] init];
            vc.registerModel = [[YJRegisterModel alloc] init];
            vc.registerModel.zufang = YES;
            vc.showBackBtn = YES;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
            return;
        }

    } else if (selectBtn.tag == 102){
        if ([typeBtn.titleLabel.text  isEqualToString:@"买房"]) {
            [self.klcManager dismiss:YES];
            return;
        }
        if (!ISEMPTY([LJKHelper getErshouWeight_id])) {
            [selectBtn setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
            [typeBtn setTitle:@"买房" forState:UIControlStateNormal];
            UIButton *btn = (UIButton *)[self.popupView viewWithTag:101];
            [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"3F3F3F"] forState:UIControlStateNormal];
            self.zufang = NO;
            self.priceView.houseType = houseBuy;
            [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:houseTypeKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            YJSecondStepViewController *vc = [[YJSecondStepViewController alloc] init];
            vc.showBackBtn = YES;
            vc.registerModel = [[YJRegisterModel alloc] init];
            vc.registerModel.zufang = NO;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
            return;
        }
    }
    [self initWithSortBtn];
    self.homePage = 0;
    [SVProgressHUD show];
    [self loadHomeData];
}
- (void)initWithSortBtn {
    UIButton *btn51 = [self.view viewWithTag:51];
    UIButton *btn55 = [self.view viewWithTag:55];
    [btn51 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
    [btn55 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
    UIButton *btn52 = [self.view viewWithTag:52];
    UIButton *btn56 = [self.view viewWithTag:56];
    [btn52 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
    [btn56 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
    UIButton *btn53 = [self.view viewWithTag:53];
    UIButton *btn57 = [self.view viewWithTag:57];
    [btn53 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
    [btn57 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
    UIButton *btn54 = [self.view viewWithTag:54];
    UIButton *btn58 = [self.view viewWithTag:58];
    [btn54 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
    [btn58 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
}
- (IBAction)searchAction:(id)sender {//搜索
    YJSearchViewController *vc= [[YJSearchViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
//    [self showNewUserTipsView];
}

- (IBAction)sortAction:(id)sender {
    UIButton *lastBtn = [self.view viewWithTag:self.sortTapLastTime];
    UIButton *lastBtn1 = [self.view viewWithTag:self.sortTapLastTime+4];
    switch (self.sortTapLastTime) {
        case 51:
        {
            if (ISEMPTY(self.regionID)) {
                [lastBtn setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
                [lastBtn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
            }
            [UIView animateWithDuration:0.2 animations:^{
                lastBtn.imageView.transform = CGAffineTransformMakeRotation(0);
                lastBtn1.imageView.transform = CGAffineTransformMakeRotation(0);
            }];
        }
            break;
        case 52:
        {
            if (ISEMPTY(self.maxPrice)) {
                [lastBtn setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
                [lastBtn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
            }
            [UIView animateWithDuration:0.2 animations:^{
                lastBtn.imageView.transform = CGAffineTransformMakeRotation(0);
                lastBtn1.imageView.transform = CGAffineTransformMakeRotation(0);
            }];
        }
            break;
        case 53:
        {
            if (ISEMPTY(self.sortKey)) {
                [lastBtn setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
                [lastBtn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
            }
            [UIView animateWithDuration:0.2 animations:^{
                lastBtn.imageView.transform = CGAffineTransformMakeRotation(0);
                lastBtn1.imageView.transform = CGAffineTransformMakeRotation(0);
            }];
        }
            break;
        case 54:
        {
            if (ISEMPTY(self.mfParams)) {
                [lastBtn setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
                [lastBtn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
            }
            [UIView animateWithDuration:0.2 animations:^{
                lastBtn.imageView.transform = CGAffineTransformMakeRotation(0);
                lastBtn1.imageView.transform = CGAffineTransformMakeRotation(0);
            }];
        }
            break;
        default:
            break;
    }
    UIButton *button = sender;
    if (button.tag < 55) {
        [self.tableView setContentOffset:CGPointMake(0, APP_SCREEN_WIDTH *0.66 +150 + + 50 +6 - (KIsiPhoneX?88:64))];
    }
    if (button.tag == 51 || button.tag == 55) {
        UIButton *btn51= [self.view viewWithTag:51];
        UIButton *btn55= [self.view viewWithTag:55];
        self.sortTapLastTime = 51;
        if (self.addressView.hidden == YES) {
            [btn51 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
            [btn55 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.2 animations:^{
                btn51.imageView.transform = CGAffineTransformMakeRotation(M_PI);
                btn55.imageView.transform = CGAffineTransformMakeRotation(M_PI);
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                btn51.imageView.transform = CGAffineTransformMakeRotation(0);
                btn55.imageView.transform = CGAffineTransformMakeRotation(0);
            }];
        }
        self.priceView.hidden = YES;
        self.sortView.hidden = YES;
        self.mfMoreView.hidden = YES;
        self.zfMoreView.hidden = YES;
        self.addressView.hidden = !self.addressView.hidden;
    } else if (button.tag == 52 ||button.tag == 56){
        self.sortTapLastTime = 52;
        UIButton *btn52= [self.view viewWithTag:52];
        UIButton *btn56= [self.view viewWithTag:56];
        if (self.priceView.hidden == YES) {
            [btn52 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
            [btn56 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.2 animations:^{
                btn52.imageView.transform = CGAffineTransformMakeRotation(M_PI);
                btn56.imageView.transform = CGAffineTransformMakeRotation(M_PI);
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                btn52.imageView.transform = CGAffineTransformMakeRotation(0);
                btn56.imageView.transform = CGAffineTransformMakeRotation(0);
            }];
        }
        self.addressView.hidden = YES;
        self.sortView.hidden = YES;
        self.mfMoreView.hidden = YES;
        self.zfMoreView.hidden = YES;
        self.priceView.hidden = !self.priceView.hidden ;
    } else if (button.tag == 53 ||button.tag == 57){
        self.sortTapLastTime = 53;
        UIButton *btn53= [self.view viewWithTag:53];
        UIButton *btn57= [self.view viewWithTag:57];
        if (self.sortView.hidden == YES) {
            [btn53 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
            [btn57 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.2 animations:^{
                btn53.imageView.transform = CGAffineTransformMakeRotation(M_PI);
                btn57.imageView.transform = CGAffineTransformMakeRotation(M_PI);
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                btn53.imageView.transform = CGAffineTransformMakeRotation(0);
                btn57.imageView.transform = CGAffineTransformMakeRotation(0);
            }];
        }
        self.addressView.hidden = YES;
        self.priceView.hidden = YES;
        self.mfMoreView.hidden = YES;
        self.zfMoreView.hidden = YES;
        self.sortView.hidden = !self.sortView.hidden;
    } else if (button.tag == 54 ||button.tag == 58){
        self.sortTapLastTime = 54;
        self.addressView.hidden = YES;
        self.priceView.hidden = YES;
        self.sortView.hidden = YES;
        UIButton *btn = [self.view viewWithTag:103];
        UIButton *btn54= [self.view viewWithTag:54];
        UIButton *btn58= [self.view viewWithTag:58];
        if ([btn.titleLabel.text isEqualToString:@"租房"]) {
            if (self.zfMoreView.hidden == YES) {
                [btn54 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
                [btn58 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
                [UIView animateWithDuration:0.2 animations:^{
                    btn54.imageView.transform = CGAffineTransformMakeRotation(M_PI);
                    btn58.imageView.transform = CGAffineTransformMakeRotation(M_PI);
                }];
            } else {
                [UIView animateWithDuration:0.2 animations:^{
                    btn54.imageView.transform = CGAffineTransformMakeRotation(0);
                    btn58.imageView.transform = CGAffineTransformMakeRotation(0);
                }];
            }
            self.zfMoreView.hidden = !self.zfMoreView.hidden;
        } else {
            if (self.mfMoreView.hidden == YES) {
                [btn54 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
                [btn58 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
                [UIView animateWithDuration:0.2 animations:^{
                    btn54.imageView.transform = CGAffineTransformMakeRotation(M_PI);
                    btn58.imageView.transform = CGAffineTransformMakeRotation(M_PI);
                }];
            } else {
                [UIView animateWithDuration:0.2 animations:^{
                    btn54.imageView.transform = CGAffineTransformMakeRotation(0);
                    btn58.imageView.transform = CGAffineTransformMakeRotation(0);
                }];
            }
            self.mfMoreView.hidden = !self.mfMoreView.hidden;
        }
    }
}
#pragma mark --资讯
- (IBAction)houseInfoAction:(id)sender {
    YJHouseInformationViewController *vc= [[YJHouseInformationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)xiaoquAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    UIButton *btn = sender;
    if (btn.tag == 1) {
        YJXiaoQuListViewController *vc = [[YJXiaoQuListViewController alloc] init];
        PushController(vc);
    } else if (btn.tag == 2) {
        YJLowPriceViewController *vc= [[YJLowPriceViewController alloc] init];
        vc.isLowPrice = YES;
        vc.houseTypeBlock = ^{
            [weakSelf reloadHomeData];
        };
        PushController(vc);
    }else if (btn.tag == 3) {
        YJLowPriceViewController *vc= [[YJLowPriceViewController alloc] init];
        vc.isLowPrice = NO;
        vc.houseTypeBlock = ^{
            [weakSelf reloadHomeData];
        };
        PushController(vc);
    }else if (btn.tag == 4) {
        YJMapViewController *vc= [[YJMapViewController alloc] init];
        PushController(vc);
    }
}


#pragma mark -scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.priceView.hidden = YES;
    self.sortView.hidden = YES;
    self.mfMoreView.hidden = YES;
    self.zfMoreView.hidden = YES;
    self.addressView.hidden = YES;
    self.navView.backgroundColor = [[UIColor ex_colorFromHexRGB:@"44A7FB"] colorWithAlphaComponent:(scrollView.contentOffset.y /128.0)];
    if (scrollView.contentOffset.y >= APP_SCREEN_WIDTH *0.66 +150 + 50 + 6 - (KIsiPhoneX?88:64)) {
        self.topView.hidden = NO;
        self.titleView.hidden = NO;
        self.titleView.subviews[0].alpha = (scrollView.contentOffset.y - (APP_SCREEN_WIDTH *0.66 +120 - (KIsiPhoneX?88:64))) / (KIsiPhoneX?88.0:64.0);
        self.searchBtn.hidden = NO;
    } else {
        self.topView.hidden = YES;
        self.titleView.hidden = YES;
        self.searchBtn.hidden = YES;
    }
    
    if (scrollView.contentOffset.y < 0) {
        self.navView.hidden = YES;
    } else {
        self.navView.hidden = NO;
    }
}

#pragma mark - 区域
- (void)addressTAPActionWithRegion:(NSString *)regionID andPlate:(NSString *)plateID {
    UIButton *btn1 = [self.view viewWithTag:51];
    UIButton *btn2 = [self.view viewWithTag:55];
    [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        btn1.imageView.transform = CGAffineTransformMakeRotation(0);
        btn2.imageView.transform = CGAffineTransformMakeRotation(0);
    }];
    self.regionID =  regionID;
    self.plateID = plateID;
    self.homePage = 0;
    [SVProgressHUD show];
    [self loadHomeData];
}

#pragma mark - 排序
- (void)sortByTag:(NSInteger)tag {
    UIButton *btn1 = [self.view viewWithTag:53];
    UIButton *btn2 = [self.view viewWithTag:57];
    [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        btn1.imageView.transform = CGAffineTransformMakeRotation(0);
        btn2.imageView.transform = CGAffineTransformMakeRotation(0);
    }];
    switch (tag) {
        case 1:
        {
            self.sortKey = @"";
            self.sortValue = @"";
        }
            break;
        case 2:
        {
            self.sortKey = @"order[price]";
            self.sortValue = @"0";
        }
            break;
        case 3:
        {
            self.sortKey = @"order[price]";
            self.sortValue = @"1";
        }
            break;
        case 4:
        {
            self.sortKey = @"order[area]";
            self.sortValue = @"0";
        }
            break;
        case 5:
        {
            self.sortKey = @"order[area]";
            self.sortValue = @"1";
        }
            break;
        default:
            break;
    }
    [SVProgressHUD show];
    self.homePage = 0;
    [self loadHomeData];
}

#pragma mark - 价格
- (void)priceSortByTag:(NSInteger)tag {
    UIButton *btn1 = [self.view viewWithTag:52];
    UIButton *btn2 = [self.view viewWithTag:56];
    [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        btn1.imageView.transform = CGAffineTransformMakeRotation(0);
        btn2.imageView.transform = CGAffineTransformMakeRotation(0);
    }];
    switch (tag) {
        case 1:
        {
            if (self.zufang) {
                self.minPrice = 0;
                self.maxPrice =  0;
            } else {
                self.minPrice = 0;
                self.maxPrice =  0;
            }
        }
            break;
        case 2:
        {
            if (self.zufang) {
                self.minPrice = 0;
                self.maxPrice =  @"1500";
            } else {
                self.minPrice = 0;
                self.maxPrice = @"100";
            }
        }
            break;
        case 3:
        {
            if (self.zufang) {
                self.minPrice = @"1500";
                self.maxPrice =  @"2500";
            } else {
                self.minPrice = @"100";
                self.maxPrice = @"150";
            }

        }
            break;
        case 4:
        {
            if (self.zufang) {
                self.minPrice = @"2500";
                self.maxPrice =  @"3500";
            } else {
                self.minPrice = @"150";
                self.maxPrice = @"200";
            }
        }
            break;
        case 5:
        {
            if (self.zufang) {
                self.minPrice = @"3500";
                self.maxPrice =  @"4500";
            } else {
                self.minPrice = @"200";
                self.maxPrice = @"300";
            }
        }
            break;
        case 6:
        {
            if (self.zufang) {
                self.minPrice = @"4500";
                self.maxPrice = @"-4500";
            } else {
                self.minPrice = @"300";
                self.maxPrice = @"-300";
            }
        }
            break;
        default:
            break;
    }
    self.homePage = 0;
    [SVProgressHUD show];
    [self loadHomeData];
}
- (void)priceSortWithMinPrice:(NSString *)minPrice maxPrice:(NSString *)maxPrice {
    UIButton *btn1 = [self.view viewWithTag:52];
    UIButton *btn2 = [self.view viewWithTag:56];
    [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        btn1.imageView.transform = CGAffineTransformMakeRotation(0);
        btn2.imageView.transform = CGAffineTransformMakeRotation(0);
    }];
    self.minPrice = minPrice;
    self.maxPrice = maxPrice;
    self.homePage = 0;
    [SVProgressHUD show];
    [self loadHomeData];
}
#pragma mark - 买房更多

- (void)mfSortWithParams:(NSDictionary *)params {
    UIButton *btn1 = [self.view viewWithTag:54];
    UIButton *btn2 = [self.view viewWithTag:58];
    if (ISEMPTY(params)) {
        [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
    } else {
        [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.2 animations:^{
        btn1.imageView.transform = CGAffineTransformMakeRotation(0);
        btn2.imageView.transform = CGAffineTransformMakeRotation(0);
    }];
    if (ISEMPTY(self.mfParams)&&ISEMPTY(params)) {
        return;
    }
    self.mfParams = params;
    self.homePage = 0;
    [SVProgressHUD show];
    [self loadHomeData];
}
#pragma mark - 租房更多
- (void)zfSortWithParams:(NSDictionary *)params {
    UIButton *btn1 = [self.view viewWithTag:54];
    UIButton *btn2 = [self.view viewWithTag:58];
    if (ISEMPTY(params)) {
        [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
    } else {
        [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"44A7FB"] forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.2 animations:^{
        btn1.imageView.transform = CGAffineTransformMakeRotation(0);
        btn2.imageView.transform = CGAffineTransformMakeRotation(0);
    }];
    if (ISEMPTY(self.mfParams)&&ISEMPTY(params)) {
        return;
    }
    self.homePage = 0;
    [SVProgressHUD show];
    self.mfParams = params;
    [self loadHomeData];
}
- (void)hiddenAddressView {
    UIButton *btn1 = [self.view viewWithTag:51];
    UIButton *btn2 = [self.view viewWithTag:55];
    if (ISEMPTY(self.regionID)) {
        [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.2 animations:^{
        btn1.imageView.transform = CGAffineTransformMakeRotation(0);
        btn2.imageView.transform = CGAffineTransformMakeRotation(0);
    }];
}
- (void)hiddenPriceView {
    UIButton *btn1 = [self.view viewWithTag:52];
    UIButton *btn2 = [self.view viewWithTag:56];
    if (ISEMPTY(self.maxPrice)) {
        [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.2 animations:^{
        btn1.imageView.transform = CGAffineTransformMakeRotation(0);
        btn2.imageView.transform = CGAffineTransformMakeRotation(0);
    }];
}
- (void)hiddenSortView {
    UIButton *btn1 = [self.view viewWithTag:53];
    UIButton *btn2 = [self.view viewWithTag:57];
    if (ISEMPTY(self.sortValue)) {
        [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.2 animations:^{
        btn1.imageView.transform = CGAffineTransformMakeRotation(0);
        btn2.imageView.transform = CGAffineTransformMakeRotation(0);
    }];
}
- (void)hiddenMFMoreView {
    UIButton *btn1 = [self.view viewWithTag:54];
    UIButton *btn2 = [self.view viewWithTag:58];
    if (ISEMPTY(self.mfParams)) {
        [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.2 animations:^{
        btn1.imageView.transform = CGAffineTransformMakeRotation(0);
        btn2.imageView.transform = CGAffineTransformMakeRotation(0);
    }];
}

- (void)showNewUserTipsView {
    UIView *tipsView = [[UIView alloc] initWithFrame:self.view.frame];
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH - 120 - 50, APP_SCREEN_WIDTH *0.66+76 - 70, 120, 64)];
    img1.image = [UIImage imageNamed:@"icon_tips1"];
    [tipsView addSubview:img1];
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake((APP_SCREEN_WIDTH - 6.0) / 3 * 2 +6, APP_SCREEN_WIDTH *0.66+76, (APP_SCREEN_WIDTH - 6.0) / 3, 74)];
    img2.image = [UIImage imageNamed:@"icon_tips2"];
    [tipsView addSubview:img2];
    UIImageView *img21 = [[UIImageView alloc] initWithFrame:CGRectMake((APP_SCREEN_WIDTH - 6.0) / 3 + 3, APP_SCREEN_WIDTH *0.66+76, (APP_SCREEN_WIDTH - 6.0) / 3, 74)];
    img21.image = [UIImage imageNamed:@"icon_tips2"];
    [tipsView addSubview:img21];
    
    UIImageView *img4 = [[UIImageView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH / 2.0 - 50, APP_SCREEN_WIDTH *0.66 + 76 + 74 + 2, 120, 56)];
    img4.image = [UIImage imageNamed:@"icon_tips3"];
    [tipsView addSubview:img4];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH / 2.0 - 50, APP_SCREEN_HEIGHT - 49-40-35, 100, 35)];
    [btn setBackgroundImage:[UIImage imageNamed:@"icon_tips4"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"icon_tips4"] forState:UIControlStateSelected];
    [tipsView addSubview:btn];
    [btn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    self.klcManager = [KLCPopup popupWithContentView:tipsView];
    self.klcManager.dimmedMaskAlpha = 0.6;
    [self.klcManager show];
}
- (void)dismissAction {
    [self.klcManager dismiss:YES];
}
@end
