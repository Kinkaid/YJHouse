//
//  YJXiaoQuDetailViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/3/25.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJXiaoQuDetailViewController.h"
#import "YQFiveStarView.h"
#import "YJXiaoquDetailModel.h"
#import "YJDate.h"
#import "YJHouseListModel.h"
#import "YJRecommondViewController.h"
#import "YJMapView.h"
#import "YJMapDetailViewController.h"
#import "KLCPopup.h"
#import "WDShareUtil.h"
#import "KLCPopup.h"
#import "YJLoginView.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <ShareSDK/ShareSDK.h>
@interface YJXiaoQuDetailViewController ()<YJRequestTimeoutDelegate,UIScrollViewDelegate,YJLoginViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *mapContainerView;
@property (nonatomic,strong) YJMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *main_img;
@property (weak, nonatomic) IBOutlet UILabel *region;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *property_type;
@property (weak, nonatomic) IBOutlet YQFiveStarView *scoreView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *avg_price;

@property (weak, nonatomic) IBOutlet UILabel *school_count;
@property (weak, nonatomic) IBOutlet UILabel *hospital_count;
@property (weak, nonatomic) IBOutlet UILabel *shop_count;
@property (weak, nonatomic) IBOutlet UILabel *bus_stop_count;
@property (weak, nonatomic) IBOutlet UILabel *total_family;
@property (weak, nonatomic) IBOutlet UILabel *green_rate;

@property (weak, nonatomic) IBOutlet UILabel *plate;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *ershou_in;
@property (weak, nonatomic) IBOutlet UILabel *volume;
@property (weak, nonatomic) IBOutlet UILabel *zufang_in;
@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UILabel *tjzfLabel;
@property (weak, nonatomic) IBOutlet UILabel *tjershouLabel;
@property (nonatomic,strong) YJXiaoquDetailModel *model;

@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIButton *toScoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *dislikeBtn;
@property (weak, nonatomic) IBOutlet UIView *showView;

@property (nonatomic,strong) NSMutableArray *ershouAry;
@property (nonatomic,strong) NSMutableArray *zufangAry;
@property (strong, nonatomic) IBOutlet UIView *shareView;
@property (nonatomic,strong) KLCPopup *klcpopupManager;
@property (nonatomic,strong) YJLoginView *loginView;
@property (nonatomic,strong) KLCPopup *klcManager;

@end

