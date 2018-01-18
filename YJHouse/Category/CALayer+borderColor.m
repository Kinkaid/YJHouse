//
//  CALayer+borderColor.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/18.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "CALayer+borderColor.h"

@implementation CALayer (borderColor)

- (void)setBorderColorFromUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

@end
