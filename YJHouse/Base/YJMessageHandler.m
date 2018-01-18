//
//  YJMessageHandler.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/12/7.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJMessageHandler.h"

@implementation YJMessageHandler

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate{
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
