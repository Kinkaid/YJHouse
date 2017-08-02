//
//  YJSearchViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/22.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJSearchViewController.h"
#import "KLCPopup.h"
#import "YJHomePageViewCell.h"
#import "YJHistorySearchView.h"
#import "YJNoSearchDataView.h"
#import "YJHouseListModel.h"
#import "YJXiaoQuViewCell.h"
#import "YJXiaoquModel.h"
#import "YJXiaoQuDetailViewController.h"
#define cellId @"YJXiaoQuViewCell"
#import "YJHouseDetailViewController.h"
#define kCellIdentifier @"YJHomePageViewCell"
static NSString *const houseTypeKey = @"houseTypeKey";
@interface YJSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,KeyViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet KLCPopup *popupView;
@property (nonatomic,strong) KLCPopup *klcManager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *searchAry;
@property (nonatomic,strong) YJHistorySearchView *searchView;
@property (nonatomic,strong) YJNoSearchDataView *noSearchResultView;
@property (nonatomic,assign) BOOL zufang;

@end

@implementation YJSearchViewController


- (YJNoSearchDataView *)noSearchResultView {
    if (!_noSearchResultView) {
        _noSearchResultView = [[YJNoSearchDataView alloc] initWithFrame:CGRectMake(0, 64, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 64)];
        [self.view addSubview:_noSearchResultView];
        [self.view bringSubviewToFront:self.searchView];
        _noSearchResultView.content = @"没有搜索结果";
    }
    return _noSearchResultView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    if (self.isXiaoquSearch) {
        UIButton *typeBtn = [self.view viewWithTag:3];
        typeBtn.hidden = YES;
    } else {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:houseTypeKey] intValue]) {
            self.zufang = YES;
            [self initWithBtnWithType:1];
        } else {
            self.zufang = NO;
            [self initWithBtnWithType:0];
        }
    }
    [self registerTableView];
    [self setHistoryView];
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchBar resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setHistoryView {
    self.searchView = [[YJHistorySearchView alloc]initWithFrame:CGRectMake(0, 64, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    self.searchView.backgroundColor = [UIColor whiteColor];
    self.searchView.label.text = @"历史搜索";
    self.searchView.delegate = self;
    [self.view addSubview:self.searchView];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    if (self.isXiaoquSearch) {
        NSString *filePath = [path stringByAppendingPathComponent:@"historySearch_xiaoqu.plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        [self.searchView KeyViewH:array];
    } else {
        NSString *filePath = [path stringByAppendingPathComponent:@"historySearch_house.plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        [self.searchView KeyViewH:array];
    }
}

- (void)registerTableView {
    if (self.isXiaoquSearch) {
        [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    } else {
        [self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.searchAry = [@[] mutableCopy];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.isXiaoquSearch ? 100:97;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isXiaoquSearch) {
        YJXiaoQuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        if(!cell) {
            cell = [[YJXiaoQuViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showDataWithModel:self.searchAry[indexPath.row]];
        return cell;
    } else {
        YJHomePageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showDataWithModel:self.searchAry[indexPath.row]];
        return cell;
       }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isXiaoquSearch) {
        YJXiaoQuDetailViewController *vc = [[YJXiaoQuDetailViewController alloc] init];
        YJXiaoquModel *model = self.searchAry[indexPath.row];
        vc.xiaoquId = model.xqID;
        PushController(vc);
    }  else {
        YJHouseListModel *model = self.searchAry[indexPath.row];
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
}

- (void)loadSearchData:(NSString *)searchKey {
    [SVProgressHUD show];
    self.searchView.hidden = YES;
    [self.searchAry removeAllObjects];
    NSString * url;
    if (self.isXiaoquSearch) {
         url = [NSString stringWithFormat:@"https://youjar.com/you/frontend/web/app/xiaoqu/list?auth_key=%@&xq[name]=%@",[LJKHelper getAuth_key],searchKey];
    } else {
        if (self.zufang) {
            url = [NSString stringWithFormat:@"https://youjar.com/you/frontend/web/app/zufang/custom-list?auth_key=%@&name[0]=%@",[LJKHelper getAuth_key],searchKey];
        } else {
            url = [NSString stringWithFormat:@"https://youjar.com/you/frontend/web/app/ershou/custom-list?auth_key=%@&name[0]=%@",[LJKHelper getAuth_key],searchKey];
        }
    }
    __weak typeof(self) weakSelf = self;
//    NSString * newUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[NetworkTool sharedTool] requestWithURLString:newUrl parameters:nil method:POST callBack:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSArray *ary = responseObject[@"result"];
        [weakSelf.searchAry removeAllObjects];
        if (weakSelf.isXiaoquSearch) {
            for (int i=0; i<ary.count; i++) {
                YJXiaoquModel *model = [MTLJSONAdapter modelOfClass:[YJXiaoquModel class] fromJSONDictionary:ary[i] error:nil];
                [weakSelf.searchAry addObject:model];
            }
        } else {
            for (int i=0; i<ary.count; i++) {
                YJHouseListModel *model = [MTLJSONAdapter modelOfClass:[YJHouseListModel class] fromJSONDictionary:ary[i] error:nil];
                model.zufang = weakSelf.zufang;
                model.topcut = @"";
                [weakSelf.searchAry addObject:model];
            }
        }
        if (weakSelf.searchAry.count) {
            weakSelf.noSearchResultView.hidden = YES;
        } else {
            weakSelf.noSearchResultView.hidden = NO;
        }
        [weakSelf.tableView reloadData];
    } error:^(NSError *error) {
        
    }];
}

#pragma mark IBActions
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)scanTypeAction:(id)sender {
    self.klcManager = [KLCPopup popupWithContentView:self.popupView];
    [self.klcManager showAtCenter:CGPointMake(40, 100) inView:self.view];
}
- (IBAction)selectType:(id)sender {
    UIButton *selectBtn = sender;
    [selectBtn setTitleColor:[UIColor ex_colorFromHexRGB:@"FF807D"] forState:UIControlStateNormal];
    UIButton *typeBtn = [self.view viewWithTag:3];
    if (selectBtn.tag == 1) {
        [typeBtn setTitle:@"租房" forState:UIControlStateNormal];
        UIButton *btn = [self.popupView viewWithTag:2];
        [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"3F3F3F"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:houseTypeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.zufang = YES;
    } else if (selectBtn.tag == 2){
        [typeBtn setTitle:@"买房" forState:UIControlStateNormal];
        UIButton *btn = (UIButton *)[self.popupView viewWithTag:1];
        [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"3F3F3F"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:houseTypeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.zufang = NO;
    }
    [self.klcManager dismiss:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
    
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchView.hidden = NO;
}
#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    if (self.isXiaoquSearch) {
        NSString *filePath = [path stringByAppendingPathComponent:@"historySearch_xiaoqu.plist"];
        NSArray *history = [NSArray arrayWithContentsOfFile:filePath];
        NSMutableArray *ary = [[NSMutableArray alloc] initWithArray:history];
        if ([ary containsObject:self.searchBar.text]) {
            [ary removeObject:self.searchBar.text];
        }
        [ary insertObject:self.searchBar.text atIndex:0];
        [ary writeToFile:filePath atomically:YES];
    } else {
        NSString *filePath = [path stringByAppendingPathComponent:@"historySearch_house.plist"];
        NSArray *history = [NSArray arrayWithContentsOfFile:filePath];
        NSMutableArray *ary = [[NSMutableArray alloc] initWithArray:history];
        if ([ary containsObject:self.searchBar.text]) {
            [ary removeObject:self.searchBar.text];
        }
        [ary insertObject:self.searchBar.text atIndex:0];
        [ary writeToFile:filePath atomically:YES];
    }
    [self.searchBar resignFirstResponder];
    self.searchView.hidden = YES;
    [self loadSearchData:self.searchBar.text];
    self.searchBar.text = @"";
}
- (void)getKeyValue:(NSString *)str {
    [self.searchBar resignFirstResponder];
    [self loadSearchData:str];

}
- (void)clickDeleKey {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    if (self.isXiaoquSearch) {
        NSString *filePath = [path stringByAppendingPathComponent:@"historySearch_xiaoqu.plist"];
        [@[] writeToFile:filePath atomically:YES];
    } else{
        NSString *filePath = [path stringByAppendingPathComponent:@"historySearch_house.plist"];
        [@[] writeToFile:filePath atomically:YES];
    }
    [self.searchView removeAllKey];
}

@end
