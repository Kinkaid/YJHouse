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
@property (nonatomic,strong) NSMutableArray *stateAry;

@end

@implementation YJSecondStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    self.stateAry = [@[] mutableCopy];
    [self.stateAry addObjectsFromArray:@[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)]];
}
- (IBAction)yuhangAction:(id)sender {//余杭 1
    UIImageView *img = [self.view viewWithTag:1];
    if ([self.stateAry[0] boolValue]) {
        img.image = [UIImage imageNamed:@"icon_yuhang"];
        [self.stateAry replaceObjectAtIndex:0 withObject:@(NO)];
    } else {
        img.image = [UIImage imageNamed:@"icon_yuhang_select"];
        [self.stateAry replaceObjectAtIndex:0 withObject:@(YES)];
    }
}
- (IBAction)fuyangAction:(id)sender { //富阳  2
    UIImageView *img = [self.view viewWithTag:2];
    if ([self.stateAry[1] boolValue]) {
        img.image = [UIImage imageNamed:@"icon_fuyang"];
        [self.stateAry replaceObjectAtIndex:1 withObject:@(NO)];
    } else {
        img.image = [UIImage imageNamed:@"icon_fuyang_select"];
        [self.stateAry replaceObjectAtIndex:1 withObject:@(YES)];
    }
}
- (IBAction)xiaoshanAction:(id)sender {//萧山3
    UIImageView *img = [self.view viewWithTag:3];
    if ([self.stateAry[2] boolValue]) {
        img.image = [UIImage imageNamed:@"icon_xiaoshan"];
        [self.stateAry replaceObjectAtIndex:2 withObject:@(NO)];
    } else {
        img.image = [UIImage imageNamed:@"icon_xiaoshan_select"];
        [self.stateAry replaceObjectAtIndex:2 withObject:@(YES)];
    }
}
- (IBAction)xihuAction:(id)sender { //西湖4
    UIImageView *img = [self.view viewWithTag:4];
    if ([self.stateAry[3] boolValue]) {
        img.image = [UIImage imageNamed:@"icon_xihu"];
        [self.stateAry replaceObjectAtIndex:3 withObject:@(NO)];
    } else {
        img.image = [UIImage imageNamed:@"icon_xihu_select"];
        [self.stateAry replaceObjectAtIndex:3 withObject:@(YES)];
    }
}
- (IBAction)gongsuAction:(id)sender {//拱墅5
    UIImageView *img = [self.view viewWithTag:5];
    if ([self.stateAry[4] boolValue]) {
        img.image = [UIImage imageNamed:@"icon_gongshu"];
        [self.stateAry replaceObjectAtIndex:4 withObject:@(NO)];
    } else {
        img.image = [UIImage imageNamed:@"icon_gongshu_select"];
        [self.stateAry replaceObjectAtIndex:4 withObject:@(YES)];
    }
}


- (IBAction)jiangganAction:(id)sender {//江干6
    UIImageView *img = [self.view viewWithTag:6];
    if ([self.stateAry[5] boolValue]) {
        img.image = [UIImage imageNamed:@"icon_jianggan"];
        [self.stateAry replaceObjectAtIndex:5 withObject:@(NO)];
    } else {
        img.image = [UIImage imageNamed:@"icon_jianggan_select"];
        [self.stateAry replaceObjectAtIndex:5 withObject:@(YES)];
    }
}
- (IBAction)xiachengAction:(id)sender {//下城7
    UIImageView *img = [self.view viewWithTag:7];
    if ([self.stateAry[6] boolValue]) {
        img.image = [UIImage imageNamed:@"icon_xiacheng"];
        [self.stateAry replaceObjectAtIndex:6 withObject:@(NO)];
    } else {
        img.image = [UIImage imageNamed:@"icon_xiacheng_select"];
        [self.stateAry replaceObjectAtIndex:6 withObject:@(YES)];
    }
}
- (IBAction)shangchengAction:(id)sender { //8上城
    UIImageView *img = [self.view viewWithTag:8];
    if ([self.stateAry[7] boolValue]) {
        img.image = [UIImage imageNamed:@"icon_shangcheng"];
        [self.stateAry replaceObjectAtIndex:7 withObject:@(NO)];
    } else {
        img.image = [UIImage imageNamed:@"icon_shangcheng_select"];
        [self.stateAry replaceObjectAtIndex:7 withObject:@(YES)];
    }
}

- (IBAction)binjiangAction:(id)sender { //9滨江
    UIImageView *img = [self.view viewWithTag:9];
    if ([self.stateAry[8] boolValue]) {
        img.image = [UIImage imageNamed:@"icon_bingjiang"];
        [self.stateAry replaceObjectAtIndex:8 withObject:@(NO)];
    } else {
        img.image = [UIImage imageNamed:@"icon_bingjiang_select"];
        [self.stateAry replaceObjectAtIndex:8 withObject:@(YES)];
    }
}

- (IBAction)nextStepClick:(id)sender {
    YJThirdStepViewController *vc= [[YJThirdStepViewController alloc] init];
    PushController(vc);
}

@end
