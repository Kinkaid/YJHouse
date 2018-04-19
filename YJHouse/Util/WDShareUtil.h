//
//  WDShareUtil.h
//  wadaoduobao
//
//  Created by 刘金凯 on 2016/10/12.
//  Copyright © 2016年 iju. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
    shareQQFriends,
    shareQQzone,
    shareWXFriends,
    shareWXzone,
    shareSinaWeibo
} WDShareType;

@interface WDShareUtil : NSObject

+ (void)shareTye:(WDShareType)shareType withImageAry:(NSArray *)imageAry withUrl:(NSString *)url withTitle:(NSString *)title withContent:(NSString *)content isPic:(BOOL)isPic;

@end
