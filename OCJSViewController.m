//
//  OCJSViewController.m
//  PlatformSDK
//
//  Created by tiger on 2017/4/26.
//  Copyright © 2017年 UQ Interactive. All rights reserved.
//

#import "OCJSViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface OCJSViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *cWebView;
@end

@implementation OCJSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.cWebView];
    [self loadRequest];
//    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refreshPage)];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.cWebView.frame = self.view.bounds;
}

- (void)refreshPage {
    [self.cWebView reload];
}

- (void)loadRequest {
    NSURL *url = [NSURL URLWithString:@"http://192.168.32.118/test/ocjs_test01.html"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:2.0f];
    [self.cWebView loadRequest:urlRequest];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"request的参数%@--%@", request.URL.scheme, request.URL.resourceSpecifier);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //获取网页的title
    NSString *jsStr1 = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self alertWithMessage:jsStr1];
    
    //oc调用js的事件，并弹出传入的参数
    NSString *jsStr2 = [NSString stringWithFormat:@"showAlert('%@')",@"这里是JS中alert弹出的message"];
    [webView stringByEvaluatingJavaScriptFromString:jsStr2];
    
    //oc调用js事件，并修改页面内容
    //注意：js中的字符串必须加上单引号
    NSString *jsStr3 = @"document.getElementById('ocModifyHtml').innerHTML='OC修改HTML的内容'";
//    NSString *jsStr4 = [NSString stringWithFormat:@"document.getElementById('ocModifyHtml').innerHTML='%@'", self.title];
    [webView stringByEvaluatingJavaScriptFromString:jsStr3];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
}

- (void)alertWithMessage:(NSString *)msg {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"OC弹出的message" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", nil];
    [alertView show];
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

- (NSData *)dataWithString:(NSString *)aString
{
    NSString *encodeString = [aString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [encodeString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
