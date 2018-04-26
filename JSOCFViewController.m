//
//  JSOCFViewController.m
//  WebViewTest02
//
//  Created by tiger on 2017/8/14.
//  Copyright © 2017年 gob. All rights reserved.
//

#import "JSOCFViewController.h"
#import "WebViewJavascriptBridge.h"
#import "WKWebViewJavascriptBridge.h"

@interface JSOCFViewController () <UIWebViewDelegate, WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong) UIWebView *cWebView;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;
@end

@implementation JSOCFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.cWebView];
//    [self.view addSubview:self.wkWebView];
    [self loadRequest];
    [self initJSBridge];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refreshPage)];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.cWebView.frame = self.view.bounds;
//    self.wkWebView.frame = self.view.bounds;
}

- (void)refreshPage {
    [self.cWebView reload];
//    [self.wkWebView reload];
}

- (void)loadRequest {
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"ocjs_test01" withExtension:@"html"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:fileUrl];
    [self.cWebView loadRequest:urlRequest];
//    [self.wkWebView loadRequest:urlRequest];
}

- (void)initJSBridge {
    // 1. 开启日志
    [WebViewJavascriptBridge enableLogging];
    // 2. 给cWebView建立OC和JS的桥接
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.cWebView];
    //设置代理
    [self.bridge setWebViewDelegate:self];
    
    [self renderButtons:self.cWebView];
    
    // 3. 注册HandleName用于JS端调用OC
    
    // 这是JS会调用getUserIdFromObjC方法，这是OC注册给JS调用的
    // JS需要回调，当然JS也可以传参数过来。data就是JS所传的参数，不一定需要传
    // OC端通过responseCallback回调JS端，JS就可以得到所需要的数据
    
    //获得用户名
    [self.bridge registerHandler:@"getUserIdFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js call getUserIdFromObjC, data from js is%@--%@", data, responseCallback);
        if (responseCallback) {
            //反馈给JS
            responseCallback(@{@"userId":@"20170814001"});
        }
    }];
    
    //获得博客名称
    [self.bridge registerHandler:@"getBlogNameFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js call getUserIdFromObjC, data from js is%@--%@", data, responseCallback);
        if (responseCallback) {
            responseCallback(@{@"blogName":@"啊哈哈"});
        }
    }];
    
    //4. 直接调用JS端注册的HandleName
    [self.bridge callHandler:@"getUserInfos" data:@{@"name":@"嗯啊"} responseCallback:^(id responseData) {
        NSLog(@"from js: %@", responseData);
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"request的参数%@--%@", request.URL.scheme, request.URL.resourceSpecifier);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
}

- (UIWebView *)cWebView {
    if (!_cWebView) {
        _cWebView = [[UIWebView alloc] init];
        _cWebView.delegate = self;
        _cWebView.backgroundColor = [UIColor lightGrayColor];
        _cWebView.scalesPageToFit = YES;
    }
    return _cWebView;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] init];
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        _wkWebView.backgroundColor = [UIColor lightGrayColor];
    }
    return _wkWebView;
}

- (void)renderButtons:(UIWebView*)webView {
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"打开博文" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(onOpenBlogArticle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callbackButton aboveSubview:webView];
    callbackButton.frame = CGRectMake(10, 400, 100, 35);
    callbackButton.titleLabel.font = font;
    
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadButton setTitle:@"刷新webview" forState:UIControlStateNormal];
    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:reloadButton aboveSubview:webView];
    reloadButton.frame = CGRectMake(110, 400, 100, 35);
    reloadButton.titleLabel.font = font;
}

- (void)onOpenBlogArticle:(id)sender {
    // 调用打开本demo的博文
    [self.bridge callHandler:@"openWebviewBridgeArticle" data:nil];
}

- (NSData *)dataWithString:(NSString *)aString
{
    NSString *encodeString = [aString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [encodeString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
