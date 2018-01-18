//
//  YJMessageHandler.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/12/7.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface YJMessageHandler : NSObject<WKScriptMessageHandler>

@property (nonatomic,weak)id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end
