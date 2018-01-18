//
//  WDWebKitViewController.h
//  wadaoduobao
//
//  Created by 刘金凯 on 2016/10/22.
//  Copyright © 2016年 iju. All rights reserved.
//

#import "YJBaseViewController.h"
#import "WDWebView.h"

@protocol WDWebViewDoPushDelegate <NSObject>

- (void)webKitDoPush:(NSString *)absoluteString;

@end

@interface WDWebKitViewController : YJBaseViewController

@property (nonatomic,strong)WDWebView *webView;
@property (nonatomic, strong) UIProgressView *progressBar;

@property (nonatomic, assign) BOOL showLoadingProgress;
@property (nonatomic,assign) id<WDWebViewDoPushDelegate>delegate;

- (instancetype)initWithRequest:(NSURLRequest *)request;
- (instancetype)initWithURL:(NSURL *)URL;

- (void)openURL:(NSURL *)URL;
- (void)openRequest:(NSURLRequest *)request;
- (void)openHTMLString:(NSString *)htmlString baseURL:(NSURL *)baseUrl;

@end
