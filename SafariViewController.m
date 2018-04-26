//
//  SafariViewController.m
//  WebViewTest02
//
//  Created by tiger on 2018/4/23.
//  Copyright © 2018年 gob. All rights reserved.
//

#import "SafariViewController.h"
#import <SafariServices/SafariServices.h>

@interface SafariViewController () <SFSafariViewControllerDelegate>
//@property (nonatomic, strong) SFSafariViewController *sfSafariVc;
@end

@implementation SafariViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *urlStr = @"http://www.baidu.com";
    SFSafariViewController *sfSafariVc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:urlStr]];
    sfSafariVc.delegate = self;
    [self presentViewController:sfSafariVc animated:YES completion:^{
        NSLog(@"SFSafariViewController load completion.");
    }];
}

- (void)safariViewControllerDidFinish:(nonnull SFSafariViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
