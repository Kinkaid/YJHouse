//
//  YJUserCenterViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/17.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJUserCenterViewController.h"
#import <StoreKit/StoreKit.h>
#import "YJUserCenterViewCell.h"
#import "YJMessageCenterViewController.h"
#define kcellIdentifier  @"YJUserCenterViewCell"
#import "YJPersonInfoViewController.h"
#import "YJXiaoquCollectionViewController.h"
#import "YJCollectionSecondHandViewController.h"
#import "YJFeedbackViewController.h"
#import "YJCollectionRentViewController.h"
#import "KLCPopup.h"
#import "WDShareUtil.h"
#import "YJLoadingAnimationView.h"
#import "WDAboutUsViewController.h"
#import "YJSettingViewController.h"
@interface YJUserCenterViewController ()<UITableViewDelegate,UITableViewDataSource,SKStoreProductViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic,strong) NSMutableArray *titleAry;
@property (nonatomic,strong) KLCPopup *klcManager;
@property (strong, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *mgsCount;
@property (nonatomic,strong) NSMutableArray *msgCountAry;

@end

@implementation YJUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    self.msgCountAry = [@[] mutableCopy];
    [self registerTableView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:[LJKHelper getUserHeaderUrl]] placeholderImage:[UIImage imageNamed:@"icon_header_11"]];
    self.userName.text = [LJKHelper getUserName];
    [self msgCount];
}

- (void)msgCount {
    __weak typeof(self)weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:@"https://youjar.com/you/frontend/web/app/user/get-message-count" parameters:@{@"auth_key":[LJKHelper getAuth_key],@"time":ISEMPTY([LJKHelper getLastRequestMsgTime])?@"0":[LJKHelper getLastRequestMsgTime]} method:POST callBack:^(id responseObject) {
        if ([responseObject[@"result"][@"total_count"] intValue]) {
            weakSelf.mgsCount.hidden = NO;
            weakSelf.mgsCount.text = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"total_count"]];
            [weakSelf.msgCountAry removeAllObjects];
            [weakSelf.msgCountAry addObjectsFromArray:@[@([responseObject[@"result"][@"feedback"] intValue]),@([responseObject[@"result"][@"report"] intValue]),@([responseObject[@"result"][@"system"] intValue]),@([responseObject[@"result"][@"favourite_ershou"] intValue]),@([responseObject[@"result"][@"favourite_zufang"] intValue])]];
        } else {
            weakSelf.mgsCount.hidden = YES;
            [weakSelf.msgCountAry removeAllObjects];
            [weakSelf.msgCountAry addObjectsFromArray:@[@(0),@(0),@(0),@(0),@(0)]];
        }
    } error:^(NSError *error) {
        
    }];
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
    [self.tableView registerNib:[UINib nibWithNibName:kcellIdentifier bundle:nil] forCellReuseIdentifier:kcellIdentifier];
      self.headerView.frame = CGRectMake(0, -APP_SCREEN_WIDTH *0.67, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH *0.67);
    self.tableView.contentInset = UIEdgeInsetsMake(APP_SCREEN_WIDTH *0.67, 0, 0, 0);
    [self.tableView addSubview:self.headerView];
    self.titleAry = [NSMutableArray arrayWithObjects:
       @[@{@"title":@"我的收藏",@"img":@"icon_collection"},
         @{@"title":@"我收藏的租房",@"img":@""},
         @{@"title":@"我收藏的二手房",@"img":@""},
         @{@"title":@"我收藏的小区",@"img":@""}],
       @[@{@"title":@"关于我们",@"img":@"icon_aboutYJ"},
         @{@"title":@"意见反馈",@"img":@"icon_feedback"},
         @{@"title":@"推荐",@"img":@"icon_recommend"},
         @{@"title":@"评分",@"img":@"icon_score"}],nil];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleAry.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titleAry[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 38;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 0.01;
    }
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJUserCenterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kcellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[YJUserCenterViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kcellIdentifier];
    }
    cell.indexPath = indexPath;
    [cell showDataWithDic:self.titleAry[indexPath.section][indexPath.row]];
    if (indexPath.section == 0 &&indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 1:
            {
                YJCollectionRentViewController *vc = [[YJCollectionRentViewController alloc] init];
                PushController(vc);
            }
                break;
            case 2:
            {
                YJCollectionSecondHandViewController *vc = [[YJCollectionSecondHandViewController alloc] init];
                PushController(vc);
            }
                break;
            case 3:
            {
                YJXiaoquCollectionViewController *vc= [[YJXiaoquCollectionViewController alloc] init];
                PushController(vc);
            }
                break;
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
            {
                WDAboutUsViewController *vc = [[WDAboutUsViewController alloc] init];
                PushController(vc);
            }
                break;
            case 1:
            {
                YJFeedbackViewController *vc = [[YJFeedbackViewController alloc] init];
                PushController(vc);
            }
                break;
            case 2:
            {
                self.shareView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, 150);
                self.klcManager = [KLCPopup popupWithContentView:self.shareView];
                self.klcManager.showType = KLCPopupShowTypeSlideInFromBottom;
                self.klcManager.dismissType = KLCPopupDismissTypeSlideOutToBottom;
                [self.klcManager showAtCenter:CGPointMake(APP_SCREEN_WIDTH / 2.0, APP_SCREEN_HEIGHT - 75) inView:self.view];
            }
                break;
            case 3:
            {
                //初始化控制器
                SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
                //设置代理请求为当前控制器本身
                storeProductViewContorller.delegate = self;
                //加载一个新的视图展示
                [storeProductViewContorller loadProductWithParameters:
                 //appId唯一的
                 @{SKStoreProductParameterITunesItemIdentifier : @"1214131720"} completionBlock:^(BOOL result, NSError *error) {
                     //block回调
                     if(error){
                         NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
                     }else{
                         //模态弹出appstore
                         [self presentViewController:storeProductViewContorller animated:YES completion:^{
                             
                         }
                          ];
                     }
                 }];
            }
                break;
            default:
                break;
        }
    }
}
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ((-scrollView.contentOffset.y) > APP_SCREEN_WIDTH *0.67) {
        [self stretchHeaderView:-scrollView.contentOffset.y];
    } else {
        [self stretchHeaderView:APP_SCREEN_WIDTH *0.67];
    }
}
- (void)stretchHeaderView:(CGFloat)headerHeight {
    self.headerView.frame = CGRectMake(0, -headerHeight, APP_SCREEN_WIDTH, headerHeight);
}
#pragma mark - IBActions

