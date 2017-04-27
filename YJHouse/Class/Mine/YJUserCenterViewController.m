//
//  YJUserCenterViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/17.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJUserCenterViewController.h"
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
@interface YJUserCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic,strong) NSMutableArray *titleAry;
@property (nonatomic,strong) KLCPopup *klcManager;
@property (strong, nonatomic) IBOutlet UIView *shareView;

@end

@implementation YJUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self registerTableView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationBar.hidden = YES;
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
    self.headerView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH *0.67);
    [self.tableView setTableHeaderView:self.headerView];
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
                
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark - IBActions

- (IBAction)shareType:(id)sender {
    [self.klcManager dismiss:YES];
    UIButton *btn = sender;
    switch (btn.tag) {
        case 11:
        {
         [WDShareUtil shareTye:shareWXFriends withImageAry:@[@"http://upload.wadao.com/fx/cc_logo/20170401/eddc0a05b94037e81011e62c87b64faa.png"] withUrl:@"http://m.wadao.com/fx/926" withTitle:@"测试title" withContent:@"测试content"];
        }
            break;
        case 12:
        {
            [WDShareUtil shareTye:shareWXzone withImageAry:@[@"http://upload.wadao.com/fx/cc_logo/20170401/eddc0a05b94037e81011e62c87b64faa.png"] withUrl:@"http://m.wadao.com/fx/926" withTitle:@"测试微信title" withContent:@"测试微信content"];
        }
            break;
        case 13:
        {
             [WDShareUtil shareTye:shareQQFriends withImageAry:@[@"http://test.wadao.com/uploads/fx/cc_logo/20170425/94e693e913f1b3c9b54b6a1819871e96.png"] withUrl:@"https://www.baidu.com" withTitle:@"高性价比房源信息" withContent:@"买房租房就上优家网"];
        }
            break;
        case 14:
        {
             [WDShareUtil shareTye:shareQQzone withImageAry:@[@"http://upload.wadao.com/fx/cc_logo/20170401/eddc0a05b94037e81011e62c87b64faa.png"] withUrl:@"http://m.wadao.com/fx/926" withTitle:@"测试QQ分享title" withContent:@"测试QQ分享content"];
        }
            break;
        case 15:
        {
            
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
    PushController(vc);
}

- (IBAction)userHeaderClick:(id)sender {
    YJPersonInfoViewController *vc = [[YJPersonInfoViewController alloc] init];
    PushController(vc);
}
@end
