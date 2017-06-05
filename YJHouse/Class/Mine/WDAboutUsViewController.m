//
//  WDAboutUsViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/28.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "WDAboutUsViewController.h"

@interface WDAboutUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation WDAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.versionLabel.text = [NSString stringWithFormat:@"v%@",APP_VERSION];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end