//
//  YJFiveStepViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/2.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJFiveStepViewController.h"
#import "YJFiveStepCollectionViewCell.h"
#define kCellId @"YJFiveStepCollectionViewCell"
@interface YJFiveStepViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *picAry;
@property (nonatomic,strong) NSMutableArray *titleAry;
@property (nonatomic,strong) NSMutableArray *selectAry;

@end

@implementation YJFiveStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    [self registerCollectionView];
}
- (void)registerCollectionView {
    [self.collectionView registerNib:[UINib nibWithNibName:kCellId bundle:nil] forCellWithReuseIdentifier:kCellId];
    self.picAry = [@[] mutableCopy];
    self.titleAry = [@[] mutableCopy];
    self.selectAry = [@[] mutableCopy];
    [self.picAry addObjectsFromArray:@[@"icon_xyj",@"icon_c",@"icon_bx",@"icon_wl",@"icon_ds",@"icon_rsq",@"icon_kt",@"icon_trq",@"icon_jj"]];
    [self.titleAry addObjectsFromArray:@[@"洗衣机",@"床",@"冰箱",@"网络",@"电视",@"热水器",@"空调",@"天然气",@"家具"]];
    [self.selectAry addObjectsFromArray:@[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)]];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.picAry.count;
}
//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 9.0;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 40.0, 9.0, 40.0);
}
//最小内部对象间距(也就是同一行,两个cell间的距离)
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 9.0;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((APP_SCREEN_WIDTH -120.0) / 3.0, ((APP_SCREEN_WIDTH -120.0) / 3.0) * 189.0 /168.0  + 26);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YJFiveStepCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    [cell showDataWithTitle:self.titleAry[indexPath.row] andImg:self.picAry[indexPath.row] andSelect:[self.selectAry[indexPath.row] boolValue]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.selectAry[indexPath.row] boolValue]) {
        [self.selectAry replaceObjectAtIndex:indexPath.row withObject:@(NO)];
    } else {
       [self.selectAry replaceObjectAtIndex:indexPath.row withObject:@(YES)];
    }
    [self.collectionView reloadData];
}

- (IBAction)nextStepClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
