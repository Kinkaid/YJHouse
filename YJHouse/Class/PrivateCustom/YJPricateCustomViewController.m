//
//  YJPricateCustomViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/18.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJPricateCustomViewController.h"
#import "YJPricateCustomViewCell.h"
#import "YJPrivateAddViewCell.h"
#import "YJFirstStepViewController.h"
#import "KLCPopup.h"
#import "YJPrivateModel.h"
#import "YJSecondStepViewController.h"
#define kCellIdentifier @"YJPricateCustomViewCell"
#define kCellAddIdentifier @"YJPrivateAddViewCell"
static NSString *const kReloadHomeDataNotif = @"kReloadHomeDataNotif";
static NSString *const houseTypeKey = @"houseTypeKey";
@interface YJPricateCustomViewController ()<UITableViewDelegate,UITableViewDataSource,YJPrivateCustomEditDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet KLCPopup *popupView;
@property (nonatomic,strong)KLCPopup *klcManager;
@property (nonatomic,strong) NSMutableArray *zufangPrivateAry;
@property (nonatomic,strong) NSMutableArray *ershouPrivateAry;
@property (nonatomic,strong) NSMutableDictionary *regionDic;
@property (nonatomic,assign) BOOL zufang;
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *headerName;

@end

@implementation YJPricateCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    [self registerTableView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:houseTypeKey] intValue]) {
        self.zufang = YES;
        [self initWithBtnWithType:1];
    } else {
        self.zufang = NO;
        [self initWithBtnWithType:0];
    }
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:[LJKHelper getUserHeaderUrl]] placeholderImage:[UIImage imageNamed:@"icon_header_11"]];
    self.headerName.text = [LJKHelper getUserName];
    [self loadData];
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