@implementation YJXiaoQuDetailViewController

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
    self.navigationBar.alpha = 0;
    [self setTitle:@"小区详情"];
    [YJRequestTimeoutUtil shareInstance].delegate = self;
    [self setContentScrollView];
    [YJGIFAnimationView showInView:self.view frame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    [self loadXiaoquDetail];
}
- (void)requestTimeoutAction {
    if (self.isVisible) {
        [self loadXiaoquDetail];
    }
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadXiaoquDetail {
    __weak typeof(self)weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/xiaoqu/item-info",Server_url] parameters:@{@"id":self.xiaoquId,@"auth_key":[LJKHelper getAuth_key]} method:GET callBack:^(id responseObject) {
        [YJGIFAnimationView hideInView:self.view];
      if (responseObject[@"result"]) {
          if ([responseObject[@"result"][@"evaluate"] intValue] ==0) {
              weakSelf.dislikeBtn.selected = NO;
              weakSelf.likeBtn.selected = NO;
          } else {
              weakSelf.dislikeBtn.selected = YES;
              weakSelf.likeBtn.selected = YES;
          }
          if ([responseObject[@"result"][@"favourite"] intValue] == 1) {
              weakSelf.collectionBtn.selected = YES;
              [weakSelf.collectionBtn setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
          } else {
              weakSelf.collectionBtn.selected = NO;
          }
          weakSelf.ershouAry = [@[] mutableCopy];
          weakSelf.zufangAry = [@[] mutableCopy];
          if (!ISEMPTY(responseObject[@"result"][@"recommand"])) {
              for (int i=0; i<[responseObject[@"result"][@"recommand"][@"ershou"] count]; i++) {
                  YJHouseListModel *model = [MTLJSONAdapter modelOfClass:[YJHouseListModel class] fromJSONDictionary:responseObject[@"result"][@"recommand"][@"ershou"][i] error:nil];
                  model.zufang = NO;
                  model.topcut = @"";
                  [weakSelf.ershouAry addObject:model];
              }
              for (int j=0; j<[responseObject[@"result"][@"recommand"][@"zufang"] count]; j++) {
                  YJHouseListModel *model = [MTLJSONAdapter modelOfClass:[YJHouseListModel class] fromJSONDictionary:responseObject[@"result"][@"recommand"][@"zufang"][j] error:nil];
                  model.zufang = YES;
                  model.topcut = @"";
                  [weakSelf.zufangAry addObject:model];
              }
          }
          self.tjzfLabel.text = [NSString stringWithFormat:@"推荐租房：%lu",weakSelf.zufangAry.count];
          self.tjershouLabel.text = [NSString stringWithFormat:@"推荐二手房：%lu",weakSelf.ershouAry.count];
          YJXiaoquDetailModel *model = [MTLJSONAdapter modelOfClass:[YJXiaoquDetailModel class] fromJSONDictionary:responseObject[@"result"][@"info"] error:nil];
          weakSelf.model = model;
          [weakSelf fillDataWithModel];
      }
    } error:^(NSError *error) {
        
    }];
}
- (void)setContentScrollView {
    self.scrollView.contentSize = CGSizeMake(APP_SCREEN_WIDTH, 997 + APP_SCREEN_WIDTH *0.7);
    self.contentView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, 997 + APP_SCREEN_WIDTH *0.7);
    [self.scrollView addSubview:self.contentView];
}
- (void)fillDataWithModel {
    self.region.text = self.model.region;
    [self.main_img sd_setImageWithURL:[NSURL URLWithString:self.model.main_img] placeholderImage:[UIImage imageNamed:@"icon_placeholder2"]];
    self.property_type.text = [NSString stringWithFormat:@"  %@  ",self.model.property_type];
    self.avg_price.text = [NSString stringWithFormat:@"%@",self.model.avg_price];
    self.volume.text = [NSString stringWithFormat:@"%@",self.model.volume];
    self.name.text = self.model.name;
    self.scoreView.Score = self.model.score;
    self.scoreLabel.text = [NSString stringWithFormat:@"(%@)",self.model.score];
    self.plate.text = [NSString stringWithFormat:@"  所在商圈:%@",self.model.plate];
    self.age.text = [NSString stringWithFormat:@"竣工时间:%@",[YJDate parseRemoteDataToString:self.model.age withFormatterString:@"yyyy年MM月"]];
    self.ershou_in.text = [NSString stringWithFormat:@"二手房在售:%@",self.model.ershou_in];
    self.zufang_in.text = [NSString stringWithFormat:@"  出租房在租:%@",self.model.zufang_in];
    self.total_family.text = [NSString stringWithFormat:@"  总户数:%@",self.model.total_family];
    self.green_rate.text = [NSString stringWithFormat:@"绿化率:%.0f%%",[self.model.green_rate floatValue] * 100.0];
    
    NSMutableAttributedString *schoolCountStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"附近有%@所学校",self.model.school_count]];
    [schoolCountStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(3, [self.model.school_count isKindOfClass:[NSString class]]?[self.model.school_count length]:[self.model.school_count stringValue].length)];
    [schoolCountStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"FFC177"] range:NSMakeRange(3, [self.model.school_count isKindOfClass:[NSString class]]?[self.model.school_count length]:[self.model.school_count stringValue].length)];
    self.school_count.attributedText = schoolCountStr;
    
    
    NSMutableAttributedString *shopCountStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"附近有%@个超市",self.model.shop_count]];
    [shopCountStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(3, [self.model.shop_count isKindOfClass:[NSString class]]?[self.model.shop_count length]:[self.model.shop_count stringValue].length)];
    [shopCountStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"FFC177"] range:NSMakeRange(3, [self.model.shop_count isKindOfClass:[NSString class]]?[self.model.shop_count length]:[self.model.shop_count stringValue].length)];
    self.shop_count.attributedText = shopCountStr;
    
    NSMutableAttributedString *hospitalCountStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"附近有%@所医院",self.model.hospital_count]];
    [hospitalCountStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(3, [self.model.hospital_count isKindOfClass:[NSString class]]?[self.model.hospital_count length]:[self.model.hospital_count stringValue].length)];
    [hospitalCountStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"FFC177"] range:NSMakeRange(3, [self.model.hospital_count isKindOfClass:[NSString class]]?[self.model.hospital_count length]:[self.model.hospital_count stringValue].length)];
    self.hospital_count.attributedText = hospitalCountStr;

   
    NSMutableAttributedString *busCountStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"附近有%@个公交站牌",self.model.bus_stop_count]];
    [busCountStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(3, [self.model.bus_stop_count isKindOfClass:[NSString class]]?[self.model.bus_stop_count length]:[self.model.bus_stop_count stringValue].length)];
    [busCountStr addAttribute:NSForegroundColorAttributeName value:[UIColor ex_colorFromHexRGB:@"FFC177"] range:NSMakeRange(3, [self.model.bus_stop_count isKindOfClass:[NSString class]]?[self.model.bus_stop_count length]:[self.model.bus_stop_count stringValue].length)];
    self.bus_stop_count.attributedText = busCountStr;
    
    self.address.text = [NSString stringWithFormat:@"      地址:%@-%@-%@",self.model.region,self.model.plate,self.model.name];
    self.mapView = [[YJMapView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 200)];
    [self.mapContainerView addSubview:self.mapView];
    [self.mapContainerView sendSubviewToBack:self.mapView];
    UIControl *mapSender = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 200)];
    mapSender.backgroundColor = [UIColor clearColor];
    [mapSender addTarget:self action:@selector(mapClick) forControlEvents:UIControlEventTouchUpInside];
    [self.mapContainerView addSubview:mapSender];
    NSString *address = [NSString stringWithFormat:@"http://restapi.amap.com/v3/geocode/geo?key=389880a06e3f893ea46036f030c94700&s=rsv3&city=35&address=浙江省杭州市%@%@%@",self.model.region,self.model.plate,self.model.name];
    NSString* encodedString = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak typeof(self)weakSelf = self;
    [[NetworkTool sharedTool]requestWithURLString:encodedString parameters:nil method:GET callBack:^(id responseObject) {
        if (!ISEMPTY(responseObject[@"geocodes"])) {
            NSArray *ary = [responseObject[@"geocodes"][0][@"location"] componentsSeparatedByString:@","];
            [weakSelf.mapView showLongitude:[ary[0] floatValue ]andLatitude:[ary[1] floatValue]];
        }
    } error:^(NSError *error) {
    }];
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%@",self.model.good] forState:UIControlStateNormal];
    [self.dislikeBtn setTitle:[NSString stringWithFormat:@"%@",self.model.bad] forState:UIControlStateNormal];
    CGFloat total = ([self.model.good floatValue] + [self.model.bad floatValue]);
    CGFloat ratio = [self.model.good floatValue] / (total == 0 ?1:total) * 100;
    [self.toScoreBtn setTitle:[NSString stringWithFormat:@"  %.0f%%",ratio] forState:UIControlStateNormal];
    [self.collectionBtn setTitle:[NSString stringWithFormat:@"  %@",self.model.favourite_count] forState:UIControlStateNormal];
    [SVProgressHUD dismiss];
    
}
- (void)mapClick {
    YJMapDetailViewController *vc = [[YJMapDetailViewController alloc] init];
    vc.address = [NSString stringWithFormat:@"%@%@%@",self.model.region,self.model.plate,self.model.name];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.navigationBar.alpha = (scrollView.contentOffset.y - 64) / 64.0;
}
- (IBAction)collectionAction:(id)sender {
    if ([LJKHelper thirdLoginSuccess]) {
        __weak typeof(self) weakSelf = self;
        NSString *url;
        if (self.collectionBtn.selected) {
            url = [NSString stringWithFormat:@"%@/user/cancel-favourite",Server_url];
        } else {
            url = [NSString stringWithFormat:@"%@/user/set-favourite",Server_url];
        }
        NSDictionary *params = @{@"auth_key":[LJKHelper getAuth_key],@"site":self.model.site,@"id":self.xiaoquId};
        [[NetworkTool sharedTool] requestWithURLString:url parameters:params method:POST callBack:^(id responseObject) {
            if (!ISEMPTY(responseObject[@"result"])) {
                if ([responseObject[@"result"] isEqualToString:@"success"]) {
                    if (weakSelf.collectionBtn.selected) {
                        [weakSelf.collectionBtn setImage:[UIImage imageNamed:@"icon_dislike"] forState:UIControlStateNormal];
                        [weakSelf.collectionBtn setTitle:[NSString stringWithFormat:@" %d",[weakSelf.collectionBtn.titleLabel.text intValue] - 1] forState:UIControlStateNormal];
                    } else {
                        [weakSelf.collectionBtn setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
                        [weakSelf.collectionBtn setTitle:[NSString stringWithFormat:@" %d",[weakSelf.collectionBtn.titleLabel.text intValue] + 1] forState:UIControlStateNormal];
                    }
                    weakSelf.collectionBtn.selected = !self.collectionBtn.selected;
                }
            }
        } error:^(NSError *error) {
            
        }];
    } else {
        self.klcManager = [KLCPopup popupWithContentView:self.loginView];
        [self.klcManager show];
    }
}
- (IBAction)toSelectAction:(id)sender {
    [UIView animateWithDuration:0.4 animations:^{
        self.selectView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH - 160.0, 46);
        self.showView.frame = CGRectMake(0, 46, APP_SCREEN_WIDTH - 160, 46);
    } completion:^(BOOL finished) {
    }];
}
- (IBAction)likeAction:(id)sender {
    UIView *bottonView = [self.view viewWithTag:10];
    [UIView animateWithDuration:0.4 animations:^{
        self.selectView.frame = CGRectMake(0, 46, APP_SCREEN_WIDTH - 160.0, 46);
        self.showView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH - 160, 46);
    } completion:^(BOOL finished) {
        [bottonView bringSubviewToFront:self.selectView];
    }];
    [bottonView bringSubviewToFront:self.showView];
    if (self.dislikeBtn.selected ||self.likeBtn.selected) {
        [YJApplicationUtil alertHud:@"已打过分" afterDelay:1];
        return;
    }
    NSDictionary *params = @{@"auth_key":[LJKHelper getAuth_key],@"id":self.xiaoquId,@"site":self.model.site,@"eva":@"1"};
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/set-evaluate",Server_url] parameters:params method:POST callBack:^(id responseObject) {
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            [self.likeBtn setTitle:[NSString stringWithFormat:@" %d",[self.likeBtn.titleLabel.text intValue] +1] forState:UIControlStateNormal];
            [self.toScoreBtn setTitle:[NSString stringWithFormat:@" %.0f%%",([self.likeBtn.titleLabel.text floatValue] / ([self.dislikeBtn.titleLabel.text floatValue] +[self.likeBtn.titleLabel.text floatValue])) * 100] forState:UIControlStateNormal];
            self.likeBtn.selected = YES;
        }
    } error:^(NSError *error) {
        
    }];
}

