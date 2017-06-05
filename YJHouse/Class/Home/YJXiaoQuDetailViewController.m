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
@interface YJXiaoQuDetailViewController ()<YJRequestTimeoutDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

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
@end

@implementation YJXiaoQuDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [YJRequestTimeoutUtil shareInstance].delegate = self;
    self.navigationBar.hidden = YES;
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
    [[NetworkTool sharedTool] requestWithURLString:@"https://youjar.com/you/frontend/web/app/xiaoqu/item-info" parameters:@{@"id":self.xiaoquId,@"auth_key":[LJKHelper getAuth_key]} method:GET callBack:^(id responseObject) {
        [YJGIFAnimationView hideInView:self.view];
      if (responseObject[@"result"] && ISEMPTY(responseObject[@"error"])) {
          if ([responseObject[@"result"][@"evaluate"] intValue] ==0) {
              self.dislikeBtn.selected = NO;
              self.likeBtn.selected = NO;
          } else {
              self.dislikeBtn.selected = YES;
              self.likeBtn.selected = YES;
          }
          if ([responseObject[@"result"][@"favourite"] intValue] == 1) {
              self.collectionBtn.selected = YES;
              [self.collectionBtn setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
          } else {
              self.collectionBtn.selected = NO;
          }
          YJXiaoquDetailModel *model = [MTLJSONAdapter modelOfClass:[YJXiaoquDetailModel class] fromJSONDictionary:responseObject[@"result"][@"info"] error:nil];
          weakSelf.model = model;
          [self fillDataWithModel];
      }
    } error:^(NSError *error) {
        
    }];
}
- (void)setContentScrollView {
    self.scrollView.contentSize = CGSizeMake(0, 897 + APP_SCREEN_WIDTH *0.7);
    self.contentView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, 897 + APP_SCREEN_WIDTH *0.7);
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
    self.green_rate.text = [NSString stringWithFormat:@"绿化率:%@",self.model.green_rate];
    
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
    
    self.address.text = [NSString stringWithFormat:@"地址:%@-%@-%@",self.model.region,self.model.plate,self.model.name];
    self.tjzfLabel.text = [NSString stringWithFormat:@"推荐租房：%@",self.model.zufang_in];
    self.tjershouLabel.text = [NSString stringWithFormat:@"推荐二手房：%@",self.model.ershou_in];
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%@",self.model.good] forState:UIControlStateNormal];
    [self.dislikeBtn setTitle:[NSString stringWithFormat:@"%@",self.model.bad] forState:UIControlStateNormal];
    CGFloat total = ([self.model.good floatValue] + [self.model.bad floatValue]);
    CGFloat ratio = [self.model.good floatValue] / (total == 0 ?1:total) * 100;
    [self.toScoreBtn setTitle:[NSString stringWithFormat:@"%.0f%%",ratio] forState:UIControlStateNormal];
    [self.collectionBtn setTitle:[NSString stringWithFormat:@"%@",self.model.favourite_count] forState:UIControlStateNormal];
    [SVProgressHUD dismiss];
    
}
- (IBAction)collectionAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    NSString *url;
    if (self.collectionBtn.selected) {
        url =@"https://youjar.com/you/frontend/web/app/user/cancel-favourite";
    } else {
        url = @"https://youjar.com/you/frontend/web/app/user/set-favourite";
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
    [[NetworkTool sharedTool] requestWithURLString:@"https://youjar.com/you/frontend/web/app/user/set-evaluate" parameters:params method:POST callBack:^(id responseObject) {
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
    [[NetworkTool sharedTool] requestWithURLString:@"https://youjar.com/you/frontend/web/app/user/set-evaluate" parameters:params method:POST callBack:^(id responseObject) {
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            [self.dislikeBtn setTitle:[NSString stringWithFormat:@" %d",[self.dislikeBtn.titleLabel.text intValue] +1] forState:UIControlStateNormal];
            [self.toScoreBtn setTitle:[NSString stringWithFormat:@" %.0f%%",([self.likeBtn.titleLabel.text floatValue] / ([self.dislikeBtn.titleLabel.text floatValue] +[self.likeBtn.titleLabel.text floatValue])) * 100] forState:UIControlStateNormal];
            self.dislikeBtn.selected = YES;
        }
    } error:^(NSError *error) {
        
    }];
    
}
- (IBAction)shareAction:(id)sender {
    
}
@end
