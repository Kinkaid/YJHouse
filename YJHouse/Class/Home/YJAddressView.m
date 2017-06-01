//
//  YJAddressView.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/12.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJAddressView.h"
#import "YJAddressViewCell.h"
#define kCellId @"YJAddressViewCell"
@implementation YJAddressView {
    UITableView *_tableview1;
    UITableView *_tableview2;
    UITableView *_tableview3;
    NSMutableArray *_dataAry;
    NSInteger _itemOneSel;
    NSInteger _itemTwoSel;
    NSInteger _itemThreeSel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor ex_colorFromHexRGB:@"D8D8D8"].CGColor;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 312, APP_SCREEN_WIDTH,self.frame.size.height - 312)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [tapView addGestureRecognizer:tap];
        [self addSubview:tapView];
        [self customerTableView];
    }
    return self;
}
- (void)tapClick:(UITapGestureRecognizer *)tap {
    self.hidden = YES;
    [self.delegate hiddenAddressView];
}
- (void)customerTableView {
    _tableview1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH * (1.000000 / 4.000000) + 1, 312)];
    _tableview1.delegate = self;
    _tableview1.dataSource = self;
    _tableview1.backgroundColor = [UIColor ex_colorFromHexRGB:@"F7F7F7"];
    _tableview1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableview1];
    [_tableview1 registerNib:[UINib nibWithNibName:kCellId bundle:nil] forCellReuseIdentifier:kCellId];
    _tableview2 = [[UITableView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH * (1.000000 / 4.000000), 0, APP_SCREEN_WIDTH *(3.0 / 8.000000), 312)];
    _tableview2.delegate = self;
    _tableview2.dataSource = self;
    _tableview2.backgroundColor = [UIColor ex_colorFromHexRGB:@"FAFAFA"];
    _tableview2.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableview2 registerNib:[UINib nibWithNibName:kCellId bundle:nil] forCellReuseIdentifier:kCellId];
    [self addSubview:_tableview2];
    _tableview3 = [[UITableView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH * (5.0000000 / 8.0000000),0, APP_SCREEN_WIDTH *(3.0 / 8.0000000), 312)];
    _tableview3.delegate = self;
    _tableview3.dataSource = self;
    _tableview3.backgroundColor = [UIColor ex_colorFromHexRGB:@"FFFFFF"];
    _tableview3.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableview3 registerNib:[UINib nibWithNibName:kCellId bundle:nil] forCellReuseIdentifier:kCellId];
    [self addSubview:_tableview3];
    [self loadAddressData];
    
}

- (void)loadAddressData {
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"txt"];
    NSError  * error;
    NSString * str22 = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        return;
    }
    NSDictionary *dic = [self dictionaryWithJsonString:str22];
    _dataAry = [@[] mutableCopy];
    [_dataAry addObjectsFromArray:dic[@"region"]];
    [_tableview1 reloadData];
    [_tableview2 reloadData];
    [_tableview3 reloadData];
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData  * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * err;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    if(err) {
        YJLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableview1) {
        return _dataAry.count;
    } else if (tableView == _tableview2) {
        return [_dataAry[_itemOneSel][@"children"] count];
    } else {
        return [_dataAry[_itemOneSel][@"children"][_itemTwoSel][@"children_children"] count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableview1) {
        YJAddressViewCell *cell = [[YJAddressViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId];
        if (!cell) {
            cell = [_tableview1 dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = _dataAry[indexPath.row][@"province"];
        cell.textLabel.highlightedTextColor = [UIColor ex_colorFromHexRGB:@"A746E8"];
        cell.textLabel.textColor = [UIColor ex_colorFromHexRGB:@"A746E8"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    } else if (tableView == _tableview2) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId];
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = _dataAry[_itemOneSel][@"children"][indexPath.row][@"name"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.highlightedTextColor = [UIColor ex_colorFromHexRGB:@"A746E8"];
        cell.textLabel.textColor = [UIColor ex_colorFromHexRGB:@"333333"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId];
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor ex_colorFromHexRGB:@"FAFAFA"];
        cell.textLabel.highlightedTextColor = [UIColor ex_colorFromHexRGB:@"A746E8"];
        cell.textLabel.textColor = [UIColor ex_colorFromHexRGB:@"333333"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = _dataAry[_itemOneSel][@"children"][_itemTwoSel][@"children_children"][indexPath.row][@"name"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableview1) {
        _itemOneSel = indexPath.row;
        _itemTwoSel = 0;
        [_tableview2 reloadData];
        [_tableview3 reloadData];
    }
    if (tableView == _tableview2) {
        _itemTwoSel = indexPath.row;
        [_tableview3 reloadData];
        if (indexPath.row == 0) {
            self.hidden = YES;
            [self.delegate addressTAPActionWithRegion:@"" andPlate:@""];
        }
    }
    if (tableView == _tableview3) {
        self.hidden = YES;
        _itemThreeSel = indexPath.row;
        [self.delegate addressTAPActionWithRegion:_dataAry[_itemOneSel][@"children"][_itemTwoSel][@"id"] andPlate:_dataAry[_itemOneSel][@"children"][_itemTwoSel][@"children_children"][_itemThreeSel][@"id"]];
    }
    
    
}
- (void)refreshTabelView {
    [_tableview2 reloadData];
    [_tableview3 reloadData];
}
@end