- (IBAction)dislikeAction:(id)sender {
    UIView *bottonView = [self.view viewWithTag:10];
    [bottonView bringSubviewToFront:self.showView];
    [UIView animateWithDuration:0.4 animations:^{
        self.selectView.frame = CGRectMake(0, 46, APP_SCREEN_WIDTH - 160.0, 46);
        self.showView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH - 160, 46);
    } completion:^(BOOL finished) {
        [bottonView bringSubviewToFront:self.selectView];
    }];
    if (self.dislikeBtn.selected ||self.likeBtn.selected) {
        [YJApplicationUtil alertHud:@"已打过分" afterDelay:1];
        return;
    }
    NSDictionary *params = @{@"auth_key":[LJKHelper getAuth_key],@"id":self.xiaoquId,@"site":self.model.site,@"eva":@"-1"};
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/set-evaluate",Server_url] parameters:params method:POST callBack:^(id responseObject) {
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            [self.dislikeBtn setTitle:[NSString stringWithFormat:@" %d",[self.dislikeBtn.titleLabel.text intValue] +1] forState:UIControlStateNormal];
            [self.toScoreBtn setTitle:[NSString stringWithFormat:@" %.0f%%",([self.likeBtn.titleLabel.text floatValue] / ([self.dislikeBtn.titleLabel.text floatValue] +[self.likeBtn.titleLabel.text floatValue])) * 100] forState:UIControlStateNormal];
            self.dislikeBtn.selected = YES;
        }
    } error:^(NSError *error) {
        
    }];
}

