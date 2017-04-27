//
//  YJAddressView.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/12.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJAddressClickDelegate <NSObject>

- (void)addressTAPActionWithRegion:(NSString *)regionID andPlate:(NSString *)plateID;

@end

@interface YJAddressView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)id<YJAddressClickDelegate>delegate;
@end
