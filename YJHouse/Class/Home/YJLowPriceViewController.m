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
#define kCellIdentifier @"YJHomePageViewCell"
@interface YJLowPriceViewController ()<UITableViewDelegate,UITableViewDataSource,YJAddressClickDelegate,YJSortDelegate,YJPriceSortDelegate>
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
@end

@implementation YJLowPriceViewController


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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    self.curTitle.text = self.isLowPrice ? @"今日白菜价":@"最新房源";
    [self registerTableView];
    [self registerRefresh];
    [self loadData];
}
- (void)registerTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.lowPAry = [@[] mutableCopy];
    self.curPage = 1;
    self.zufang = NO;
}
- (void)registerRefresh {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.curPage = 1;
        [weakSelf loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.curPage ++;
        [weakSelf loadData];
    }];
}
- (void)loadData {
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
     NSMutableDictionary *params = [@{} mutableCopy];
    [params setValue:@(self.curPage) forKey:@"page"];
    if (self.regionID.length > 1) {
        if (self.plateID.length > 1) {
            [params setValue:self.plateID forKey:@"plate_id"];
        }
        [params setValue:self.regionID forKey:@"region_id"];
    }
    if (self.sortKey.length) {
        [params setValue:self.sortValue forKey:self.sortKey];
    }
    
    if (!ISEMPTY(self.maxPrice)) {
        [params setObject:@([self.minPrice integerValue]) forKey:@"min_price"];
        [params setObject:@([self.maxPrice integerValue]) forKey:@"max_price"];
    }
    NSString *url;
    if (self.isLowPrice) {
        if (self.zufang == YES) {
            url = @"https://ksir.tech/you/frontend/web/app/zufang/topcut";
        } else {
            url = @"https://ksir.tech/you/frontend/web/app/ershou/topcut";
        }
    } else {
        if (self.zufang == YES) {
            url = @"https://ksir.tech/you/frontend/web/app/zufang/newest";
        } else {
            url = @"https://ksir.tech/you/frontend/web/app/ershou/newest";
        }
    }
    [[NetworkTool sharedTool] requestWithURLString:url parameters:params method:GET callBack:^(id responseObject) {
        if (responseObject) {
            if (weakSelf.curPage == 1) {
                [weakSelf.lowPAry removeAllObjects];
            }
            NSArray *ary = responseObject[@"result"];
            for (int i=0; i<ary.count; i++) {
                YJHouseListModel *model = [MTLJSONAdapter modelOfClass:[YJHouseListModel class] fromJSONDictionary:ary[i] error:nil];
                model.zufang = weakSelf.zufang;
                [weakSelf.lowPAry addObject:model];
            }
            if (ary.count<20) {
                weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
            [SVProgressHUD dismiss];
        }
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
    vc.uid = model.uid;
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
    UIButton *selectBtn = sender;
    [selectBtn setTitleColor:[UIColor ex_colorFromHexRGB:@"FF807D"] forState:UIControlStateNormal];
    UIButton *typeBtn = [self.view viewWithTag:3];
    if (selectBtn.tag == 1) {
        [typeBtn setTitle:@"租房" forState:UIControlStateNormal];
        UIButton *btn = [self.popupView viewWithTag:2];
        [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"3F3F3F"] forState:UIControlStateNormal];
        self.zufang = YES;
        self.priceView.houseType = houseRent;
    } else if (selectBtn.tag == 2){
        [typeBtn setTitle:@"买房" forState:UIControlStateNormal];
        UIButton *btn = (UIButton *)[self.popupView viewWithTag:1];
        [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"3F3F3F"] forState:UIControlStateNormal];
        self.zufang = NO;
        self.priceView.houseType = houseBuy;
    }
    [self.klcManager dismiss:YES];
    self.curPage = 1;
    [self loadData];
}
- (IBAction)sortAction:(id)sender {
    UIButton *button = sender;
    if (button.tag == 55) {
        self.priceView.hidden = YES;
        self.sortView.hidden = YES;
        self.addressView.hidden = !self.addressView.hidden;
    } else if (button.tag == 56){
        self.addressView.hidden = YES;
        self.sortView.hidden = YES;
        self.priceView.hidden = !self.priceView.hidden ;
    } else if (button.tag == 57){
        self.addressView.hidden = YES;
        self.priceView.hidden = YES;
        self.sortView.hidden = !self.sortView.hidden;
    }
}
#pragma mark - 区域
- (void)addressTAPActionWithRegion:(NSString *)regionID andPlate:(NSString *)plateID {
    UIButton *btn2 = [self.view viewWithTag:55];
    [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateNormal];
    self.regionID =  regionID;
    self.plateID = plateID;
    self.curPage = 1;
    [SVProgressHUD show];
    [self loadData];
}

#pragma mark - 排序
- (void)sortByTag:(NSInteger)tag {
    UIButton *btn2 = [self.view viewWithTag:57];
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
    self.curPage = 1;
    [self loadData];
}

#pragma mark - 价格
- (void)priceSortByTag:(NSInteger)tag {
    UIButton *btn2 = [self.view viewWithTag:56];
    [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateNormal];
    switch (tag) {
        case 1:
        {
            self.minPrice = 0;
            self.maxPrice =  0;
        }
            break;
        case 2:
        {
            self.minPrice = 0;
            self.maxPrice = @"100";
        }
            break;
        case 3:
        {
            self.minPrice = @"100";
            self.maxPrice = @"150";
            
        }
            break;
        case 4:
        {
            self.minPrice = @"150";
            self.maxPrice = @"200";
        }
            break;
        case 5:
        {
            self.minPrice = @"200";
            self.maxPrice = @"300";
        }
            break;
        case 6:
        {
            self.minPrice = @"300";
            self.maxPrice = @"0";
        }
            break;
        default:
            break;
    }
    self.curPage = 1;
    [SVProgressHUD show];
    [self loadData];
}
- (void)priceSortWithMinPrice:(NSString *)minPrice maxPrice:(NSString *)maxPrice {
    UIButton *btn1 = [self.view viewWithTag:51];
    UIButton *btn2 = [self.view viewWithTag:55];
    [btn1 setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateNormal];
    self.minPrice = minPrice;
    self.maxPrice = maxPrice;
    self.curPage = 1;
    [SVProgressHUD show];
    [self loadData];
}
@end
