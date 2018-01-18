//
//  UIColor+YJColor.h
//  
//
//  Created by 刘金凯 on 2017/2/17.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (YJColor)

+ (UIColor *)ex_colorFromHexRGB:(NSString *)inColorString;

+ (UIColor *)ex_colorWithHexString:(NSString *)stringToConvert;

+ (UIColor *)ex_colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha;

+ (UIColor *)ex_colorFromInt:(NSInteger)intValue;

- (BOOL)ex_isEqualToColor:(UIColor *)color;

@end
