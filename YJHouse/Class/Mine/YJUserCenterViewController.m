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
#import "WDLoginViewController.h"
#import "YJLoginView.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
@interface YJUserCenterViewController ()<UITableViewDelegate,UITableViewDataSource,SKStoreProductViewControllerDelegate,YJLoginViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic,strong) NSMutableArray *titleAry;
@property (nonatomic,strong) KLCPopup *klcManager;
@property (strong, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *mgsCount;
@property (nonatomic,strong) NSMutableArray *msgCountAry;
@property (nonatomic,strong) YJLoginView *loginView;

@end

@implementation YJUserCenterViewController

- (YJLoginView *)loginView {
    if (!_loginView) {
        _loginView = [[YJLoginView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH - 80, 220)];
        _loginView.delegate = self;
        _loginView.backgroundColor = [UIColor whiteColor];
    }
    return _loginView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    self.msgCountAry = [@[] mutableCopy];
    [self registerTableView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:[LJKHelper getUserHeaderUrl]] placeholderImage:[UIImage imageNamed:@"icon_header_11"]];
    self.userName.text = [LJKHelper thirdLoginSuccess]?[LJKHelper getUserName]:@"QQ/微博登陆";
    [self msgCount];
}

- (void)msgCount {
    __weak typeof(self)weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/get-message-count",Server_url] parameters:@{@"time":ISEMPTY([LJKHelper getLastRequestMsgTime])?@"0":[LJKHelper getLastRequestMsgTime],@"auth_key":[LJKHelper getAuth_key]} method:POST callBack:^(id responseObject) {
        if (ISEMPTY(responseObject[@"error"])) {
            if ([responseObject[@"result"][@"total_count"] intValue]) {
                [self.tabBarController.tabBar showBadgeOnItemIndex:2];
                weakSelf.mgsCount.hidden = NO;
                weakSelf.mgsCount.text = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"total_count"]];
                [weakSelf.msgCountAry removeAllObjects];
                [weakSelf.msgCountAry addObjectsFromArray:@[
                                                            @([responseObject[@"result"][@"favourite_ershou"] intValue]),
                                                            @([responseObject[@"result"][@"favourite_zufang"] intValue]),                                                            @([responseObject[@"result"][@"xiaoqu_ershou_new"] intValue]),                                                            @([responseObject[@"result"][@"xiaoqu_zufang_new"] intValue]),                                                            @([responseObject[@"result"][@"user_reply"] intValue] +[responseObject[@"result"][@"user_call"] intValue]),
                                                            @([responseObject[@"result"][@"feedback"] intValue]),
                                                            @([responseObject[@"result"][@"report"] intValue]),
                                                            @([responseObject[@"result"][@"system"] intValue])
                                                            ]];
            } else {
                weakSelf.mgsCount.hidden = YES;
                [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
                [weakSelf.msgCountAry removeAllObjects];
                [weakSelf.msgCountAry addObjectsFromArray:@[@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0)]];
            }
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
    if (indexPath.section == 0 &&indexPath.row == 0) {
        return 40;
    }
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 14;
    } else {
        return 0.01;
    }
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
                if([SKStoreReviewController respondsToSelector:@selector(requestReview)]){
                    [SKStoreReviewController requestReview];
                } else {
                    [SVProgressHUD show];
                    //初始化控制器
                    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
                    //设置代理请求为当前控制器本身
                    storeProductViewContorller.delegate = self;
                    //加载一个新的视图展示
                    [storeProductViewContorller loadProductWithParameters:
                     //appId唯一的
                     @{SKStoreProductParameterITunesItemIdentifier : @"1241832323"} completionBlock:^(BOOL result, NSError *error) {
                         //block回调
                         if(!error){
                             //模态弹出appstore
                             [self presentViewController:storeProductViewContorller animated:YES completion:^{
                                 [SVProgressHUD dismiss];
                             }];
                         }
                     }];
                }
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
            [WDShareUtil shareTye:shareWXFriends withImageAry:@[[UIImage imageNamed:@"logo"]] withUrl:@"https://www.youjar.com/share/home" withTitle:@"优家选房，选出您的家" withContent:@"拿出手机赶紧下载优家选房APP哦" isPic:NO];
        }
            break;
        case 12:
        {
            [WDShareUtil shareTye:shareWXzone withImageAry:@[[UIImage imageNamed:@"logo"]] withUrl:@"https://www.youjar.com/share/home" withTitle:@"优家选房，选出您的家" withContent:@"拿出手机赶紧下载优家选房APP哦" isPic:NO];
        }
            break;
        case 13:
        {
             [WDShareUtil shareTye:shareQQFriends withImageAry:@[[UIImage imageNamed:@"logo"]] withUrl:@"https://www.youjar.com/share/home" withTitle:@"优家选房，选出您的家" withContent:@"拿出手机赶紧下载优家选房APP哦" isPic:NO];
        }
            break;
        case 14:
        {
             [WDShareUtil shareTye:shareQQzone withImageAry:@[[UIImage imageNamed:@"logo"]] withUrl:@"https://www.youjar.com/share/home" withTitle:@"优家选房，选出您的家" withContent:@"拿出手机赶紧下载优家选房APP哦" isPic:NO];
        }
            break;
        case 15:
        {
            [WDShareUtil shareTye:shareSinaWeibo withImageAry:@[[UIImage imageNamed:@"logo"]] withUrl:@"https://www.youjar.com/share/home" withTitle:@"优家选房，选出您的家" withContent:@"拿出手机赶紧下载优家选房APP哦" isPic:NO];
        }
            break;
        default:
            break;
    }
}
-(void)shareFriendWithImg:(UIImage *)shareImg {
    UIActivityViewController *activityViewController =[[UIActivityViewController alloc] initWithActivityItems:@[shareImg] applicationActivities:nil];
    //去除多余的分享模块
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypePrint,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeOpenInIBooks];
    //初始化Block回调方法,此回调方法是在iOS8之后出的，代替了之前的方法
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
    {
        if (completed) {
            [YJApplicationUtil alertHud:@"分享成功" afterDelay:1];
        }
    };
    activityViewController.completionWithItemsHandler = myBlock;
    if (activityViewController) {
        [self presentViewController:activityViewController animated:TRUE completion:^{
        }];
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
    if ([LJKHelper thirdLoginSuccess]) {
        YJPersonInfoViewController *vc = [[YJPersonInfoViewController alloc] init];
        PushController(vc);
    } else {
        self.klcManager = [KLCPopup popupWithContentView:self.loginView];
        [self.klcManager show];
    }
}
#pragma mark -- YJLoginViewDelegate
- (void)wxLoginAction {
    [self.klcManager dismiss:YES];
//    if([QQApiInterface isQQInstalled]){
        [ShareSDK getUserInfo:SSDKPlatformTypeQQ
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             if (state == SSDKResponseStateSuccess) {
                 [SVProgressHUD show];
                 NSDictionary *params = @{@"type":@"1",@"tuid":user.uid,@"username":user.nickname,@"device_uid":[[[UIDevice currentDevice] identifierForVendor] UUIDString]};
                 [self thirdLogin:params nick:user.nickname icon:user.icon];
             } else {
                 [YJApplicationUtil alertHud:@"QQ授权失败，请重新尝试" afterDelay:1];
             }
         }];
