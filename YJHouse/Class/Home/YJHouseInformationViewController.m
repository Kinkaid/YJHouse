//
//  YJHouseInformationViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/12/11.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJHouseInformationViewController.h"
#import "YJHouseInformationView.h"
#import "YJHouseArticleWebViewController.h"
@interface YJHouseInformationViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *infoScrollView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,assign) NSInteger curSelectedBtnTag;
@end

@implementation YJHouseInformationViewController

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = MainColor;
    }
    return _lineView;
}
- (UIScrollView *)infoScrollView {
    if (!_infoScrollView) {
        _infoScrollView = [[UIScrollView alloc] init];
        _infoScrollView.contentSize = CGSizeMake(APP_SCREEN_WIDTH *3, KIsiPhoneX?118:94);
        _infoScrollView.pagingEnabled = YES;
        _infoScrollView.delegate = self;
        _infoScrollView.showsVerticalScrollIndicator = NO;
        _infoScrollView.showsHorizontalScrollIndicator = NO;
        _infoScrollView.bounces = NO;
        [self.view addSubview:_infoScrollView];
    }
    return _infoScrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"房产资讯"];
    [self initCategoryView];
}
- (void)initCategoryView {
    UIView *categoryContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, KIsiPhoneX?88:64, APP_SCREEN_WIDTH, 40)];
    [self.view addSubview:categoryContainerView];
    NSArray *btnTitleAry = @[@"热门楼讯",@"杭州消息",@"数据报告"];
    for (int i=0; i<3; i++) {
        UIButton *categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        categoryBtn.tag = 100+i;
        categoryBtn.frame = CGRectMake(i * (APP_SCREEN_WIDTH / 3.0), 0, APP_SCREEN_WIDTH / 3.0, 40);
        [categoryBtn setTitleColor:[UIColor ex_colorFromHexRGB:@"434343"] forState:UIControlStateNormal];
        [categoryBtn setTitleColor:MainColor forState:UIControlStateSelected];
        [categoryBtn setTitle:btnTitleAry[i] forState:UIControlStateNormal];
        [categoryContainerView addSubview:categoryBtn];
        [categoryBtn addTarget:self action:@selector(categoryClick:) forControlEvents:UIControlEventTouchUpInside];
        categoryBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        if (i==0) {
            categoryBtn.selected = YES;
            [categoryContainerView addSubview:self.lineView];
            self.lineView.frame = CGRectMake(0, 36, 28, 4);
            self.lineView.center = CGPointMake(categoryBtn.center.x, 36);
        } else {
            categoryBtn.selected = NO;
        }
    }
    [self.infoScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom).with.offset(40);
        make.left.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    for (int i=0; i<3; i++) {
        YJHouseInformationView *tableViewContainerView = [[YJHouseInformationView alloc] initWithFrame:CGRectMake(i*APP_SCREEN_WIDTH, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - (KIsiPhoneX?128:104))];
        tableViewContainerView.type = i+1;
        [tableViewContainerView loadTableViewData];
        [self.infoScrollView addSubview:tableViewContainerView];
    }
    self.curSelectedBtnTag = 100;
}
#pragma mark action
- (void)categoryClick:(UIButton *)button {
    if (self.curSelectedBtnTag != button.tag) {
        [self initWithCategoryAndLineWithTag:button.tag];
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.infoScrollView.contentOffset = CGPointMake(APP_SCREEN_WIDTH *(button.tag - 100), 0);
        }];
    }
    
}
#pragma mark --UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.infoScrollView) {
        int page = self.infoScrollView.contentOffset.x / APP_SCREEN_WIDTH;
        if (page+100 != self.curSelectedBtnTag) {
            [self initWithCategoryAndLineWithTag:page+100];
        }
    }
}
- (void)initWithCategoryAndLineWithTag:(NSInteger)tag {
    UIButton *lastBtn = [self.view viewWithTag:self.curSelectedBtnTag];
    lastBtn.selected = NO;
    self.curSelectedBtnTag = tag;
    UIButton *curBtn = [self.view viewWithTag:self.curSelectedBtnTag];
    curBtn.selected = YES;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.center = CGPointMake(curBtn.center.x, weakSelf.lineView.center.y);
    }];
    
}
@end
