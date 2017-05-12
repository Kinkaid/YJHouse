//
//  YJZFMoreView.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/17.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJZFSortDelegate <NSObject>

- (void)zfSortWithParams:(NSDictionary *)params;

@end

@interface YJZFMoreView : UIView

@property (nonatomic,weak)id<YJZFSortDelegate>delegate;
- (void)initWithZFBtn;
@end
