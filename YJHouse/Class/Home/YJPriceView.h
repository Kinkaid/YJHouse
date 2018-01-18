//
//  YJPriceView.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/13.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDNoCopyTextField.h"
@protocol YJPriceSortDelegate <NSObject>

- (void)priceSortByTag:(NSInteger)tag;
- (void)priceSortWithMinPrice:(NSString *)minPrice maxPrice:(NSString *)maxPrice;
@optional
- (void)hiddenPriceView;
@end

@interface YJPriceView : UIView

typedef enum : NSUInteger {
    houseRent,
    houseBuy,
    xiaoquRent,
    xiaoquBuy
} YJHouseType;

@property (nonatomic,assign) YJHouseType houseType;
@property (nonatomic,strong) WDNoCopyTextField *bTextField;
@property (nonatomic,strong) WDNoCopyTextField *eTextField;
@property (nonatomic,weak) id<YJPriceSortDelegate>delegate;
@end
