//
//  YJLowPriceViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/10.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJLowPriceViewController.h"
#import "YJHomePageViewCell.h"
#import "KLCPopup.h"
#import "YJHouseDetailViewController.h"
#import "YJHouseListModel.h"
#import "YJAddressView.h"
#import "YJPriceView.h"
#import "YJSortView.h"
#import "YJSecondStepViewController.h"
#define kCellIdentifier @"YJHomePageViewCell"
static NSString *const houseTypeKey = @"houseTypeKey";
@interface YJLowPriceViewController ()<UITableViewDelegate,UITableViewDataSource,YJAddressClickDelegate,YJSortDelegate,YJPriceSortDelegate,YJRequestTimeoutDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) NSInteger curPage;
@property (nonatomic,strong) NSMutableArray *lowPAry;
@property (nonatomic,strong) KLCPopup *klcManager;
@property (strong, nonatomic) IBOutlet KLCPopup *popupView;

@property (weak, nonatomic) IBOutlet UILabel *curTitle;
@property (nonatomic,assign) BOOL zufang;
@property (nonatomic,strong) YJAddressView *addressView;
@property (nonatomic,strong) YJPriceView *priceView;
@property (nonatomic,strong) YJSortView *sortView;
@property (nonatomic,copy) NSString *regionID;
@property (nonatomic,copy) NSString *plateID;
@property (nonatomic,copy) NSString *sortKey;
@property (nonatomic,copy) NSString *sortValue;
@property (nonatomic,copy) NSString *minPrice;
@property (nonatomic,copy) NSString *maxPrice;
@property (nonatomic,assign) NSInteger sortTapLastTime;
@end

@implementation YJLowPriceViewController


- (void)dealloc {
    self.priceView = nil;
}
- (YJPriceView *)priceView {
    if (!_priceView) {
        _priceView = [[YJPriceView alloc] initWithFrame:CGRectMake(0, 100, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 100)];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    [YJRequestTimeoutUtil shareInstance].delegate = self;
    [YJGIFAnimationView showInView:self.view frame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    self.navigationBar.hidden = YES;
    self.sortTapLastTime = 55;
    self.curTitle.text = self.isLowPrice ? @"今日白菜":@"最新房源";
    [self registerTableView];
    [self registerRefresh];
    if (self.isLowPrice) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:houseTypeKey] intValue]) {
            self.zufang = YES;
            self.priceView.houseType = houseRent;
            [self initWithBtnWithType:1];
        } else {
            self.zufang = NO;
            self.priceView.houseType = houseBuy;
            [self initWithBtnWithType:0];
        }
    } else {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:houseTypeKey] intValue]) {
            self.zufang = YES;
            self.priceView.houseType = houseRent;
            [self initWithBtnWithType:1];
        } else {
            self.zufang = NO;
            self.priceView.houseType = houseBuy;
            [self initWithBtnWithType:0];
        }
    }
    [self loadData];
}

