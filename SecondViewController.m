//
//  SecondViewController.m
//  PlatformSDK
//
//  Created by tiger on 2017/4/26.
//  Copyright © 2017年 UQ Interactive. All rights reserved.
//

#import "SecondViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface SecondViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *cWebView;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.cWebView];
    [self loadRequest];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.cWebView.frame = self.view.frame;
}

- (void)loadRequest {
//    NSURL *url = [NSURL URLWithString:@"ht tps://wxpay.wxutil.com/mch/pay/h5.v2.php"];
    NSURL *url = [NSURL URLWithString:@"http:127.0.0.1/resource/baidu.html"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0f];
    [self.cWebView loadRequest:urlRequest];
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
    NSString *jsTitleStr = @"document.title";
    NSString *jsTitle = [webView stringByEvaluatingJavaScriptFromString:jsTitleStr];
    self.title = jsTitle;
    NSString *jsstr = @"document.body.style.webkitTextSizeAdjust='none'";
    [webView stringByEvaluatingJavaScriptFromString:jsstr];
}
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('backBtn')"];
//    NSString *backBtnSelector = [self.upayWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('backBtn')"];
//    SEL closeUPayView = NSSelectorFromString(backBtnSelector);
//    if ([self respondsToSelector:closeUPayView]) {
//        [self performSelector:closeUPayView withObject:nil];
//    }

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
