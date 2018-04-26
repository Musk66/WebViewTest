//
//  OpenSafariViewController.m
//  WebViewTest02
//
//  Created by tiger on 2018/1/15.
//  Copyright © 2018年 gob. All rights reserved.
//

#import "OpenSafariViewController.h"

@interface OpenSafariViewController ()
@property (nonatomic, strong) UIButton *openSafariBtn;
@end

@implementation OpenSafariViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.openSafariBtn];
}

- (void)openInSafari {
    NSURL *safariUrl = [NSURL URLWithString:@"http://192.168.32.118/other3/test04.html"];

    //先判断是否能打开该url
    //微信可以不判断直接打开，就不需要添加白名单了
//    if ([[UIApplication sharedApplication] canOpenURL:safariUrl]) {
         BOOL ret = [[UIApplication sharedApplication] openURL:safariUrl];
    NSLog(@"wwwwwwwww:  %d", ret);
//    } else {
//        NSLog(@"url参数错误");
//    }
}

- (UIButton *)openSafariBtn {
    if (!_openSafariBtn) {
        _openSafariBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 134, 26)];
        _openSafariBtn.backgroundColor = [UIColor orangeColor];
        [_openSafariBtn setTitle:@"在Safari打开" forState:UIControlStateNormal];
        [_openSafariBtn addTarget:self action:@selector(openInSafari) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openSafariBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
