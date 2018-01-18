//
//  WDWebKitViewController.m
//  wadaoduobao
//
//  Created by 刘金凯 on 2016/10/22.
//  Copyright © 2016年 iju. All rights reserved.
//

#import "WDWebKitViewController.h"
#import "YJMessageHandler.h"
@interface WDWebKitViewController ()<WKUIDelegate,WKNavigationDelegate,WDWebViewNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) NSURLRequest *loadRequest;

@end

@implementation WDWebKitViewController

- (void)dealloc {
    self.webView.navDelegate = nil;
    self.webView.UIDelegate = nil;
}

#pragma mark - Accessor
- (WKWebView *)webView {
    if (!_webView) {
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        [userContentController addScriptMessageHandler:[[YJMessageHandler alloc] initWithDelegate:self] name:@"doPush"];
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        _webView = [[WDWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.UIDelegate = self;
        _webView.navDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES;
        
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (UIProgressView *)progressBar {
    if (!_progressBar) {
        UIProgressView *progressView = [[UIProgressView alloc] init];
        progressView.trackTintColor = [UIColor clearColor];
        progressView.alpha = 0.0f;
        progressView.frame = CGRectMake(0, KIsiPhoneX?88:64, self.view.frame.size.width, 2.0);
        [self.view addSubview:progressView];
        _progressBar = progressView;
    }
    return _progressBar;
}

#pragma mark - Initizaltion
- (instancetype)initWithRequest:(NSURLRequest *)request
{
    if ((self = [super initWithNibName:nil bundle:nil])) {
        self.hidesBottomBarWhenPushed = YES;
        [self commonInit];
        [self openRequest:request];
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)URL
{
    return [self initWithRequest:[NSURLRequest requestWithURL:URL]];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithRequest:nil];
}

- (instancetype)init {
    return [self initWithRequest:nil];
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.webView stopLoading];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self clearProgressViewAnimated:animated];
}

#pragma mark - init data
- (void)commonInit {
    self.showLoadingProgress = YES;
}

#pragma mark - open webview

- (void)openURL:(NSURL *)URL {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [self openRequest:request];
}

- (void)openRequest:(NSURLRequest *)request {
    self.loadRequest = request;
    
    if ([self isViewLoaded]) {
        if (nil != request) {
            [self.webView loadRequest:request];
        } else {
            [self.webView stopLoading];
        }
    }
}

- (void)openHTMLString:(NSString *)htmlString baseURL:(NSURL *)baseUrl {
    [self.webView loadHTMLString:htmlString baseURL:baseUrl];
}

#pragma mark - Private
- (void)updateProgress {
    BOOL completed = self.webView.estimatedProgress == 1 ;
    [self.progressBar setProgress:self.webView.estimatedProgress animated:YES];
    if (completed) {
        [self performSelector:@selector(progressCompleted) withObject:nil afterDelay:0.25];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = !completed;
}

- (void)progressCompleted {
    [self.progressBar setProgress:0.0];
}

#pragma mark - Progress
- (void)clearProgressViewAnimated:(BOOL)animated
{
    [UIView animateWithDuration:animated ? 0.25 : 0.0
                     animations:^{
                         self.progressBar.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self destroyProgressViewIfNeeded];
                     }];
}

- (void)destroyProgressViewIfNeeded
{
    if (self.progressBar) {
        [self.progressBar removeFromSuperview];
        self.progressBar = nil;
    }
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler {
    
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    
}


#pragma mark - WKNavigationDelegate
- (void)webView:(WDWebView *)webView didUpdateProgress:(CGFloat)progress {
    if (!self.showLoadingProgress) {
        [self destroyProgressViewIfNeeded];
        return;
    }
    if (self.progressBar.alpha == 0 && progress > 0) {
        self.progressBar.progress = 0;
        [UIView animateWithDuration:0.2 animations:^{
            self.progressBar.alpha = 1.0;
        }];
    } else if (self.progressBar.alpha == 1.0 && progress == 1.0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.progressBar.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.progressBar.progress = 0;
        }];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = !(progress == 1);
    [self.progressBar setProgress:progress animated:YES];
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    decisionHandler(actionPolicy);
    [self.delegate webKitDoPush:navigationAction.request.URL.absoluteString];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.title = self.webView.title;
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
}

#pragma mark - View Auto-Rotation
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    return YES;
}

@end