//    } else {
//        [YJApplicationUtil alertHud:@"请安装QQ客户端授权登录" afterDelay:1];
//    }
}
- (void)sinaLoginAction {
    [self.klcManager dismiss:YES];
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess) {
             //             NSLog(@"uid=%@",user.uid);
             //             NSLog(@"%@",user.credential);
             //             NSLog(@"token=%@",user.credential.token);
             //             NSLog(@"nickname=%@",user.nickname);
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD show];
                 NSDictionary *params = @{@"type":@"2",@"tuid":user.uid,@"username":user.nickname,@"device_uid":[[[UIDevice currentDevice] identifierForVendor] UUIDString]};
                 [self thirdLogin:params nick:user.nickname icon:user.icon];
             });
         } else {
             [YJApplicationUtil alertHud:@"微博授权失败，请重新尝试" afterDelay:1];
         }
     }];
}
- (void)thirdLogin:(NSDictionary *)params nick:(NSString *)nick icon:(NSString *)icon {
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/signup",Server_url] parameters:params method:POST callBack:^(id responseObject) {
        [LJKHelper saveAuth_key:responseObject[@"result"][@"user_info"][@"auth_key"]];
        [LJKHelper saveUserID:responseObject[@"result"][@"user_info"][@"user_id"]];
        [LJKHelper saveUserName:responseObject[@"result"][@"user_info"][@"username"]];
        [LJKHelper saveThirdLoginState];
        [self postHeaderImg:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:icon]]]];
        [SVProgressHUD dismiss];
        [self.headerImg sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"icon_header_11"]];
        self.userName.text = [LJKHelper getUserName];
        [self bindRemotePushCid];
    } error:^(NSError *error) {
        [YJApplicationUtil alertHud:@"第三方登录失败" afterDelay:1];
    }];
}
- (void)bindRemotePushCid{
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/set-cid",Server_url] parameters:@{@"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"],@"auth_key":[LJKHelper getAuth_key]} method:POST callBack:^(id responseObject) {
        
    } error:^(NSError *error) {
        NSLog(@"绑定cid错误");
    }];
}
- (void)postHeaderImg:(UIImage *)image {
    [SVProgressHUD show];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"multipart/form-data",
                                                                @"text/html",
                                                                @"image/jpeg",
                                                                @"image/png",
                                                                @"application/octet-stream",
                                                                @"text/json",
                                                                nil];
    [sessionManager POST:[NSString stringWithFormat:@"%@/user/set-avatar",Server_url] parameters:@{@"auth_key":[LJKHelper getAuth_key]} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传文件
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        [formData appendPartWithFileData:imageData name:@"avatar_image" fileName:fileName mimeType:@"image/jpg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            [LJKHelper saveUserHeader:[NSString stringWithFormat:@"https://youjar.com%@",[responseObject[@"result"] lastObject]]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kEditPrivateCustomNotification" object:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:@"上传失败,请重试"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kEditPrivateCustomNotification" object:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"上传失败,请重试"];
    }];
}
@end
