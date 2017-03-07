//
//  YJHomePageViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/17.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJHomePageViewController.h"
#import "YJHomePageViewCell.h"
#import "KLCPopup.h"
#import "YJSearchViewController.h"
#import "YJHouseDetailViewController.h"
#define kCellIdentifier @"YJHomePageViewCell"
@interface YJHomePageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *navView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet KLCPopup *popupView;
@property (nonatomic,strong)KLCPopup *klcManager;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@end

@implementation YJHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self registerTableView];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)registerTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.headerView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH *0.66 +150 +46);
    [self.tableView setTableHeaderView:self.headerView];
    self.navView.backgroundColor = [[UIColor ex_colorFromHexRGB:@"FF0000"] colorWithAlphaComponent:0];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 18;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 97;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJHomePageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - IBActions
- (IBAction)scanTypeAction:(id)sender {
    self.klcManager = [KLCPopup popupWithContentView:self.popupView];
    [self.klcManager showAtCenter:CGPointMake(40, 100) inView:self.view];
}
- (IBAction)selectType:(id)sender {
    UIButton *selectBtn = sender;
    [selectBtn setTitleColor:[UIColor ex_colorFromHexRGB:@"FF807D"] forState:UIControlStateNormal];
    UIButton *typeBtn = [self.view viewWithTag:3];
    if (selectBtn.tag == 1) {
        [typeBtn setTitle:@"租房" forState:UIControlStateNormal];
        UIButton *btn = [self.popupView viewWithTag:2];
        [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"3F3F3F"] forState:UIControlStateNormal];
    } else if (selectBtn.tag == 2){
        [typeBtn setTitle:@"买房" forState:UIControlStateNormal];
        UIButton *btn = (UIButton *)[self.popupView viewWithTag:1];
        [btn setTitleColor:[UIColor ex_colorFromHexRGB:@"3F3F3F"] forState:UIControlStateNormal];
    }
    [self.klcManager dismiss:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YJHouseDetailViewController *vc = [[YJHouseDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)searchAction:(id)sender {//搜索
    YJSearchViewController *vc= [[YJSearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)sortAction:(id)sender {
    UIButton *button = sender;
    if (button.tag < 55) {
      [self.tableView setContentOffset:CGPointMake(0, APP_SCREEN_WIDTH *0.66 +150 + 6 - 64)];
    }
}


#pragma mark -scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.navView.backgroundColor = [[UIColor ex_colorFromHexRGB:@"A746E8"] colorWithAlphaComponent:(scrollView.contentOffset.y /128.0)];
    if (scrollView.contentOffset.y >= APP_SCREEN_WIDTH *0.66 +150 + 6 - 64) {
        self.topView.hidden = NO;
        self.titleView.hidden = NO;
        self.searchBtn.hidden = NO;
    } else {
        self.topView.hidden = YES;
        self.titleView.hidden = YES;
        self.searchBtn.hidden = YES;
    }
    
}


@end
