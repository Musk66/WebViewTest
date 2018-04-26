//
//  BluePayViewController.m
//  WebViewTest02
//
//  Created by tiger on 2017/7/4.
//  Copyright © 2017年 gob. All rights reserved.
//

#import "BluePayViewController.h"

@interface BluePayViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *cWebView;
@property (nonatomic, strong) NSString * webUrl;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSTimer *timeoutTimer;
@property (nonatomic, strong) UIBarButtonItem *rightBarItem;
@end

@implementation BluePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.sourceLabel];
    [self.view addSubview:self.cWebView];
    self.webUrl = @"http://127.0.0.1/other1/upay2/index.html";
    [self loadRequest];
    self.navigationItem.rightBarButtonItem = self.rightBarItem;
    [self.view addSubview:self.progressView];
//    self.cWebView.scrollView.scrollEnabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_timeoutTimer invalidate];
    [self.cWebView stopLoading];
    [self.cWebView loadRequest:nil];
    self.cWebView.delegate = nil;
    [self.cWebView removeFromSuperview];
    self.cWebView = nil;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat screenWitdh = self.view.bounds.size.width;
    CGFloat screenHeight = self.view.bounds.size.height;
    UIDeviceOrientation dOri = [UIDevice currentDevice].orientation;
    if (dOri == UIDeviceOrientationLandscapeLeft || dOri ==UIDeviceOrientationLandscapeRight) {
        self.cWebView.frame  = CGRectMake(0, 64-12, screenWitdh, screenHeight);
        self.sourceLabel.frame = CGRectMake(0, 64-12+2, screenWitdh, 26);
        self.progressView.frame = CGRectMake(0, 64-12, screenWitdh, 2);
    } else {
        self.cWebView.frame  = CGRectMake(0, 64, screenWitdh, screenHeight-64);
        self.sourceLabel.frame = CGRectMake(0, 64+2, screenWitdh, 26);
        self.progressView.frame = CGRectMake(0, 64, screenWitdh, 2);
    }
}

//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

- (void)loadRequest {
    NSURL *url = [NSURL URLWithString:self.webUrl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0f];
    [self.cWebView loadRequest:urlRequest];
    _timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:20.0f target:self selector:@selector(loadFailureHandler) userInfo:nil repeats:NO];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"page should start");
    NSLog(@"request的参数%@--%@", request.URL.scheme, request.URL.resourceSpecifier);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"page started");
    self.progressView.hidden = NO;
    //__weak MyController *weakSelf = self;  __weak __typeof(self) weakSelf = self;
    __weak typeof(self) weakSelf = self;
    [UIView animateKeyframesWithDuration:15.0f delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        weakSelf.progressView.progress = 0.6;
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.03 animations:^{
            [weakSelf.progressView layoutIfNeeded];
        }];
        weakSelf.progressView.progress = 0.85;
        [UIView addKeyframeWithRelativeStartTime:0.03 relativeDuration:0.3 animations:^{
            [weakSelf.progressView layoutIfNeeded];
        }];
        weakSelf.progressView.progress = 0.95;
        [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:1.0 animations:^{
            [weakSelf.progressView layoutIfNeeded];
        }];
    } completion:^(BOOL finished) {
        if (finished) {
            NSLog(@"start finished");
        }
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"page finished");
    
    [_timeoutTimer invalidate];
    
    [self.progressView setProgress:1.0 animated:YES];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.progressView.alpha = 0;
    } completion:^(BOOL finished) {
        weakSelf.progressView.hidden = YES;
        weakSelf.progressView.alpha = 1.0;
        weakSelf.progressView.progress = 0;
    }];
    
    NSString *pageTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (pageTitle.length >10) {
        pageTitle = [[pageTitle substringToIndex:12] stringByAppendingString:@"..."];
    }
    self.title = pageTitle;
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('backBtn')"];
    //    NSString *backBtnSelector = [self.upayWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('backBtn')"];
    //    SEL closeUPayView = NSSelectorFromString(backBtnSelector);
    //    if ([self respondsToSelector:closeUPayView]) {
    //        [self performSelector:closeUPayView withObject:nil];
    //    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (error) {
        NSLog(@"错误原因->%@--%@--%@", error, error.localizedDescription, error.description);
    }
}

- (void)loadFailureHandler {
    self.progressView.hidden = YES;
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"加载失败！请检查网址后重试！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了确定");
    }];
    [alertC addAction:okAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)reloadPage {
    if (self.cWebView.isLoading) {
        [self.cWebView stopLoading];
    }
    [_timeoutTimer invalidate];
    [self.cWebView reload];
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

- (UILabel *)sourceLabel {
    if (!_sourceLabel) {
        _sourceLabel = [[UILabel alloc] init];
        _sourceLabel.numberOfLines = 0;
        _sourceLabel.textColor = [UIColor blackColor];
        _sourceLabel.textAlignment = NSTextAlignmentCenter;
        _sourceLabel.font = [UIFont systemFontOfSize:13];
        if (self.webUrl.length >0) {
            if ([self.webUrl hasPrefix:@"http"]) {
                NSRange range = [self.webUrl rangeOfString:@"://"];
                NSString *subUrl1 = [self.webUrl substringFromIndex:range.location+range.length];
                NSString *subUrl2 = [[subUrl1 componentsSeparatedByString:@"/"] firstObject];
                _sourceLabel.text = [NSString stringWithFormat:@"此网页由 %@ 提供", subUrl2];
            } else {
                _sourceLabel.text = [NSString stringWithFormat:@"此网页由 %@ 提供", self.webUrl];
            }
        }
    }
    return _sourceLabel;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progressView.hidden = YES;
        _progressView.progress = 0;
        _progressView.progressTintColor = [UIColor orangeColor];
    }
    return _progressView;
}

- (UIBarButtonItem *)rightBarItem {
    if (!_rightBarItem) {
        _rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(reloadPage)];
    }
    return _rightBarItem;
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
