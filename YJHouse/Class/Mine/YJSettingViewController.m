//
//  YJSettingViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/6/10.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJSettingViewController.h"
#import "YJSettingViewCell.h"
static NSString * const kClearCacheCellID = @"YJSettingViewCell";
@interface YJSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YJSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"设置"];
    [self.tableView registerClass:[YJSettingViewCell class] forCellReuseIdentifier:kClearCacheCellID];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return [[YJSettingViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kClearCacheCellID];
    } else {
        return nil;
    }
}


@end
