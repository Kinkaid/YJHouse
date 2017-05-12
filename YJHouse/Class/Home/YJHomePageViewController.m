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
#define kCellIdentifier @"YJHomePageViewCell"
static NSString *const houseTypeKey = @"houseTypeKey";
@interface YJHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,YJAddressClickDelegate,YJSortDelegate,YJPriceSortDelegate,YJMFSortDelegate,YJZFSortDelegate>
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
@end

@implementation YJHomePageViewController

- (YJPriceView *)priceView {
    if (!_priceView) {
        _priceView = [[YJPriceView alloc] initWithFrame:CGRectMake(0, 100, APP_SCREEN_WIDTH, self.view.frame.size.height - 100)];
        _priceView.hidden = YES;
        _priceView.delegate = self;
        _priceView.houseType = houseBuy;
        [self.view addSubview:_priceView];
    }
    return _priceView;
}
- (YJAddressView *)addressView {
    if (!_addressView) {
        _addressView = [[YJAddressView alloc] initWithFrame:CGRectMake(0, 100, APP_SCREEN_WIDTH,self.view.frame.size.height - 100)];
        _addressView.delegate = self;
        _addressView.hidden = YES;
        [self.view addSubview:_addressView];
    }
    return _addressView;
}
- (YJSortView *)sortView {
    if (!_sortView) {
        _sortView = [[YJSortView alloc] initWithFrame:CGRectMake(0, 100, APP_SCREEN_WIDTH, self.view.frame.size.height - 100)];
        _sortView.hidden = YES;
        _sortView.delegate = self;
        _sortView.sortType = houseType;
        [self.view addSubview:_sortView];
    }
    return _sortView;
}
- (YJMFMoreView *)mfMoreView {
    if (!_mfMoreView) {
        _mfMoreView = [[YJMFMoreView alloc] initWithFrame:CGRectMake(0, 100, APP_SCREEN_WIDTH, self.view.frame.size.height - 100 - 49)];
        _mfMoreView.hidden = YES;
        _mfMoreView.delegate = self;
        [self.view addSubview:_mfMoreView];
    }
    return _mfMoreView;
}
- (YJZFMoreView *)zfMoreView {
    if (!_zfMoreView) {
        _zfMoreView = [[YJZFMoreView alloc] initWithFrame:CGRectMake(0, 100, APP_SCREEN_WIDTH, self.view.frame.size.height - 100)];
        _zfMoreView.hidden = YES;
        _zfMoreView.delegate = self;
        [self.view addSubview:_zfMoreView];
    }
    return _zfMoreView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    [self registerTableView];
    [self.view bringSubviewToFront:self.topView];
    [self registerRefresh];
    [SVProgressHUD show];
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
}
- (void)initWithBtnWithType:(NSInteger)type {
    UIButton *typeBtn = [self.view viewWithTag:103];
    UIButton *btn1 = [self.popupView viewWithTag:101];
    UIButton *btn2 = [self.popupView viewWithTag:102];
    if (type == 1) {
        [typeBtn setTitle:@"租房" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"FF807D"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"3F3F3F"] forState:UIControlStateNormal];
    } else {
        [typeBtn setTitle:@"买房" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"3F3F3F"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"FF807D"] forState:UIControlStateNormal];
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
        weakSelf.homePage = 1;
        [weakSelf loadHomeData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.homePage ++;
        [weakSelf loadHomeData];
    }];
}
- (void)registerTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.headerView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH *0.66 +150 +46);
    [self.tableView setTableHeaderView:self.headerView];
    self.navView.backgroundColor = [[UIColor ex_colorFromHexRGB:@"FF0000"] colorWithAlphaComponent:0];
    self.homePage = 1;
    self.homeHouseAry = [@[] mutableCopy];
}

