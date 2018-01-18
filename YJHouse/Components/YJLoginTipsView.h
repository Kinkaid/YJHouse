//
//  YJLoginTipsView.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/12/5.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJLoginTipsViewShowDelegate <NSObject>

- (void)cancelLoginTipsAction;
- (void)gotoLoginAction;

@end

@interface YJLoginTipsView : UIView
@property (nonatomic,weak) id<YJLoginTipsViewShowDelegate>delegate;
@end
