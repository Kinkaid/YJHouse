//
//  YJFiveStepViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/2.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJFiveStepViewController.h"
#import "YJFiveStepCollectionViewCell.h"
#define kCellId @"YJFiveStepCollectionViewCell"
#import "YJTabBarSystemController.h"
@interface YJFiveStepViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *picAry;
@property (nonatomic,strong) NSMutableArray *titleAry;
@property (nonatomic,strong) NSMutableArray *selectAry;
@property (nonatomic,strong) NSMutableArray *selectValueAry;

@end

@implementation YJFiveStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    [self registerCollectionView];
}
- (void)registerCollectionView {
    [self.collectionView registerNib:[UINib nibWithNibName:kCellId bundle:nil] forCellWithReuseIdentifier:kCellId];
    self.picAry = [@[] mutableCopy];
    self.titleAry = [@[] mutableCopy];
    self.selectAry = [@[] mutableCopy];
    self.selectValueAry = [@[] mutableCopy];
    [self.picAry addObjectsFromArray:@[@"icon_xyj",@"icon_c",@"icon_bx",@"icon_wl",@"icon_ds",@"icon_rsq",@"icon_kt",@"icon_trq",@"icon_jj"]];
    [self.titleAry addObjectsFromArray:@[@"洗衣机",@"床",@"冰箱",@"网络",@"电视",@"热水器",@"空调",@"天然气",@"家具"]];
    [self.selectValueAry addObjectsFromArray:@[@(11),@(2),@(13),@(5),@(17),@(7),@(3),@(23),@(19)]];
    if ([self.registerModel.uw_prime integerValue] ==0) {
        [self.selectAry addObjectsFromArray:@[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)]];
        return;
    }
    for (int i=0; i<self.selectValueAry.count; i++) {
        if ([self.registerModel.uw_prime integerValue] % [self.selectValueAry[i] intValue]) {
            [self.selectAry addObject:@(NO)];
        } else {
            [self.selectAry addObject:@(YES)];
        }
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.picAry.count;
}
//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 9.0;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 40.0, 9.0, 40.0);
}
//最小内部对象间距(也就是同一行,两个cell间的距离)
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 9.0;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((APP_SCREEN_WIDTH -120.0) / 3.0, ((APP_SCREEN_WIDTH -120.0) / 3.0) * 189.0 /168.0  + 26);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YJFiveStepCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    [cell showDataWithTitle:self.titleAry[indexPath.row] andImg:self.picAry[indexPath.row] andSelect:[self.selectAry[indexPath.row] boolValue]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.selectAry[indexPath.row] boolValue]) {
        [self.selectAry replaceObjectAtIndex:indexPath.row withObject:@(NO)];
    } else {
       [self.selectAry replaceObjectAtIndex:indexPath.row withObject:@(YES)];
    }
    [self.collectionView reloadData];
}

- (IBAction)nextStepClick:(id)sender {
    long long value = 1;
    for (int i=0; i<self.selectAry.count; i++) {
        if ([self.selectAry[i] boolValue]) {
            value = value * [self.selectValueAry[i] integerValue];
        }
    }
    if (value == 1) {
        [YJApplicationUtil alertHud:@"请至少选择一项" afterDelay:1];
        return;
    }
    self.registerModel.uw_prime = [NSString stringWithFormat:@"%lld",value];
    [SVProgressHUD show];
    if (ISEMPTY([LJKHelper getAuth_key])) {
        [[NetworkTool sharedTool] requestWithURLString:@"https://youjar.com/you/frontend/web/app/user/signup" parameters:@{@"device_uid":[[[UIDevice currentDevice] identifierForVendor] UUIDString]} method:POST callBack:^(id responseObject) {
            if (!ISEMPTY(responseObject) ||ISEMPTY(responseObject[@"result"])) {
                [LJKHelper saveUserName:responseObject[@"result"][@"user_info"][@"username"]];
                [LJKHelper saveAuth_key:responseObject[@"result"][@"user_info"][@"auth_key"]];
                [self submitUserPrivateCustom];
            }
        } error:^(NSError *error) {
            
        }];
    } else {
        [self submitUserPrivateCustom];
    }
}
- (void)submitUserPrivateCustom {
    NSDictionary *params;
    if (ISEMPTY(self.registerModel.uw_region2_id)) {
        params = @{@"auth_key":[LJKHelper getAuth_key],@"uwz[active]":@"1",@"uwz[name]":@"私人订制",@"uwz[region1_id]":self.registerModel.uw_region1_id,@"uwz[region1_weight]":@"10",@"uwz[price_min]":self.registerModel.uw_price_min,@"uwz[price_max]":self.registerModel.uw_price_max,@"uwz[price_rank_weight]":@"10",@"uwz[bus_stop_weight]":self.registerModel.uw_bus_stop_weight,@"uwz[hospital_weight]":self.registerModel.uw_hospital_weight,@"uwz[shop_weight]":self.registerModel.uw_shop_weight,@"uwz[school_weight]":self.registerModel.uw_school_weight,@"uwz[env_weight]":self.registerModel.uw_env_weight,@"uwz[prime]":self.registerModel.uw_prime};
    } else {
        params = @{@"auth_key":[LJKHelper getAuth_key],@"uwz[active]":@"1",@"uwz[name]":@"私人订制",@"uwz[region1_id]":self.registerModel.uw_region1_id,@"uwz[region1_weight]":@"10",@"uwz[region2_id]":self.registerModel.uw_region2_id,@"uwz[region2_weight]":@"10",@"uwz[price_min]":self.registerModel.uw_price_min,@"uwz[price_max]":self.registerModel.uw_price_max,@"uwz[price_rank_weight]":@"10",@"uwz[bus_stop_weight]":self.registerModel.uw_bus_stop_weight,@"uwz[hospital_weight]":self.registerModel.uw_hospital_weight,@"uwz[shop_weight]":self.registerModel.uw_shop_weight,@"uwz[school_weight]":self.registerModel.uw_school_weight,@"uwz[env_weight]":self.registerModel.uw_env_weight,@"uwz[prime]":self.registerModel.uw_prime};
    }
    NSMutableDictionary *mParams = [NSMutableDictionary dictionaryWithDictionary:params];
    if (self.edit) {
        [mParams setObject:self.registerModel.weight_id forKey:@"weight_id"];
    }
    [[NetworkTool sharedTool] requestWithURLString:@"https://youjar.com/you/frontend/web/app/user/save-user-weight" parameters:mParams method:POST callBack:^(id responseObject) {
        if (!ISEMPTY(responseObject)) {
            [SVProgressHUD dismiss];
            if (self.registerModel.firstEnter) {
                 [LJKHelper saveZufangWeight_id:responseObject[@"result"][@"weight_id"]];
                [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"houseTypeKey"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                self.view.window.rootViewController = [[YJTabBarSystemController alloc] init];
                [self.view removeFromSuperview];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kEditPrivateCustomNotification" object:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
        }
    } error:^(NSError *error) {
        
    }];
}
@end
