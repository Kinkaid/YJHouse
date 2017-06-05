//
//  YJHouseInfoDetailViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/6/1.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJHouseInfoDetailViewController.h"
#import "YJHouseInfoDetailViewCell.h"
#define kCellIdentifire @"YJHouseInfoDetailViewCell"
@interface YJHouseInfoDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation YJHouseInfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"房源介绍"];
    [self registerTableView];
}

- (void)registerTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kCellIdentifire bundle:nil] forCellReuseIdentifier:kCellIdentifire];
    [self.tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 8+20+12+12+1+[LJKHelper textHeightFromTextString:self.infoAry[indexPath.row][@"content"] width:APP_SCREEN_WIDTH - 24 fontSize:15];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJHouseInfoDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifire forIndexPath:indexPath];
    if (!cell) {
        cell = [[YJHouseInfoDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifire];
    }
    [cell showDataWithDic:self.infoAry[indexPath.row]];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoAry.count;
}
@end
