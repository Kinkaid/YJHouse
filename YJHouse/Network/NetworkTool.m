//
//  NetworkTool.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/7.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "NetworkTool.h"

@implementation NetworkTool

+ (instancetype)sharedTool {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:nil];
    });
    return instance;
}

- (void)requestWithURLString: (NSString *)URLString
                  parameters: (NSDictionary *)parameters
                      method: (ReqeustWay)method
                    callBack: (void(^)(id responseObject))callBack
                       error:(void(^)(NSError *error))failure {
    self.requestSerializer.timeoutInterval = 10.0f;
    if (method == GET) {
        [self GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            callBack(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
            if (error.code == -1001) {
                [YJRequestTimeoutUtil showRequestErrorView];
            }
            [SVProgressHUD dismiss];
        }];
    }
    if (method == POST) {
        [self POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            callBack(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
            if (error.code == -1001) {
                [YJRequestTimeoutUtil showRequestErrorView];
            }
            [SVProgressHUD dismiss];
        }];
    }
}
@end
