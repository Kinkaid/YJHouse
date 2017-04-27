//
//  YJHistorySearchView.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/24.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyViewDelegate <NSObject>

- (void)getKeyValue:(NSString *)str;
- (void)clickDeleKey;

@end

@interface YJHistorySearchView : UIView

@property (nonatomic, strong)NSArray *keyArray;
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UIButton *deleBtn;
@property (nonatomic, weak)id<KeyViewDelegate>delegate;

- (CGFloat)KeyViewH:(NSArray *)array;
- (void)removeAllKey;

@end
