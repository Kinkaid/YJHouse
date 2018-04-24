//
//  EmptyDataView.m
//  wadaowsc
//
//  Created by fangkuai on 2018/1/23.
//  Copyright © 2018年 刘金凯. All rights reserved.
//

#import "EmptyDataView.h"
NSString * const kEmptyDataViewObserveKeyPath = @"frame";
@implementation EmptyDataView

- (void)dealloc {
    NSLog(@"占位视图正常销毁");
}

@end
