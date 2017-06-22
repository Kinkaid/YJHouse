//
//  YJFirstScrollViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/6/10.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJFirstScrollViewController.h"
#import "YJFirstStepViewController.h"
@interface YJFirstScrollViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControll;

@end

@implementation YJFirstScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    [self initWithScrollView];
}

- (void)initWithScrollView {
    NSArray *imgAry = @[@"icon_des_1",@"icon_des_2",@"icon_des_3",@"icon_des_4",@"icon_des_5"];
    self.scrollView.contentSize = CGSizeMake(APP_SCREEN_WIDTH *imgAry.count, APP_SCREEN_HEIGHT);
    for (int i=0; i<imgAry.count; i++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH *i, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
        img.image = [UIImage imageNamed:imgAry[i]];
        [self.scrollView addSubview:img];
        if (i == imgAry.count-1) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH / 2 - 60, APP_SCREEN_HEIGHT - 120, 120, 36)];
            btn.backgroundColor = [UIColor ex_colorFromHexRGB:@"A646E8"];
            [btn setTitle:@"点击进入" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            img.userInteractionEnabled = YES;
            [img addSubview:btn];
            [btn addTarget:self action:@selector(clickEnter) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}
- (void)clickEnter {
    YJFirstStepViewController *vc= [[YJFirstStepViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.firstEnter = YES;
    self.view.window.rootViewController = nav;
    [self.view removeFromSuperview];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        self.pageControll.currentPage = scrollView.contentOffset.x / APP_SCREEN_WIDTH;
    }
    
}
@end