- (IBAction)recomondAction:(id)sender {
    UIButton *btn = sender;
    YJRecommondViewController * vc= [[YJRecommondViewController alloc] init];
    if (btn.tag == 1) {
        if (!self.zufangAry.count) {
            return;
        }
        vc.houseAry = self.zufangAry;
        vc.mainTitle = @"推荐租房";
    } else {
        if (!self.ershouAry.count) {
            return;
        }
        vc.houseAry = self.ershouAry;
        vc.mainTitle = @"推荐二手房";
    }
    PushController(vc);
}

- (IBAction)shareAction:(id)sender {
    self.shareView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, 150);
    self.klcpopupManager = [KLCPopup popupWithContentView:self.shareView];
    self.klcpopupManager.showType = KLCPopupShowTypeSlideInFromBottom;
    self.klcpopupManager.dismissType = KLCPopupDismissTypeSlideOutToBottom;
    [self.klcpopupManager showAtCenter:CGPointMake(APP_SCREEN_WIDTH / 2.0, APP_SCREEN_HEIGHT - 75) inView:self.view];
}
- (IBAction)shareItemClick:(id)sender {
    [self.klcpopupManager dismiss:YES];
    [SVProgressHUD show];
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD show];
        self.contentView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, 997 + APP_SCREEN_WIDTH *0.7 + 62);
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 997 + APP_SCREEN_WIDTH *0.7, APP_SCREEN_WIDTH, 62)];
        bottomView.backgroundColor =[UIColor ex_colorFromHexRGB:@"DADADA"];
        UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 52, 52)];
        imgLogo.image = [UIImage imageNamed:@"icon_logo"];
        imgLogo.userInteractionEnabled = YES;
        imgLogo.layer.cornerRadius = 4;
        imgLogo.clipsToBounds = YES;
        [bottomView addSubview:imgLogo];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.textColor = [UIColor ex_colorFromHexRGB:@"1D1D1D"];
        [bottomView addSubview:nameLabel];
        nameLabel.text = @"优家选房";
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imgLogo.mas_right).offset(10);
            make.top.mas_equalTo(imgLogo.mas_top).offset(6);
        }];
        UILabel *subName = [[UILabel alloc] init];
        subName.text = @"最好用的找房神器(扫码体验)";
        subName.font = [UIFont systemFontOfSize:12];
        subName.textColor = [UIColor ex_colorFromHexRGB:@"666666"];
        [bottomView addSubview:subName];
        [subName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLabel.mas_left);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(4);
        }];
        UIImageView *qr = [[UIImageView alloc] init];
        qr.image =[UIImage imageNamed:@"icon_qr"];
        [bottomView addSubview:qr];
        [qr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(4);
            make.bottom.mas_equalTo(-4);
            make.width.mas_equalTo(54);
        }];
        [self.contentView addSubview:bottomView];
        [SVProgressHUD dismiss];
        UIButton *btn = sender;
        switch (btn.tag) {
            case 11:
            {
                [WDShareUtil shareTye:shareWXFriends withImageAry:@[[LJKHelper imageFromView:self.contentView]] withUrl:@"https://www.youjar.com/share/home" withTitle:@"优家选房，选出您的家" withContent:@"拿出手机赶紧下载优家选房APP哦" isPic:YES];
            }
                break;
            case 12:
            {
                [WDShareUtil shareTye:shareWXzone withImageAry:@[[LJKHelper imageFromView:self.contentView]] withUrl:@"https://www.youjar.com/share/home" withTitle:@"优家选房，选出您的家" withContent:@"拿出手机赶紧下载优家选房APP哦" isPic:YES];
            }
                break;
            case 13:
            {
                [WDShareUtil shareTye:shareQQFriends withImageAry:@[[LJKHelper imageFromView:self.contentView]] withUrl:@"https://www.youjar.com/share/home" withTitle:@"优家选房，选出您的家" withContent:@"拿出手机赶紧下载优家选房APP哦" isPic:YES];
            }
                break;
            case 14:
            {
                [WDShareUtil shareTye:shareQQzone withImageAry:@[[LJKHelper imageFromView:self.contentView]] withUrl:@"https://www.youjar.com/share/home" withTitle:@"优家选房，选出您的家" withContent:@"拿出手机赶紧下载优家选房APP哦" isPic:YES];
            }
                break;
            case 15:
            {
                [WDShareUtil shareTye:shareSinaWeibo withImageAry:@[[LJKHelper imageFromView:self.contentView]] withUrl:@"https://www.youjar.com/share/home" withTitle:@"优家选房，选出您的家" withContent:@"拿出手机赶紧下载优家选房APP哦" isPic:YES];
            }
                break;
            default:
                break;
        }
        [bottomView removeFromSuperview];
        self.contentView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, 997 + APP_SCREEN_WIDTH *0.7);
    });
}
- (IBAction)shareViewCancelClick:(id)sender {
    [self.klcpopupManager dismiss:YES];
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
        //        [self saveUserInfoWithNick:nick icon:icon];
        [self postHeaderImg:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:icon]]]];
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
