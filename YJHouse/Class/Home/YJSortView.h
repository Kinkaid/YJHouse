//
//  YJSortView.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/17.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJSortDelegate <NSObject>

- (void)sortByTag:(NSInteger)tag;
- (void)hiddenSortView;
@end

@interface YJSortView : UIView

typedef enum : NSUInteger {
    houseType,
    xiaoquType
} YJSortType;

@property (nonatomic,weak)id<YJSortDelegate>delegate;
@property (nonatomic,assign) YJSortType sortType;
- (void)initWithSortBtn;
@end
