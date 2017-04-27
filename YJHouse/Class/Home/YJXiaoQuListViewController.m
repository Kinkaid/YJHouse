//
//  YJXiaoQuListViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/3/20.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJXiaoQuListViewController.h"
#import "YJXiaoQuViewCell.h"
#import "YJSearchViewController.h"
#import "YJXiaoQuDetailViewController.h"
#define cellId @"YJXiaoQuViewCell"
#import "YJXiaoquModel.h"
#import "YJAddressView.h"
#import "YJPriceView.h"
#import "YJSortView.h"
@interface YJXiaoQuListViewController ()<UITableViewDelegate,UITableViewDataSource,YJAddressClickDelegate,YJSortDelegate,YJPriceSortDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *xiaoquAry;
@property (nonatomic,assign) NSInteger xiaoquPage;
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

@implementation YJXiaoQuListViewController


- (YJPriceView *)priceView {
    if (!_priceView) {
        _priceView = [[YJPriceView alloc] initWithFrame:CGRectMake(0, 100, APP_SCREEN_WIDTH, self.view.frame.size.height - 100)];
        _priceView.hidden = YES;
        _priceView.delegate = self;
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
        _sortView = [[YJSortView alloc] initWithFrame:CGRectMake(0, 100, APP_SCREEN_WIDTH,APP_SCREEN_HEIGHT - 100)];
        _sortView.delegate = self;
        _sortView.hidden = YES;
        [self.view addSubview:_sortView];
    }
    return _sortView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBar.hidden = YES;
    self.priceView.houseType = xiaoquBuy;
    self.sortView.sortType = xiaoquType;
    [self registerTableView];
    [self registerRefresh];
    [SVProgressHUD show];
    [self loadXiaoquListData];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)registerTableView {
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    self.xiaoquPage = 1;
    self.xiaoquAry = [@[] mutableCopy];
}
- (void)registerRefresh {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.xiaoquPage = 1;
        [weakSelf loadXiaoquListData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.xiaoquPage ++;
        [weakSelf loadXiaoquListData];
    }];
}
- (void)loadXiaoquListData {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = [@{} mutableCopy];
    [params setValue:@(self.xiaoquPage) forKey:@"page"];
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
    
    [[NetworkTool sharedTool] requestWithURLString:@"https://ksir.tech/you/frontend/web/app/xiaoqu/list" parameters:params method:GET callBack:^(id responseObject) {
        if (responseObject) {
            if (weakSelf.xiaoquPage == 1) {
                [weakSelf.xiaoquAry removeAllObjects];
            }
            NSArray *ary = responseObject[@"result"];
            for (int i=0; i<ary.count; i++) {
                YJXiaoquModel *model = [MTLJSONAdapter modelOfClass:[YJXiaoquModel class] fromJSONDictionary:ary[i] error:nil];
                [weakSelf.xiaoquAry addObject:model];
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
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)searchAction:(id)sender {//搜索
    YJSearchViewController *vc= [[YJSearchViewController alloc] init];
    PushController(vc);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.xiaoquAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJXiaoQuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if(!cell) {
        cell = [[YJXiaoQuViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showDataWithModel:self.xiaoquAry[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YJXiaoQuDetailViewController *vc = [[YJXiaoQuDetailViewController alloc] init];
    YJXiaoquModel *model = self.xiaoquAry[indexPath.row];
    vc.xiaoquId = model.xqID;
    PushController(vc);
}

#pragma mark - 区域
- (void)addressTAPActionWithRegion:(NSString *)regionID andPlate:(NSString *)plateID {
    UIButton *btn = [self.view viewWithTag:55];
    [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateNormal];
    self.regionID =  regionID;
    self.plateID = plateID;
    self.xiaoquPage = 1;
    [SVProgressHUD show];
    [self loadXiaoquListData];

}
#pragma mark - 均价
- (void)priceSortByTag:(NSInteger)tag {
    UIButton *btn = [self.view viewWithTag:56];
    [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateNormal];
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
            self.maxPrice = @"1.0";
        }
            break;
        case 3:
        {
            self.minPrice = @"1.0";
            self.maxPrice = @"1.5";
            
        }
            break;
        case 4:
        {
            self.minPrice = @"1.5";
            self.maxPrice = @"2.0";
        }
            break;
        case 5:
        {
            self.minPrice = @"2.0";
            self.maxPrice = @"2.5";
        }
            break;
        case 6:
        {
            self.minPrice = @"2.5";
            self.maxPrice = @"3.0";
        }
            break;
        default:
            break;
    }
    self.xiaoquPage = 1;
    [SVProgressHUD show];
    [self loadXiaoquListData];
}
- (void)priceSortWithMinPrice:(NSString *)minPrice maxPrice:(NSString *)maxPrice {
    UIButton *btn = [self.view viewWithTag:56];
    [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateNormal];
    self.minPrice = minPrice;
    self.maxPrice = maxPrice;
    self.xiaoquPage = 1;
    [SVProgressHUD show];
    [self loadXiaoquListData];
}
#pragma mark - 排序
- (void)sortByTag:(NSInteger)tag {
    UIButton *btn = [self.view viewWithTag:57];
    [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"A746E8"] forState:UIControlStateNormal];
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
    self.xiaoquPage = 1;
    [self loadXiaoquListData];
}




@end
