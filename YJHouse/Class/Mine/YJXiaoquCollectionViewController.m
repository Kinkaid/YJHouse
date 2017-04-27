//
//  WDXiaoquCollectionViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/5.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJXiaoquCollectionViewController.h"
#import "YJXiaoQuViewCell.h"
#import "YJXiaoQuDetailViewController.h"
#define cellId @"YJXiaoQuViewCell"
@interface YJXiaoquCollectionViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YJXiaoquCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"收藏的小区"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self registerTableView];
}

- (void)registerTableView {
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJXiaoQuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if(!cell) {
        cell = [[YJXiaoQuViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YJXiaoQuDetailViewController *vc = [[YJXiaoQuDetailViewController alloc] init];
    PushController(vc);
}

@end
