//
//  YJSystemHeaderViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/19.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJSystemHeaderViewController.h"
#import "YJSystemHeaderCollectionViewCell.h"
#define kCellIdentifier @"YJSystemHeaderCollectionViewCell"
@interface YJSystemHeaderViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,assign) NSInteger selectedNum;


@end

@implementation YJSystemHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedNum = 100;
    [self setTitle:@"推荐头像"];
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(APP_SCREEN_WIDTH - 60, 24, 60, 40);
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [self setNavigationBarItem:commitBtn];
    [self registerCollectionView];
}
     
- (void)registerCollectionView {
    [self.collectionView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
  
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 15;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YJSystemHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    [cell showDataWithIndexPath:indexPath.row withSec:self.selectedNum];
    return cell;
}
//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20.0;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20.0, 20.0, 20.0);
}
//最小内部对象间距(也就是同一行,两个cell间的距离)
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20.0;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((APP_SCREEN_WIDTH -100.0) / 4.0, ((APP_SCREEN_WIDTH -100.0) / 4.0));
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedNum = indexPath.row;
    [self.collectionView reloadData];
}
- (void)returnHeaderImgBlock:(headerImgBlock)block {
    self.imgBlock = block;
}
- (void)commitAction {
    if (self.selectedNum >14) {
        [YJApplicationUtil alertHud:@"请选择头像" afterDelay:1];
        return;
    }
    self.imgBlock([UIImage imageNamed:[NSString stringWithFormat:@"icon_header_%ld",self.selectedNum+1]]);
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
@end
