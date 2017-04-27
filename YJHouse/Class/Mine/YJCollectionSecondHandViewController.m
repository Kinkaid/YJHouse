//
//  YJCollectionSecondHandViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/5.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJCollectionSecondHandViewController.h"
#import "YJCollectionSecondHandViewCell.h"
#import "YJRemarkViewController.h"
#define kSecondHandCellIdentifier @"YJCollectionSecondHandViewCell"
@interface YJCollectionSecondHandViewController ()<UITableViewDelegate,UITableViewDataSource,YJRemarkActionDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YJCollectionSecondHandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setTitle:@"我收藏的二手房"];
    [self registerTableView];
}
- (void)registerTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kSecondHandCellIdentifier bundle:nil] forCellReuseIdentifier:kSecondHandCellIdentifier];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 128;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJCollectionSecondHandViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSecondHandCellIdentifier forIndexPath:indexPath];
    if(!cell) {
        cell = [[YJCollectionSecondHandViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSecondHandCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellRow = indexPath.row;
    cell.deleagate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadData];
}
- (void)remarkAction:(NSInteger)cellRow {
    YJRemarkViewController *vc = [[YJRemarkViewController alloc] init];
    PushController(vc);
}
@end
