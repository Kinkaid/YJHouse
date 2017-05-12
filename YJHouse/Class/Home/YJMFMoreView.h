//
//  YJMFMoreView.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/17.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJMFSortDelegate <NSObject>

- (void)mfSortWithParams:(NSDictionary *)params;

@end


@interface YJMFMoreView : UIView

@property (nonatomic,weak) id<YJMFSortDelegate>delegate;
- (void)initWithMFBtn;
@end
