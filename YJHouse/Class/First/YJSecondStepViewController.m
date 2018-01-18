//
//  YJSecondStepViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/18.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJSecondStepViewController.h"
#import "YJThirdStepViewController.h"
@interface YJSecondStepViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (nonatomic,strong) NSMutableArray *stateAry;
@property (nonatomic,strong) NSMutableArray *regionIdAry;
@property (nonatomic,assign) int selectCount;
@end

@implementation YJSecondStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    if (_edit == YES) {
        self.backBtn.hidden = NO;
    } else {
        if (self.showBackBtn) {
            self.backBtn.hidden = NO;
        } else {
            self.backBtn.hidden = YES;
        }
    }
    self.stateAry = [@[] mutableCopy];
    self.regionIdAry = [@[] mutableCopy];
    [self.regionIdAry addObjectsFromArray:@[@"330110000",@"330111000",@"330109000",@"330106000",@"330105000",@"330104000",@"330103000",@"330102000",@"330108000"]];
    NSArray *imgAry = @[@"icon_yuhang_select",@"icon_fuyang_select",@"icon_xiaoshan_select",@"icon_xihu_select",@"icon_gongshu_select",@"icon_jianggan_select",@"icon_xiacheng_select",@"icon_shangcheng_select",@"icon_bingjiang_select"];
    for (int i=0; i<self.regionIdAry.count; i++) {
        if ([self.regionIdAry[i] floatValue] == [self.registerModel.uw_region1_id floatValue] ||[self.regionIdAry[i] floatValue] == [self.registerModel.uw_region2_id floatValue]) {
            [self.stateAry addObject:@(YES)];
            self.selectCount ++;
            UIImageView *img = [self.view viewWithTag:i+1];
            img.image = [UIImage imageNamed:imgAry[i]];
        } else {
            [self.stateAry addObject:@(NO)];
        }
    }
    self.registerModel.uw_region1_id = @"";
    self.registerModel.uw_region2_id = @"";
    
}
- (IBAction)yuhangAction:(id)sender {//余杭1   330110000
    UIImageView *img = [self.view viewWithTag:1];
    if ([self.stateAry[0] boolValue]) {
        img.image = [UIImage imageNamed:@"icon_yuhang"];
        [self.stateAry replaceObjectAtIndex:0 withObject:@(NO)];
        self.selectCount --;
    } else {
        img.image = [UIImage imageNamed:@"icon_yuhang_select"];
        [self.stateAry replaceObjectAtIndex:0 withObject:@(YES)];
        self.selectCount ++;
    }
}
- (IBAction)fuyangAction:(id)sender { //富阳2   330111000
    UIImageView *img = [self.view viewWithTag:2];
    if ([self.stateAry[1] boolValue]) {
        img.image = [UIImage imageNamed:@"icon_fuyang"];
        [self.stateAry replaceObjectAtIndex:1 withObject:@(NO)];
        self.selectCount --;
    } else {
        img.image = [UIImage imageNamed:@"icon_fuyang_select"];
        [self.stateAry replaceObjectAtIndex:1 withObject:@(YES)];
        self.selectCount ++;
    }
}
- (IBAction)xiaoshanAction:(id)sender {//萧山3   330109000
    UIImageView *img = [self.view viewWithTag:3];
    if ([self.stateAry[2] boolValue]) {
        img.image = [UIImage imageNamed:@"icon_xiaoshan"];
        [self.stateAry replaceObjectAtIndex:2 withObject:@(NO)];
        self.selectCount --;
    } else {
        img.image = [UIImage imageNamed:@"icon_xiaoshan_select"];
        [self.stateAry replaceObjectAtIndex:2 withObject:@(YES)];
        self.selectCount ++;
    }
}
- (IBAction)xihuAction:(id)sender { //西湖4   330106000
    UIImageView *img = [self.view viewWithTag:4];
    if ([self.stateAry[3] boolValue]) {
        img.image = [UIImage imageNamed:@"icon_xihu"];
        [self.stateAry replaceObjectAtIndex:3 withObject:@(NO)];
        self.selectCount --;
    } else {
        img.image = [UIImage imageNamed:@"icon_xihu_select"];
        [self.stateAry replaceObjectAtIndex:3 withObject:@(YES)];
        self.selectCount ++;
    }
}
- (IBAction)gongsuAction:(id)sender {//拱墅5   330105000
    UIImageView *img = [self.view viewWithTag:5];
    if ([self.stateAry[4] boolValue]) {
        img.image = [UIImage imageNamed:@"icon_gongshu"];
        [self.stateAry replaceObjectAtIndex:4 withObject:@(NO)];
        self.selectCount --;
    } else {
        img.image = [UIImage imageNamed:@"icon_gongshu_select"];
        [self.stateAry replaceObjectAtIndex:4 withObject:@(YES)];
        self.selectCount ++;
    }
}


