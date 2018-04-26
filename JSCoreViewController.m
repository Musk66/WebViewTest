//
//  JSCoreViewController.m
//  PlatformSDK
//
//  Created by tiger on 2017/4/26.
//  Copyright © 2017年 UQ Interactive. All rights reserved.
//

#import "JSCoreViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface JSCoreViewController() <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *cWebView;
@end

@implementation JSCoreViewController
/*
//info.plist中的(View controller-based status bar appearance)项必须设置成YES才生效，组合使用
//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    return NO;
}

//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}
*/

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
    //192.168.32.118
    NSURL *url = [NSURL URLWithString:@"http://192.168.32.118/test/ocjs_test02.html"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:2.0f];
    [self.cWebView loadRequest:urlRequest];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"request的参数%@--%@", request.URL.scheme, request.URL.resourceSpecifier);
    if ([request.URL.absoluteString containsString:@"weixin://"]) {
        NSURL *url = [NSURL URLWithString:request.URL.absoluteString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        return NO;
    }
    
    /*
    //注意：这个方法会把scheme全部转换为小写字母?，scheme是testview://closePage中的testview
    NSString *urlStr = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //JS触发OC的方法
    if ([urlStr containsString:[@"testView://" lowercaseString]]) {
        NSString *paramsStr = [urlStr componentsSeparatedByString:@"//"][1];
        if ([paramsStr isEqualToString:@"closePage"]) {
            SEL closePage = NSSelectorFromString(paramsStr);
            if ([self respondsToSelector:closePage]) {
                //必须在主线程中执行
                [self performSelectorOnMainThread:closePage withObject:nil waitUntilDone:YES];
            } else{
                NSLog(@"不存在的方法名");
            }
            return NO;
        }
    }
    */
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //重点：stringByEvaluatingJavaScriptFromString是一个同步的方法，使用它执行JS方法时，如果JS 方法比较耗的时候，会造成界面卡顿。尤其是js 弹出alert 的时候。alert 也会阻塞界面，等待用户响应，而stringByEvaluatingJavaScriptFromString又会等待js执行完毕返回。这就造成了死锁。
    //获取JS的上下文
    JSContext *context = [self.cWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //JS调用OC
    //需要在block中传入方法名，showTip是已经在js中定义好的方法名
    context[@"showArguments"] = ^() {
        NSLog(@"+++++++Begin Log+++++++");
        
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"参数：%@", jsVal.toString);
        }
        
        //注意：可能最新版本的iOS系统做了改动，现在（iOS9，Xcode 7.3，去年使用Xcode 6 和iOS 8没有线程问题）中测试,block中是在子线程，因此执行UI操作，控制台有警告，需要回到主线程再操作UI。
        dispatch_async(dispatch_get_main_queue(), ^{
            [self alertWithMessage:@"oc使用jscontext调用js"];
        });
        NSLog(@"-------End Log-------");
    };
    
    //OC调用JS
    //方法1
    NSString *jsStr = [NSString stringWithFormat:@"showAlert('%@')",@"这里是JS中alert弹出的message"];
    [webView stringByEvaluatingJavaScriptFromString:jsStr];
    
    //方法2
    NSString *textJS = @"showAlert('JS中alert弹出的message')";
    [context evaluateScript:textJS];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
}

- (void)closePage {
    NSLog(@"点击了网页的关闭按钮");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertWithMessage:(NSString *)msg {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"JSCore提示" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
