//
//  YJFourthStepViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/21.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJFourthStepViewController.h"
#import "YJFourthStepPreview.h"
#import "YJFiveStepViewController.h"
#import "YJTabBarSystemController.h"
@interface YJFourthStepViewController ()
@property (weak, nonatomic) IBOutlet UIView *myView;
@property (nonatomic,strong) NSMutableArray *oriCenterAry;
@property (assign, nonatomic) CGPoint startP;
@property (assign, nonatomic) CGPoint buttonP;
@end

@implementation YJFourthStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    YJFourthStepPreview *view = [[YJFourthStepPreview alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    [self.view addSubview:view];
    self.oriCenterAry = [@[] mutableCopy];
    for (int i=0;i<5 ; i++) {
        UIButton *btn = [self.view viewWithTag:i+1];
        [self.oriCenterAry addObject:btn];
        UILongPressGestureRecognizer * longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
        [btn addGestureRecognizer:longGes];
    }
    if (self.edit) {
        NSArray *selectArySort = @[self.registerModel.uw_school_weight,self.registerModel.uw_shop_weight,self.registerModel.uw_hospital_weight,self.registerModel.uw_bus_stop_weight,self.registerModel.uw_env_weight];
        NSArray *titleAry = @[@"学区",@"商店",@"医院",@"交通",@"环境"];
        NSArray *imgAry = @[@"icon_school_step",@"icon_shop_step",@"icon_hospital_step",@"icon_bus_step",@"icon_env_step"];
        for (int i=0; i<5; i++) {
            UIButton *btn = [self.view viewWithTag:(6-[selectArySort[i] intValue])];
            [btn setImage:[UIImage imageNamed:imgAry[i]] forState:UIControlStateNormal];
            [btn setTitle:titleAry[i] forState:UIControlStateNormal];
        }
    }
}

- (void)longPressClick:(UIGestureRecognizer *)longGes {
    UIButton * currentBtn = (UIButton *)longGes.view;
    if (UIGestureRecognizerStateBegan == longGes.state) {
        [UIView animateWithDuration:0.2 animations:^{
            currentBtn.transform = CGAffineTransformScale(currentBtn.transform, 1.4, 1.4);
            currentBtn.alpha = 0.7f;
            _startP = [longGes locationInView:currentBtn];
            _buttonP = currentBtn.center;
        }];
    }
    
    if (UIGestureRecognizerStateChanged == longGes.state) {
        CGPoint newP = [longGes locationInView:currentBtn];
        CGFloat movedX = newP.x - _startP.x;
        CGFloat movedY = newP.y - _startP.y;
        currentBtn.center = CGPointMake(currentBtn.center.x + movedX, currentBtn.center.y + movedY);
        
        // 获取当前按钮的索引
        NSInteger fromIndex = currentBtn.tag - 1;
        // 获取目标移动索引
        NSInteger toIndex = [self getMovedIndexByCurrentButton:currentBtn];
        
        if (toIndex < 0) {
            return;
        } else {
            currentBtn.tag = toIndex + 1;
            // 按钮向后移动
            if (fromIndex < toIndex) {
                
                for (NSInteger i = fromIndex; i < toIndex; i++) {
                    // 拿到下一个按钮
                    UIButton * nextBtn = self.oriCenterAry[i + 1];
                    CGPoint tempP = nextBtn.center;
                    [UIView animateWithDuration:0.5 animations:^{
                        nextBtn.center = _buttonP;
                    }];
                    _buttonP = tempP;
                    nextBtn.tag = i +1;
                }
                [self sortArray];
            } else if(fromIndex > toIndex) { // 按钮向前移动
                
                for (NSInteger i = fromIndex; i > toIndex; i--) {
                    UIButton * previousBtn = self.oriCenterAry[i - 1];
                    CGPoint tempP = previousBtn.center;
                    [UIView animateWithDuration:0.5 animations:^{
                        previousBtn.center = _buttonP;
                    }];
                    _buttonP = tempP;
                    previousBtn.tag = i +1;
                }
                [self sortArray];
            }
        }
    }
    // 手指松开之后 进行的处理
    if (UIGestureRecognizerStateEnded == longGes.state) {
        [UIView animateWithDuration:0.2 animations:^{
            currentBtn.transform = CGAffineTransformIdentity;
            currentBtn.alpha = 1.0f;
            currentBtn.center = _buttonP;
        }];
    }
}
- (void)sortArray {
    // 对已改变按钮的数组进行排序
    [self.oriCenterAry sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        UIButton *temp1 = (UIButton *)obj1;
        UIButton *temp2 = (UIButton *)obj2;
        return temp1.tag > temp2.tag;    //将tag值大的按钮向后移
    }];
    
}
- (NSInteger)getMovedIndexByCurrentButton:(UIButton *)currentButton {
    for (NSInteger i = 0; i<self.oriCenterAry.count ; i++) {
        UIButton * button = self.oriCenterAry[i];
        if (!currentButton || button != currentButton) {
            if (CGRectContainsPoint(button.frame, currentButton.center)) {
                return i;
            }
        }
    }
    return -1;
}
- (IBAction)nextStepAction:(id)sender {
    for (int i=0; i<5; i++) {
        UIButton *btn = self.oriCenterAry[i];
        [self setupSort:btn.titleLabel.text tag:i];
    }
    if (self.registerModel.zufang == NO) {
        //接口调试
        [SVProgressHUD show];
        if (ISEMPTY([LJKHelper getAuth_key])) {
            [[NetworkTool sharedTool] requestWithURLString:@"https://ksir.tech/you/frontend/web/app/user/signup" parameters:@{@"device_uid":[[[UIDevice currentDevice] identifierForVendor] UUIDString]} method:POST callBack:^(id responseObject) {
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
    } else {
        YJFiveStepViewController *vc = [[YJFiveStepViewController alloc] init];
        vc.registerModel = self.registerModel;
        vc.edit = self.edit;
        PushController(vc);

    }
}
- (void)setupSort:(NSString *)title tag:(NSInteger)tag {
    if ([title isEqualToString:@"医院"]) {
        self.registerModel.uw_hospital_weight = [NSString stringWithFormat:@"%ld",5-tag];
        return;
    } else if ([title isEqualToString:@"学区"]) {
        self.registerModel.uw_school_weight = [NSString stringWithFormat:@"%ld",5-tag];
        return;
    } else if ([title isEqualToString:@"商店"]) {
        self.registerModel.uw_shop_weight = [NSString stringWithFormat:@"%ld",5-tag];
        return;
    } else if ([title isEqualToString:@"交通"]) {
        self.registerModel.uw_bus_stop_weight = [NSString stringWithFormat:@"%ld",5-tag];
        return;
    } else if ([title isEqualToString:@"环境"]) {
        self.registerModel.uw_env_weight = [NSString stringWithFormat:@"%ld",5-tag];
        return;
    }
}
- (void)submitUserPrivateCustom {
    NSDictionary *params;
    if (ISEMPTY(self.registerModel.uw_region2_id)) {
        params = @{@"auth_key":[LJKHelper getAuth_key],@"uwe[active]":@"1",@"uwe[name]":@"私人订制",@"uwe[region1_id]":self.registerModel.uw_region1_id,@"uwe[region1_weight]":@"10",@"uwe[price_min]":self.registerModel.uw_price_min,@"uwe[price_max]":self.registerModel.uw_price_max,@"uwe[price_rank_weight]":@"10",@"uwe[bus_stop_weight]":self.registerModel.uw_bus_stop_weight,@"uwe[hospital_weight]":self.registerModel.uw_hospital_weight,@"uwe[shop_weight]":self.registerModel.uw_shop_weight,@"uwe[school_weight]":self.registerModel.uw_school_weight,@"uwe[env_weight]":self.registerModel.uw_env_weight};
    } else {
        params = @{@"auth_key":[LJKHelper getAuth_key],@"uwe[active]":@"1",@"uwe[name]":@"私人订制",@"uwe[region1_id]":self.registerModel.uw_region1_id,@"uwe[region1_weight]":@"10",@"uwe[region2_id]":self.registerModel.uw_region2_id,@"uwe[region2_weight]":@"10",@"uwe[price_min]":self.registerModel.uw_price_min,@"uwe[price_max]":self.registerModel.uw_price_max,@"uwe[price_rank_weight]":@"10",@"uwe[bus_stop_weight]":self.registerModel.uw_bus_stop_weight,@"uwe[hospital_weight]":self.registerModel.uw_hospital_weight,@"uwe[shop_weight]":self.registerModel.uw_shop_weight,@"uwe[school_weight]":self.registerModel.uw_school_weight,@"uwe[env_weight]":self.registerModel.uw_env_weight};
    }
    [[NetworkTool sharedTool] requestWithURLString:@"https://ksir.tech/you/frontend/web/app/user/save-user-weight" parameters:params method:POST callBack:^(id responseObject) {
        if (!ISEMPTY(responseObject)) {
            [SVProgressHUD dismiss];
            [LJKHelper saveErshouWeight_id:responseObject[@"result"][@"weight_id"]];
            if (self.registerModel.firstEnter) {
                self.view.window.rootViewController = [[YJTabBarSystemController alloc] init];
                [self.view removeFromSuperview];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"houseTypeKey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } error:^(NSError *error) {
        
    }];
}

@end
