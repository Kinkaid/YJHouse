//
//  WDWebView.h
//  wadaoduobao
//
//  Created by 刘金凯 on 2016/10/22.
//  Copyright © 2016年 iju. All rights reserved.
//

#import <WebKit/WebKit.h>

@protocol WDWebViewNavigationDelegate;

@interface WDWebView : WKWebView

@property (nonatomic, weak) id <WDWebViewNavigationDelegate> navDelegate;

@end

@protocol WDWebViewNavigationDelegate <WKNavigationDelegate>

- (void)webView:(WDWebView *)webView didUpdateProgress:(CGFloat)progress;

@end