- (void)loadHomeData {
    __weak typeof(self)weakSelf = self;
    NSMutableDictionary *params = [@{} mutableCopy];
    [params setValue:@(1) forKey:@"user_id"];
    [params setValue:@(1) forKey:@"active"];
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
        url = @"https://ksir.tech/you/frontend/web/app/zufang/custom-list";
    } else {
        url = @"https://ksir.tech/you/frontend/web/app/ershou/custom-list";
    }
    [[NetworkTool sharedTool] requestWithURLString:url parameters:params method:GET callBack:^(id responseObject) {
        if (weakSelf.homePage == 1) {
            [weakSelf.homeHouseAry removeAllObjects];
            [weakSelf.tableView.mj_header endRefreshing];
            [SVProgressHUD dismiss];
        }
        NSArray *ary = responseObject[@"result"];
        for (int i = 0; i<ary.count; i++) {
            YJHouseListModel *model = [MTLJSONAdapter modelOfClass:[YJHouseListModel class] fromJSONDictionary:ary[i] error:nil];
            model.zufang = weakSelf.zufang;
            [weakSelf.homeHouseAry addObject:model];
        }
        if (ary.count<20) {
            weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        [weakSelf.tableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeHouseAry.count;
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
    [cell showDataWithModel:self.homeHouseAry[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YJHouseListModel *model = self.homeHouseAry[indexPath.row];
    YJHouseDetailViewController *vc = [[YJHouseDetailViewController alloc] init];
    vc.site_id =model.site;
    vc.uid = model.uid;
    if (model.zufang) {
        vc.type = type_zufang;
    } else {
        vc.type = type_maifang;
    }
    PushController(vc);
}
#pragma mark - IBActions
- (IBAction)scanTypeAction:(id)sender {
    self.klcManager = [KLCPopup popupWithContentView:self.popupView];
    [self.klcManager showAtCenter:CGPointMake(40, 100) inView:self.view];
    self.priceView.hidden = YES;
    self.addressView.hidden = YES;
    self.sortView.hidden = YES;
    self.zfMoreView.hidden = YES;
    self.mfMoreView.hidden = YES;
}
- (IBAction)selectType:(id)sender {
    self.mfParams = nil;
    self.sortKey = @"";
    self.regionID = @"";
    self.maxPrice = 0;
    [self.mfMoreView initWithMFBtn];
    [self.zfMoreView initWithZFBtn];
    [self.addressView refreshTabelView];
    UIButton *selectBtn = sender;
    [selectBtn setTitleColor:[UIColor ex_colorFromHexRGB:@"FF807D"] forState:UIControlStateNormal];
    UIButton *typeBtn = [self.view viewWithTag:103];
    if (selectBtn.tag == 101) {
        if ([typeBtn.titleLabel.text isEqualToString:@"租房"]) {
            [self.klcManager dismiss:YES];
            return;
        }
        [typeBtn setTitle:@"租房" forState:UIControlStateNormal];
        UIButton *btn = [self.popupView viewWithTag:102];
        [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"3F3F3F"] forState:UIControlStateNormal];
        self.zufang = YES;
        self.priceView.houseType = houseRent;
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:houseTypeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if (selectBtn.tag == 102){
        if ([typeBtn.titleLabel.text  isEqualToString:@"买房"]) {
            [self.klcManager dismiss:YES];
            return;
        }
        [typeBtn setTitle:@"买房" forState:UIControlStateNormal];
        UIButton *btn = (UIButton *)[self.popupView viewWithTag:101];
        [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"3F3F3F"] forState:UIControlStateNormal];
        self.zufang = NO;
        self.priceView.houseType = houseBuy;
        [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:houseTypeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self initWithSortBtn];
    self.homePage = 1;
    [self.klcManager dismiss:YES];
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
}

- (IBAction)sortAction:(id)sender {
    UIButton *button = sender;
    if (button.tag < 55) {
      [self.tableView setContentOffset:CGPointMake(0, APP_SCREEN_WIDTH *0.66 +150 + 6 - 64)];
    }
    if (button.tag == 51 || button.tag == 55) {
        self.priceView.hidden = YES;
        self.sortView.hidden = YES;
        self.mfMoreView.hidden = YES;
        self.zfMoreView.hidden = YES;
        self.addressView.hidden = !self.addressView.hidden;
    } else if (button.tag == 52 ||button.tag == 56){
        self.addressView.hidden = YES;
        self.sortView.hidden = YES;
        self.mfMoreView.hidden = YES;
        self.zfMoreView.hidden = YES;
        self.priceView.hidden = !self.priceView.hidden ;
    } else if (button.tag == 53 ||button.tag == 57){
        self.addressView.hidden = YES;
        self.priceView.hidden = YES;
        self.mfMoreView.hidden = YES;
        self.zfMoreView.hidden = YES;
        self.sortView.hidden = !self.sortView.hidden;
    } else if (button.tag == 54 ||button.tag == 58){
        self.addressView.hidden = YES;
        self.priceView.hidden = YES;
        self.sortView.hidden = YES;
        UIButton *btn = [self.view viewWithTag:103];
        if ([btn.titleLabel.text isEqualToString:@"租房"]) {
            self.zfMoreView.hidden = !self.zfMoreView.hidden;
        } else {
            self.mfMoreView.hidden = !self.mfMoreView.hidden;
        }
    }
}
- (IBAction)xiaoquAction:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 1) {
        YJXiaoQuListViewController *vc = [[YJXiaoQuListViewController alloc] init];
        PushController(vc);
    } else if (btn.tag == 2) {
        YJLowPriceViewController *vc= [[YJLowPriceViewController alloc] init];
        vc.isLowPrice = YES;
        PushController(vc);
    }else if (btn.tag == 3) {
        YJLowPriceViewController *vc= [[YJLowPriceViewController alloc] init];
        vc.isLowPrice = NO;
        PushController(vc);
    }
    
}


#pragma mark -scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.navView.backgroundColor = [[UIColor ex_colorFromHexRGB:@"A746E8"] colorWithAlphaComponent:(scrollView.contentOffset.y /128.0)];
    if (scrollView.contentOffset.y >= APP_SCREEN_WIDTH *0.66 +150 + 6 - 64) {
        self.topView.hidden = NO;
        self.titleView.hidden = NO;
        self.searchBtn.hidden = NO;
    } else {
        self.topView.hidden = YES;
        self.titleView.hidden = YES;
        self.searchBtn.hidden = YES;
    }
}

#pragma mark - 区域
- (void)addressTAPActionWithRegion:(NSString *)regionID andPlate:(NSString *)plateID {
    UIButton *btn1 = [self.view viewWithTag:51];
    UIButton *btn2 = [self.view viewWithTag:55];
    [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateNormal];
    self.regionID =  regionID;
    self.plateID = plateID;
    self.homePage = 1;
    [SVProgressHUD show];
    [self loadHomeData];
}

#pragma mark - 排序
- (void)sortByTag:(NSInteger)tag {
    UIButton *btn1 = [self.view viewWithTag:53];
    UIButton *btn2 = [self.view viewWithTag:57];
    [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateNormal];
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
    self.homePage = 1;
    [self loadHomeData];
}

#pragma mark - 价格
- (void)priceSortByTag:(NSInteger)tag {
    UIButton *btn1 = [self.view viewWithTag:52];
    UIButton *btn2 = [self.view viewWithTag:56];
    [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateNormal];
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
    self.homePage = 1;
    [SVProgressHUD show];
    [self loadHomeData];
}
- (void)priceSortWithMinPrice:(NSString *)minPrice maxPrice:(NSString *)maxPrice {
    UIButton *btn1 = [self.view viewWithTag:51];
    UIButton *btn2 = [self.view viewWithTag:55];
    [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateNormal];
    self.minPrice = minPrice;
    self.maxPrice = maxPrice;
    self.homePage = 1;
    [SVProgressHUD show];
    [self loadHomeData];
}
#pragma mark - 买房更多

- (void)mfSortWithParams:(NSDictionary *)params {
    UIButton *btn1 = [self.view viewWithTag:54];
    UIButton *btn2 = [self.view viewWithTag:58];
    [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateNormal];
    self.mfParams = params;
    self.homePage = 1;
    [SVProgressHUD show];
    [self loadHomeData];
}
#pragma mark - 租房更多
- (void)zfSortWithParams:(NSDictionary *)params {
    UIButton *btn1 = [self.view viewWithTag:54];
    UIButton *btn2 = [self.view viewWithTag:58];
    if (ISEMPTY(params)) {
        [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateNormal];
    } else {
        [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateNormal];
    }
    
    self.homePage = 1;
    [SVProgressHUD show];
    self.mfParams = params;
    [self loadHomeData];
}
@end
