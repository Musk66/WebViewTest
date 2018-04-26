//
//  WebViewController.m
//  PlatformSDK
//
//  Created by tiger on 2017/4/26.
//  Copyright © 2017年 UQ Interactive. All rights reserved.
//

#import "WebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface WebViewController () <UIWebViewDelegate>
//支付页面
@property (nonatomic, strong) UIWebView *cWebView;
////自定义导航栏
//@property (nonatomic, strong) UIView *navBar;
////返回按钮
//@property (nonatomic, strong) UIButton *navBackBtn;
////关闭按钮
//@property (nonatomic, assign) BOOL isPayFinished;
////导航栏标题
//@property (nonatomic, strong) UILabel *navTitleLbl;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.cWebView];
    [self loadRequest];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.cWebView.frame = self.view.bounds;
}

- (NSString *)encryptedData {
    return @"xxx";
}

- (void)loadRequest2 {
    NSURL *url = [NSURL URLWithString:@"http://192.168.34.138:8080/xxx"];
    
    NSString *paramsStr = [NSString stringWithFormat:@"encryptedData=%@&os=%@", [self encryptedData], @"IOS"];
    
    NSMutableURLRequest *mUrlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [mUrlRequest setHTTPMethod:@"POST"];
    [mUrlRequest setHTTPBody:[self dataWithString:paramsStr]];
    [mUrlRequest setValue:@"zh" forHTTPHeaderField:@"Accept-Language"];
//    [mUrlRequest addValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [mUrlRequest setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [self.cWebView loadRequest:mUrlRequest];
}

- (void)loadRequest {
    //wxpay.wxutil.com/mch/pay/h5.v2.php
    //NSURL *url = [NSURL URLWithString:@"http://192.168.32.118:8080/upay/index.jsp"];
    //NSString *paramsStr = [NSString stringWithFormat:@"appName=%@&userName=%@&productPrice=%.2f&productName=%@", @"LOL", @"tencent", 648.00, @"100 jewel"];
    NSURL *url = [NSURL URLWithString:@"https://www.douyu.com/room/speech/invite/1204498?sid=ZOxwXZ5VkAGk"];
    NSMutableURLRequest *mUrlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [mUrlRequest setHTTPMethod:@"GET"];
//    [mUrlRequest setHTTPBody:[self dataWithString:paramsStr]];
    [mUrlRequest setValue:@"zh" forHTTPHeaderField:@"Accept-Language"];
    [mUrlRequest addValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [self.cWebView loadRequest:mUrlRequest];
}

- (void)closeUPayView {
    NSLog(@"点击了网页的关闭按钮");
    [self dismissViewControllerAnimated:YES completion:nil];
}

//1.https ://www.douyu.com/room/speech/invite/1204028?sid=ZOxwXZ5VkAGk
//2.https--//www.douyu.com/room/speech/invite/1203993?sid=ZOxwXZ5VkAGk&from=singlemessage&isappinstalled=1
//2.点击加号1.--http ://live.qq.com/api/douyu?type=6&roomId=1204028
//2.点击加号2.--douyutv?type=6&room_id=1204028--douyutv://?type=6&room_id=1204028
//2.点击加号3.https ://itunes.apple.com/us/app/dou-yu-re-men-gao-qing-you/id863882795
//2.点击加号4.itmss://itunes.apple.com/us/app/dou-yu-re-men-gao-qing-you/id863882795
//3.http ://live.qq.com/api/douyu?type=6&roomId=1204028
//4.douyutv?type=6&room_id=1204028--douyutv://?type=6&room_id=1204028
//5.https ://itunes.apple.com/us/app/dou-yu-re-men-gao-qing-you/id863882795
//6.itmss://itunes.apple.com/us/app/dou-yu-re-men-gao-qing-you/id863882795

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"request的参数%@--%@--%@", request.URL.scheme, request.URL.resourceSpecifier, request.URL);
    NSString *urlString = [[[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding] lowercaseString];
    if ([urlString isEqualToString:[@"wxpay://handleWeChatPay" lowercaseString]]) {
        NSLog(@"微信支付");
        return NO;
    }
    if ([urlString containsString:[@"douyutv" lowercaseString]]) {
        NSLog(@"斗鱼房间");
        [self callApp:request.URL.absoluteString];
        return NO;
    }
    /*
    NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSString *prefixStr = @"upayview://";//upayview://closeUPayView
    NSString *backBtnMethod = [requestString substringFromIndex:(prefixStr.length)];
    //NSString *backBtnSelector = [requestString componentsSeparatedByString:@"://"][1];
    if ([backBtnMethod isEqualToString:@"closeUPayView"]) {
        SEL closeUPayView = NSSelectorFromString(backBtnMethod);
        if ([self respondsToSelector:closeUPayView]) {
            //必须在主线程中执行
            [self performSelectorOnMainThread:closeUPayView withObject:nil waitUntilDone:YES];
            //[self performSelector:closeUPayView withObject:nil];
        }else{
            NSAssert(NO, @"不存在的方法名");
//            NSLog(@"不存在的方法名");
        }
        return NO;
    }
    */
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('backBtn')"];
//    NSString *backBtnSelector = [self.upayWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('backBtn')"];
//    SEL closeUPayView = NSSelectorFromString(backBtnSelector);
//    if ([self respondsToSelector:closeUPayView]) {
//        [self performSelector:closeUPayView withObject:nil];
//    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
}

- (void)callApp:(NSString *)params {
    NSURL *appUrl = [NSURL URLWithString:params];
    //先判断是否能打开该url
    if ([[UIApplication sharedApplication] canOpenURL:appUrl]) {
        [[UIApplication sharedApplication] openURL:appUrl];
    } else {
        NSLog(@"url参数错误");
    }
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
