//
//  YJRequestTimeoutUtil.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/26.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YJNetRequestTimeoutView.h"
@interface YJRequestTimeoutUtil : NSObject

+ (YJNetRequestTimeoutView *)shareInstance;

+ (void)showRequestErrorView;

+ (void)hiddenRequestErrorView;

@end
