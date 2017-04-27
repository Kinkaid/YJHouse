//
//  YJPricateCustomViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/18.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJPricateCustomViewController.h"
#import "YJPricateCustomViewCell.h"
#import "YJPrivateAddViewCell.h"
#import "YJFirstStepViewController.h"
#import "KLCPopup.h"
#define kCellIdentifier @"YJPricateCustomViewCell"
#define kCellAddIdentifier @"YJPrivateAddViewCell"
@interface YJPricateCustomViewController ()<UITableViewDelegate,UITableViewDataSource,YJPrivateCustomEditDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet KLCPopup *popupView;
@property (nonatomic,strong)KLCPopup *klcManager;
@property (nonatomic,strong) NSMutableArray *privateAry;

@end

@implementation YJPricateCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    [self registerTableView];
    [self loadData];
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
    [self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:kCellAddIdentifier bundle:nil] forCellReuseIdentifier:kCellAddIdentifier];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)loadData {
    self.privateAry = [@[] mutableCopy];
    [self.privateAry addObject:@{@"select":@(YES)}];
    [self.privateAry addObject:@{@"select":@(NO)}];
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.privateAry.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.privateAry.count) {
        YJPrivateAddViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellAddIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        YJPricateCustomViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
        if (!cell1) {
            cell1 = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
        }
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.delegate = self;
        [cell1 showDataWithDic:self.privateAry[indexPath.section]];
        return cell1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77;
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor whiteColor];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.privateAry.count) {
        return YES;
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.privateAry.count) {
        
    } else {
        YJFirstStepViewController *vc = [[YJFirstStepViewController alloc] init];
        PushController(vc);
    }
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.privateAry removeObjectAtIndex:indexPath.section];
    [self.tableView reloadData];
}
- (IBAction)selectType:(id)sender {
    self.klcManager = [KLCPopup popupWithContentView:self.popupView];
    [self.klcManager showAtCenter:CGPointMake(40, 100) inView:self.view];
}
- (IBAction)chooseType:(id)sender {
    UIButton *selectBtn = sender;
    [selectBtn setTitleColor:[UIColor ex_colorFromHexRGB:@"39343F"] forState:UIControlStateNormal];
    UIButton *typeBtn = [self.view viewWithTag:3];
    if (selectBtn.tag == 1) {
        [typeBtn setTitle:@"租房" forState:UIControlStateNormal];
        UIButton *btn = [self.popupView viewWithTag:2];
        [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"FFFFFF"] forState:UIControlStateNormal];
    } else if (selectBtn.tag == 2){
        [typeBtn setTitle:@"买房" forState:UIControlStateNormal];
        UIButton *btn = (UIButton *)[self.popupView viewWithTag:1];
        [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"FFFFFF"] forState:UIControlStateNormal];
    }
    [self.klcManager dismiss:YES];
}

- (void)privateEditAction:(NSInteger)cellSection {
    
}
@end
