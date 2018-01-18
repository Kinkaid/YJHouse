//
//  YJNetRequestTimeoutView.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/26.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJRequestTimeoutDelegate <NSObject>

-(void)requestTimeoutAction;

@end

@interface YJNetRequestTimeoutView : UIView

@property (nonatomic,weak)id<YJRequestTimeoutDelegate>delegate;

@end
