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
@interface YJXiaoQuDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic,strong) YJXiaoquDetailModel *model;
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

@end

@implementation YJXiaoQuDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBar.hidden = YES;
    [self setContentScrollView];
    [self loadXiaoquDetail];
    
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadXiaoquDetail {
    [SVProgressHUD show];
    __weak typeof(self)weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:@"https://ksir.tech/you/frontend/web/app/xiaoqu/item-info" parameters:@{@"id":self.xiaoquId} method:GET callBack:^(id responseObject) {
      if (responseObject) {
          YJXiaoquDetailModel *model = [MTLJSONAdapter modelOfClass:[YJXiaoquDetailModel class] fromJSONDictionary:responseObject[@"result"] error:nil];
          weakSelf.model = model;
          [self fillDataWithModel];
      }
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
    self.school_count.text =[NSString stringWithFormat:@"附近有%@所学校",self.model.school_count];
    self.shop_count.text =[NSString stringWithFormat:@"附近有%@个超时",self.model.shop_count];
    self.hospital_count.text =[NSString stringWithFormat:@"附近有%@所医院",self.model.hospital_count];
    self.bus_stop_count.text =[NSString stringWithFormat:@"附近有%@个公交站",self.model.bus_stop_count];
    self.address.text = [NSString stringWithFormat:@"地址:%@-%@-%@",self.model.region,self.model.plate,self.model.name];
    [SVProgressHUD dismiss];
    
}
@end
