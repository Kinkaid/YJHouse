//
//  NetworkTool.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/7.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef enum {
    GET,       //Get
    POST       //Post
} ReqeustWay;

@interface NetworkTool : AFHTTPSessionManager

/**
 创建网络请求工具类的单例
 */
+ (instancetype)sharedTool;

/**
 创建请求方法
 */

- (void)requestWithURLString: (NSString *)URLString
                  parameters: (NSDictionary *)parameters
                      method: (ReqeustWay)method
                    callBack: (void(^)(id responseObject))callBack
                       error:(void(^)(NSError *error))failure;

@end