- (IBAction)jiangganAction:(id)sender {//江干6   330104000
    UIImageView *img = [self.view viewWithTag:6];
    if ([self.stateAry[5] boolValue]) {
        img.image = [UIImage imageNamed:@"icon_jianggan"];
        [self.stateAry replaceObjectAtIndex:5 withObject:@(NO)];
        self.selectCount --;
    } else {
        img.image = [UIImage imageNamed:@"icon_jianggan_select"];
        [self.stateAry replaceObjectAtIndex:5 withObject:@(YES)];
        self.selectCount ++;
    }
}
- (IBAction)xiachengAction:(id)sender {//下城7   330103000
    UIImageView *img = [self.view viewWithTag:7];
    if ([self.stateAry[6] boolValue]) {
        img.image = [UIImage imageNamed:@"icon_xiacheng"];
        [self.stateAry replaceObjectAtIndex:6 withObject:@(NO)];
        self.selectCount --;
    } else {
        img.image = [UIImage imageNamed:@"icon_xiacheng_select"];
        [self.stateAry replaceObjectAtIndex:6 withObject:@(YES)];
        self.selectCount ++;
    }
}
- (IBAction)shangchengAction:(id)sender { //8上城 330102000
    UIImageView *img = [self.view viewWithTag:8];
    if ([self.stateAry[7] boolValue]) {
        img.image = [UIImage imageNamed:@"icon_shangcheng"];
        [self.stateAry replaceObjectAtIndex:7 withObject:@(NO)];
        self.selectCount --;
    } else {
        img.image = [UIImage imageNamed:@"icon_shangcheng_select"];
        [self.stateAry replaceObjectAtIndex:7 withObject:@(YES)];
        self.selectCount ++;
    }
}

- (IBAction)binjiangAction:(id)sender { //9滨江  330108000
    UIImageView *img = [self.view viewWithTag:9];
    if ([self.stateAry[8] boolValue]) {
        img.image = [UIImage imageNamed:@"icon_bingjiang"];
        [self.stateAry replaceObjectAtIndex:8 withObject:@(NO)];
        self.selectCount --;
    } else {
        img.image = [UIImage imageNamed:@"icon_bingjiang_select"];
        [self.stateAry replaceObjectAtIndex:8 withObject:@(YES)];
        self.selectCount ++;
    }
}

- (IBAction)nextStepClick:(id)sender {
    if (self.selectCount<1) {
        [YJApplicationUtil alertHud:@"请至少选一项" afterDelay:1];
        return;
    } else if (self.selectCount > 2) {
        [YJApplicationUtil alertHud:@"最多选两项" afterDelay:1];
        return;
    } else {
        for (int i=0; i<9; i++) {
            if ([self.stateAry[i] boolValue]) {
                if (ISEMPTY(self.registerModel.uw_region1_id)) {
                    self.registerModel.uw_region1_weight = @"10";
                    self.registerModel.uw_region1_id = self.regionIdAry[i];
                } else {
                    self.registerModel.uw_region2_weight = @"10";
                    self.registerModel.uw_region2_id = self.regionIdAry[i];
                    break;
                }
            }
        }
    }
    YJThirdStepViewController *vc= [[YJThirdStepViewController alloc] init];
    vc.registerModel = self.registerModel;
    vc.edit = self.edit;
    PushController(vc);
}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
