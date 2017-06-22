//
//  YJSettingViewCell.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/6/10.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJSettingViewCell.h"
#import <SDImageCache.h>
#import <SVProgressHUD.h>
@implementation YJSettingViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView startAnimating];
        self.accessoryView = loadingView;
        
        self.textLabel.text = @"清楚缓存";
        //        [self.textLabel setTextColor:[UIColor blueColor]];
        self.detailTextLabel.text = @"正在计算";
        
        self.userInteractionEnabled = NO;
        
        __weak typeof(self) weakSelf = self;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [NSThread sleepForTimeInterval:1.0];
            
            unsigned long long size = [SDImageCache sharedImageCache].getSize;   //SDImage 缓存
            if (weakSelf == nil) return;
            NSString *sizeText = nil;
            if (size >= pow(10, 9)) {
                sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
            }else if (size >= pow(10, 6)) {
                sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
            }else if (size >= pow(10, 3)) {
                sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
            }else {
                sizeText = [NSString stringWithFormat:@"%zdB", size];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                weakSelf.detailTextLabel.text = [NSString stringWithFormat:@"%@",sizeText];
                weakSelf.accessoryView = nil;
                weakSelf.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                [weakSelf addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(clearCacheClick)]];
                
                weakSelf.userInteractionEnabled = YES;
                
            });
            
        });
        
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)clearCacheClick
{
    [SVProgressHUD showWithStatus:@"正在清除缓存···"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [NSThread sleepForTimeInterval:2.0];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
                
                // 设置文字
                self.detailTextLabel.text = nil;
                
            });
            
        });
    }];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // cell重新显示的时候, 继续转圈圈
    UIActivityIndicatorView *loadingView = (UIActivityIndicatorView *)self.accessoryView;
    [loadingView startAnimating];
}
@end