- (IBAction)shareType:(id)sender {
    [self.klcManager dismiss:YES];
    UIButton *btn = sender;
    switch (btn.tag) {
        case 11:
        {
         [WDShareUtil shareTye:shareWXFriends withImageAry:@[@"https://youjar.com/you/frontend/web/upload/images/avatar/2017/14968439912815121.jpg"] withUrl:@"https://youjar.com/you/frontend/web/share/home" withTitle:@"测试title" withContent:@"测试content"];
        }
            break;
        case 12:
        {
            [WDShareUtil shareTye:shareWXzone withImageAry:@[@"https://youjar.com/you/frontend/web/upload/images/avatar/2017/14968439912815121.jpg"] withUrl:@"https://youjar.com/you/frontend/web/share/home" withTitle:@"测试微信title" withContent:@"测试微信content"];
        }
            break;
        case 13:
        {
             [WDShareUtil shareTye:shareQQFriends withImageAry:@[@"https://youjar.com/you/frontend/web/upload/images/avatar/2017/14968439912815121.jpg"] withUrl:@"https://youjar.com/you/frontend/web/share/home" withTitle:@"高性价比房源信息" withContent:@"买房租房就上优家网"];
        }
            break;
        case 14:
        {
             [WDShareUtil shareTye:shareQQzone withImageAry:@[@"https://youjar.com/you/frontend/web/upload/images/avatar/2017/14968439912815121.jpg"] withUrl:@"https://youjar.com/you/frontend/web/share/home" withTitle:@"测试QQ分享title" withContent:@"测试QQ分享content"];
        }
            break;
        case 15:
        {
            [WDShareUtil shareTye:shareSinaWeibo withImageAry:@[@"https://youjar.com/you/frontend/web/upload/images/avatar/2017/14968439912815121.jpg"] withUrl:@"https://youjar.com/you/frontend/web/share/home" withTitle:@"测试QQ分享title" withContent:@"测试QQ分享content"];
        }
            break;
        default:
            break;
    }
}


- (IBAction)cancelAction:(id)sender {
    [self.klcManager dismiss:YES];
}

- (IBAction)messageCenterAction:(id)sender {
    YJMessageCenterViewController *vc = [[YJMessageCenterViewController alloc] init];
    vc.msgCount = self.msgCountAry;
    PushController(vc);
}
- (IBAction)settingAction:(id)sender {
    YJSettingViewController *vc = [[YJSettingViewController alloc] init];
    PushController(vc);
}

- (IBAction)userHeaderClick:(id)sender {
    YJPersonInfoViewController *vc = [[YJPersonInfoViewController alloc] init];
    PushController(vc);
}
@end
