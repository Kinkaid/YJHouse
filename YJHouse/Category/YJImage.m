//
//  YJImage.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/17.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJImage.h"

@implementation YJImage

+ (UIImage *)imageNameWithOriginalMode:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    
    // imageWithRenderingMode:返回一个没有被渲染的图片
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
@end