- (void)registerTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:kCellAddIdentifier bundle:nil] forCellReuseIdentifier:kCellAddIdentifier];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.zufangPrivateAry = [@[] mutableCopy];
    self.ershouPrivateAry = [@[] mutableCopy];
    self.regionDic = [@{} mutableCopy];
    [self.regionDic setDictionary:@{@"上城区":@"330102000",@"下城区":@"330103000",@"江干区":@"330104000",@"拱墅区":@"330105000",@"西湖区":@"330106000",@"滨江区":@"330108000",@"萧山区":@"330109000",@"余杭区":@"330110000",@"富阳区":@"330111000"}];
}
- (void)loadData {
    [SVProgressHUD show];
    __weak typeof(self)weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:@"https://ksir.tech/you/frontend/web/app/user/user-info" parameters:@{@"auth_key":[LJKHelper getAuth_key]} method:POST callBack:^(id responseObject) {
        if (!ISEMPTY(responseObject)) {
            [SVProgressHUD dismiss];
            [weakSelf.zufangPrivateAry removeAllObjects];
            [weakSelf.ershouPrivateAry removeAllObjects];
            for (int i=0; i<[responseObject[@"result"][@"weight_ershou"] count]; i++) {
                YJPrivateModel *ershouModel = [MTLJSONAdapter modelOfClass:[YJPrivateModel class] fromJSONDictionary:responseObject[@"result"][@"weight_ershou"][i] error:nil];
                [weakSelf.regionDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([obj integerValue] == [ershouModel.region1_id integerValue]) {
                        ershouModel.region1_name = key;
                    }
                    if ([obj integerValue] == [ershouModel.region2_id integerValue]) {
                        ershouModel.region2_name = key;
                    }
                }];
                if ([ershouModel.privateId integerValue] == [[LJKHelper getErshouWeight_id] integerValue]) {
                    ershouModel.selected = YES;
                } else {
                    ershouModel.selected = NO;
                }
                ershouModel.zufang = NO;
                [weakSelf.ershouPrivateAry addObject:ershouModel];
            }
            for (int j=0; j<[responseObject[@"result"][@"weight_zufang"] count]; j++) {
                YJPrivateModel *zufangModel = [MTLJSONAdapter modelOfClass:[YJPrivateModel class] fromJSONDictionary:responseObject[@"result"][@"weight_zufang"][j] error:nil];
                [weakSelf.regionDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([obj integerValue] == [zufangModel.region1_id integerValue]) {
                        zufangModel.region1_name = key;
                    }
                    if ([obj integerValue] == [zufangModel.region2_id integerValue]) {
                        zufangModel.region2_name = key;
                    }
                }];
                if ([zufangModel.privateId integerValue] == [[LJKHelper getZufangWeight_id] integerValue]) {
                    zufangModel.selected = YES;
                } else {
                    zufangModel.selected = NO;
                }
                zufangModel.zufang = YES;
                [weakSelf.zufangPrivateAry addObject:zufangModel];
            }
            [weakSelf.tableView reloadData];
        }
    } error:^(NSError *error) {
        
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.zufang) {
        return self.zufangPrivateAry.count+1;
    } else {
        return self.ershouPrivateAry.count+1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 19;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((self.zufang && indexPath.section == self.zufangPrivateAry.count) ||(self.zufang == NO && indexPath.section == self.ershouPrivateAry.count) ) {
        YJPrivateAddViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellAddIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        YJPricateCustomViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
        if (!cell1) {
            cell1 = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
        }
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.delegate = self;
        cell1.cellSection = indexPath.section;
        if (self.zufang) {
            [cell1 showDataWithModel:self.zufangPrivateAry[indexPath.section]];
        } else {
            [cell1 showDataWithModel:self.ershouPrivateAry[indexPath.section]];
        }
        return cell1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77;
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor whiteColor];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.zufang) {
        if (indexPath.section < self.zufangPrivateAry.count) {
            return YES;
        } else {
            return NO;
        }
    } else {
        if (indexPath.section < self.ershouPrivateAry.count) {
            return YES;
        } else {
            return NO;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.zufang) {
        if (indexPath.section <self.zufangPrivateAry.count) {
            YJPrivateModel *sModel = self.zufangPrivateAry[indexPath.section];
            if (sModel.selected) {
                [YJApplicationUtil alertHud:@"正在使用该定制" afterDelay:1];
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadHomeDataNotif object:nil];
                return;
            }
            [SVProgressHUD show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [YJApplicationUtil alertHud:@"私人订制成功" afterDelay:1];
                [LJKHelper saveZufangWeight_id:sModel.privateId];
                sModel.selected = YES;
                for (int i=0; i<self.zufangPrivateAry.count; i++) {
                    YJPrivateModel *model = self.zufangPrivateAry[i];
                    if (model != sModel) {
                        model.selected = NO;
                    }
                }
                [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"houseTypeKey"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadHomeDataNotif object:nil];
                [self.tableView reloadData];
            });
        } else {
            YJFirstStepViewController *vc = [[YJFirstStepViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            vc.firstEnter = NO;
            [self presentViewController:nav animated:YES completion:nil];
        }
    } else {
        if (indexPath.section <self.ershouPrivateAry.count) {
            YJPrivateModel *sModel = self.ershouPrivateAry[indexPath.section];
            if (sModel.selected) {
                [YJApplicationUtil alertHud:@"正在使用该定制" afterDelay:1];
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadHomeDataNotif object:nil];
                return;
            }
            [SVProgressHUD show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [YJApplicationUtil alertHud:@"私人订制成功" afterDelay:1];
                sModel.selected = YES;
                [LJKHelper saveErshouWeight_id:sModel.privateId];
                for (int i=0; i<self.ershouPrivateAry.count; i++) {
                    YJPrivateModel *model = self.ershouPrivateAry[i];
                    if (model != sModel) {
                        model.selected = NO;
                    }
                }
                [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"houseTypeKey"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadHomeDataNotif object:nil];
                [self.tableView reloadData];
            });
          
        } else {
            YJSecondStepViewController *vc = [[YJSecondStepViewController alloc] init];
            vc.registerModel = [[YJRegisterModel alloc] init];
            vc.registerModel.zufang = self.zufang;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadData];
}
- (IBAction)selectType:(id)sender {
    self.klcManager = [KLCPopup popupWithContentView:self.popupView];
    [self.klcManager showAtCenter:CGPointMake(36,80) inView:self.view];
}
- (IBAction)chooseType:(id)sender {
    UIButton *selectBtn = sender;
    [selectBtn setTitleColor:[UIColor ex_colorFromHexRGB:@"FF807D"] forState:UIControlStateNormal];
    UIButton *typeBtn = [self.view viewWithTag:103];
    if (selectBtn.tag == 101) {
        [typeBtn setTitle:@"租房" forState:UIControlStateNormal];
        UIButton *btn = [self.popupView viewWithTag:102];
        [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"3F3F3F"] forState:UIControlStateNormal];
        self.zufang = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:houseTypeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if (selectBtn.tag == 102){
        [typeBtn setTitle:@"买房" forState:UIControlStateNormal];
        UIButton *btn = (UIButton *)[self.popupView viewWithTag:101];
        [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"3F3F3F"] forState:UIControlStateNormal];
        self.zufang = NO;
        [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:houseTypeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self.klcManager dismiss:YES];
    [self.tableView reloadData];
}

- (void)privateEditAction:(NSInteger)cellSection {
    YJPrivateModel *model;
    if (self.zufang) {
        model = [self.zufangPrivateAry[cellSection] copy];
    } else {
        model = [self.ershouPrivateAry[cellSection] copy];
    }
    YJSecondStepViewController *vc = [[YJSecondStepViewController alloc] init];
    vc.registerModel = [[YJRegisterModel alloc] init];
    vc.edit = YES;
    vc.registerModel.zufang = model.zufang;
    vc.registerModel.firstEnter = NO;
    vc.registerModel.uw_active = @"1";
    vc.registerModel.uw_name = @"私人订制";
    vc.registerModel.uw_region1_id = model.region1_id;
    vc.registerModel.uw_region2_id = model.region2_id;
    vc.registerModel.uw_region1_weight = @"10";
    vc.registerModel.uw_region2_weight = @"10";
    vc.registerModel.uw_price_min = model.price_min;
    vc.registerModel.uw_price_max = model.price_max;
    vc.registerModel.uw_price_rank_weight = model.price_rank_weight;
    vc.registerModel.uw_bus_stop_weight = model.bus_stop_weight;
    vc.registerModel.uw_hospital_weight = model.hospital_weight;
    vc.registerModel.uw_shop_weight = model.shop_weight;
    vc.registerModel.uw_school_weight = model.school_weight;
    vc.registerModel.uw_env_weight = model.env_weight;
    vc.registerModel.uw_prime = model.prime;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
