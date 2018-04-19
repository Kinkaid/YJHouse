//
//  YJLoginView.h
//  YJHouse
//
//  Created by fangkuai on 2018/1/20.
//  Copyright © 2018年 刘金凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJLoginViewDelegate<NSObject>

- (void)wxLoginAction;
- (void)sinaLoginAction;
@end

@interface YJLoginView : UIView
@property (nonatomic,weak) id<YJLoginViewDelegate>delegate;
@end
