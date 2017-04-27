//
//  WDNoCopyTextField.m
//  Wadaowfx
//
//  Created by 刘金凯 on 2017/3/21.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "WDNoCopyTextField.h"

@implementation WDNoCopyTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}


@end