- (void)requestTimeoutAction {
    if (self.isVisible) {
        [self loadData];
    }
}
- (void)initWithBtnWithType:(NSInteger)type {
    UIButton *typeBtn = [self.view viewWithTag:3];
    UIButton *btn1 = [self.popupView viewWithTag:1];
    UIButton *btn2 = [self.popupView viewWithTag:2];
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
- (void)registerTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.lowPAry = [@[] mutableCopy];
    self.curPage = 0;
    self.zufang = NO;
}
- (void)registerRefresh {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.curPage = 0;
        [weakSelf loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.curPage ++;
        [weakSelf loadData];
    }];
}
- (void)loadData {
    __weak typeof(self) weakSelf = self;
     NSMutableDictionary *params = [@{} mutableCopy];
    [params setObject:[LJKHelper getAuth_key] forKey:@"auth_key"];
    [params setValue:@(self.curPage) forKey:@"page"];
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
            [params setObject:[NSString stringWithFormat:@"%d-%d",[self.minPrice intValue],[self.maxPrice intValue]] forKey:@"price[0]"];
        }
    }
    NSString *url;
    if (self.isLowPrice) {
        if (self.zufang == YES) {
            url = [NSString stringWithFormat:@"%@/zufang/topcut",Server_url];
        } else {
            url = [NSString stringWithFormat:@"%@/ershou/topcut",Server_url];
        }
    } else {
        if (self.zufang == YES) {
            url = [NSString stringWithFormat:@"%@/zufang/newest",Server_url];
        } else {
            url = [NSString stringWithFormat:@"%@/ershou/newest",Server_url];
        }
    }
    [[NetworkTool sharedTool] requestWithURLString:url parameters:params method:GET callBack:^(id responseObject) {
        if (responseObject) {
            [SVProgressHUD dismiss];
            [YJGIFAnimationView hideInView:self.view];
            if (weakSelf.curPage == 0) {
                [weakSelf.lowPAry removeAllObjects];
            }
            NSArray *ary = responseObject[@"result"];
            for (int i=0; i<ary.count; i++) {
                YJHouseListModel *model = [MTLJSONAdapter modelOfClass:[YJHouseListModel class] fromJSONDictionary:ary[i] error:nil];
                model.zufang = weakSelf.zufang;
                if (!weakSelf.isLowPrice) {
                    model.topcut = @"";
                }
                [weakSelf.lowPAry addObject:model];
            }
            if (ary.count<20) {
                weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
        }
    } error:^(NSError *error) {
        
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lowPAry.count;
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
    [cell showDataWithModel:self.lowPAry[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YJHouseListModel *model = self.lowPAry[indexPath.row];
    YJHouseDetailViewController *vc = [[YJHouseDetailViewController alloc] init];
    vc.site_id = model.site;
    if (model.zufang) {
        vc.type = type_zufang;
    } else {
        vc.type = type_maifang;
    }
    vc.house_id = model.house_id;
    PushController(vc);
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)scanTypeAction:(id)sender {
    self.klcManager = [KLCPopup popupWithContentView:self.popupView];
    [self.klcManager showAtCenter:CGPointMake(APP_SCREEN_WIDTH - 40, 100) inView:self.view];
}
- (IBAction)selectType:(id)sender {
    self.sortKey = @"";
    self.regionID = @"";
    self.maxPrice = 0;
    [self.addressView refreshTabelView];
    [self.sortView initWithSortBtn];
    [self.klcManager dismiss:YES];
    self.priceView.hidden = YES;
    self.addressView.hidden = YES;
    self.sortView.hidden = YES;
    UIButton *lastBtn = [self.view viewWithTag:self.sortTapLastTime];
    [UIView animateWithDuration:0.2 animations:^{
        lastBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    }];
    UIButton *selectBtn = sender;
    UIButton *typeBtn = [self.view viewWithTag:3];
    if (selectBtn.tag == 1) {
        if ([typeBtn.titleLabel.text isEqualToString:@"租房"]) {
            return;
        }
        if (!ISEMPTY([LJKHelper getZufangWeight_id])) {
            [selectBtn setTitleColor:[UIColor ex_colorFromHexRGB:@"FF807D"] forState:UIControlStateNormal];
            [typeBtn setTitle:@"租房" forState:UIControlStateNormal];
            UIButton *btn = [self.popupView viewWithTag:2];
            [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"3F3F3F"] forState:UIControlStateNormal];
            self.zufang = YES;
            self.priceView.houseType = houseRent;
            [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:houseTypeKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }  else {
            YJSecondStepViewController *vc = [[YJSecondStepViewController alloc] init];
            vc.registerModel = [[YJRegisterModel alloc] init];
            vc.registerModel.zufang = YES;
            vc.showBackBtn = YES;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
            return;
        }
   
    } else if (selectBtn.tag == 2){
        if ([typeBtn.titleLabel.text  isEqualToString:@"买房"]) {
            [self.klcManager dismiss:YES];
            return;
        }
        if (!ISEMPTY([LJKHelper getErshouWeight_id])) {
            [selectBtn setTitleColor:[UIColor ex_colorFromHexRGB:@"FF807D"] forState:UIControlStateNormal];
            [typeBtn setTitle:@"买房" forState:UIControlStateNormal];
            UIButton *btn = (UIButton *)[self.popupView viewWithTag:1];
            [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"3F3F3F"] forState:UIControlStateNormal];
            self.zufang = NO;
            self.priceView.houseType = houseBuy;
            [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:houseTypeKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            YJSecondStepViewController *vc = [[YJSecondStepViewController alloc] init];
            vc.registerModel = [[YJRegisterModel alloc] init];
            vc.registerModel.zufang = NO;
            vc.showBackBtn = YES;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
            return;
        }
    }
    self.curPage = 0;
    [self initWithSortBtn];
    [SVProgressHUD show];
    [self loadData];
    self.houseTypeBlock();
}
- (void)initWithSortBtn {
    UIButton *btn55 = [self.view viewWithTag:55];
    [btn55 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
    UIButton *btn56 = [self.view viewWithTag:56];
    [btn56 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
    UIButton *btn57 = [self.view viewWithTag:57];
    [btn57 setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
}
- (IBAction)sortAction:(id)sender {
    UIButton *lastBtn = [self.view viewWithTag:self.sortTapLastTime];
    switch (self.sortTapLastTime) {
        case 55:
        {
            if (ISEMPTY(self.regionID)) {
                [lastBtn setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
            }
            [UIView animateWithDuration:0.2 animations:^{
                lastBtn.imageView.transform = CGAffineTransformMakeRotation(0);
            }];
        }
            break;
        case 56:
        {
            if (ISEMPTY(self.maxPrice)) {
                [lastBtn setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
            }
            [UIView animateWithDuration:0.2 animations:^{
                lastBtn.imageView.transform = CGAffineTransformMakeRotation(0);
            }];
        }
            break;
        case 57:
        {
            if (ISEMPTY(self.sortKey)) {
                [lastBtn setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
            }
            [UIView animateWithDuration:0.2 animations:^{
                lastBtn.imageView.transform = CGAffineTransformMakeRotation(0);
            }];
        }
            break;
        default:
            break;
    }
    UIButton *button = sender;
    if (button.tag == 55) {
        self.sortTapLastTime = 55;
        if (self.addressView.hidden == YES) {
            [button setTitleColor:MainColor forState:UIControlStateNormal];
            [UIView animateWithDuration:0.2 animations:^{
                button.imageView.transform = CGAffineTransformMakeRotation(M_PI);
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                button.imageView.transform = CGAffineTransformMakeRotation(0);
            }];
        }
        self.priceView.hidden = YES;
        self.sortView.hidden = YES;
        self.addressView.hidden = !self.addressView.hidden;
    } else if (button.tag == 56){
        self.sortTapLastTime = 56;
        if (self.priceView.hidden == YES) {
            [button setTitleColor:MainColor forState:UIControlStateNormal];
            [UIView animateWithDuration:0.2 animations:^{
                button.imageView.transform = CGAffineTransformMakeRotation(M_PI);
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                button.imageView.transform = CGAffineTransformMakeRotation(0);
            }];
        }
        self.addressView.hidden = YES;
        self.sortView.hidden = YES;
        self.priceView.hidden = !self.priceView.hidden ;
    } else if (button.tag == 57){
        self.sortTapLastTime = 57;
        if (self.sortView.hidden == YES) {
            [button setTitleColor:MainColor forState:UIControlStateNormal];
            [UIView animateWithDuration:0.2 animations:^{
                button.imageView.transform = CGAffineTransformMakeRotation(M_PI);
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                button.imageView.transform = CGAffineTransformMakeRotation(0);
            }];
        }
        self.addressView.hidden = YES;
        self.priceView.hidden = YES;
        self.sortView.hidden = !self.sortView.hidden;
    }
}
#pragma mark - 区域
- (void)addressTAPActionWithRegion:(NSString *)regionID andPlate:(NSString *)plateID {
    UIButton *btn = [self.view viewWithTag:55];
    [btn setTitleColor:MainColor forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        btn.imageView.transform = CGAffineTransformMakeRotation(0);
    }];
    self.regionID =  regionID;
    self.plateID = plateID;
    self.curPage = 0;
    [SVProgressHUD show];
    [self loadData];
}

#pragma mark - 价格
- (void)priceSortByTag:(NSInteger)tag {
    UIButton *btn = [self.view viewWithTag:56];
    [btn setTitleColor:MainColor forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        btn.imageView.transform = CGAffineTransformMakeRotation(0);
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
                self.maxPrice = @"150";
            }
        }
            break;
        case 3:
        {
            if (self.zufang) {
                self.minPrice = @"1500";
                self.maxPrice =  @"2500";
            } else {
                self.minPrice = @"150";
                self.maxPrice = @"300";
            }
            
        }
            break;
        case 4:
        {
            if (self.zufang) {
                self.minPrice = @"2500";
                self.maxPrice =  @"3500";
            } else {
                self.minPrice = @"300";
                self.maxPrice = @"450";
            }
        }
            break;
        case 5:
        {
            if (self.zufang) {
                self.minPrice = @"3500";
                self.maxPrice =  @"4500";
            } else {
                self.minPrice = @"450";
                self.maxPrice = @"600";
            }
        }
            break;
        case 6:
        {
            if (self.zufang) {
                self.minPrice = @"4500";
                self.maxPrice = @"-4500";
            } else {
                self.minPrice = @"600";
                self.maxPrice = @"-600";
            }
        }
            break;
        default:
            break;
    }
    self.curPage = 0;
    [SVProgressHUD show];
    [self loadData];
}
- (void)priceSortWithMinPrice:(NSString *)minPrice maxPrice:(NSString *)maxPrice {
    UIButton *btn = [self.view viewWithTag:56];
    [btn setTitleColor:MainColor forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        btn.imageView.transform = CGAffineTransformMakeRotation(0);
    }];
    self.minPrice = minPrice;
    self.maxPrice = maxPrice;
    self.curPage = 0;
    [SVProgressHUD show];
    [self loadData];
}
#pragma mark - 排序
- (void)sortByTag:(NSInteger)tag {
    UIButton *btn = [self.view viewWithTag:57];
    [btn setTitleColor:MainColor forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        btn.imageView.transform = CGAffineTransformMakeRotation(0);
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
    self.curPage = 0;
    [self loadData];
}
- (void)hiddenAddressView {
    UIButton *btn = [self.view viewWithTag:55];
    if (ISEMPTY(self.regionID)) {
        [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.2 animations:^{
        btn.imageView.transform = CGAffineTransformMakeRotation(0);
    }];
}
- (void)hiddenPriceView {
    UIButton *btn = [self.view viewWithTag:56];
    if (ISEMPTY(self.maxPrice)) {
        [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.2 animations:^{
        btn.imageView.transform = CGAffineTransformMakeRotation(0);
    }];
}

- (void)hiddenSortView {
    UIButton *btn = [self.view viewWithTag:57];
    if (ISEMPTY(self.sortValue)) {
        [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"8A8A8A"] forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.2 animations:^{
        btn.imageView.transform = CGAffineTransformMakeRotation(0);
    }];
}

- (void)setHouseTypeBlock:(returnHouseOperationType)houseTypeBlock {
    _houseTypeBlock = houseTypeBlock;
}
@end
