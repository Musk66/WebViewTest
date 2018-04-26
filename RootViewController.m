//
//  RootViewController.m
//  PlatformSDK
//
//  Created by tiger on 2017/4/26.
//  Copyright © 2017年 UQ Interactive. All rights reserved.
//

#import "RootViewController.h"
#import "WebViewController.h"
#import "SecondViewController.h"
#import "OCJSViewController.h"
#import "JSCoreViewController.h"
#import "BluePayViewController.h"
#import "JSOCFViewController.h"
#import "OpenSafariViewController.h"
#import "WKWebViewController.h"
#import "SafariViewController.h"

@interface RootViewController ()
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"WebView示例";
    //导航栏的返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    // 注册某个重用标识 对应的 Cell类型
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseId];
    
//    UINib *nib = [UINib nibWithNibName:@"UITableViewCell" bundle:nil];
//    [self.tableView registerNib:nib forCellReuseIdentifier:reuseId];
//    [self setupRefreshControl];
    self.tableView.tableFooterView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectZero];
    [self addRightBarButtonItem];
}

- (void)addRightBarButtonItem {
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳转到A" style:UIBarButtonItemStylePlain target:self action:@selector(jumpToOtherApp)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

//自带的下拉刷新控件
- (void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.tintColor = [UIColor greenColor];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新了~~"];
    self.clearsSelectionOnViewWillAppear = YES;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.refreshControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
}

- (void)change:(UIRefreshControl*)con{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"开始刷新了~~"];
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray arrayWithObjects:@"网页支付", @"调用微信支付", @"OC和JS交互", @"JavaScriptCore的使用", @"BluePay测试", @"WebViewJavascriptBridge", @"跳转Safari打开链接", @"WKWebView", @"内置Safari浏览器", nil];
    }
    return _dataArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = nil;
    switch (indexPath.row) {
        case 0:
        {
            vc = [[WebViewController alloc] init];
        }
            break;
        case 1:
        {
            vc = [[SecondViewController alloc] init];
        }
            break;
        case 2:
        {
            vc = [[OCJSViewController alloc] init];
        }
            break;
        case 3:
        {
            vc = [[JSCoreViewController alloc] init];
        }
            break;
        case 4:
        {
            vc = [[BluePayViewController alloc] init];
        }
            break;
            case 5:
        {
            vc = [[JSOCFViewController alloc] init];
        }
            break;
        case 6:
        {
            vc = [[OpenSafariViewController alloc] init];
        }
            break;
        case 7:
        {
            vc = [[WKWebViewController alloc] init];
        }
            break;
        case 8:
        {
            vc = [[SafariViewController alloc] init];
        }
            break;
        default:
            break;
    }
    vc.title = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //单独写，没有内容的cell都顶到了左边，有内容的cell则会有间距
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    //单独写无变化
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    //单独写，有内容的cell左移，没有内容的cell则没有变化
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    //单独写无变化
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)jumpToOtherApp {
    // 1.获取应用程序App-B的URL Scheme
    NSURL *appUrl = [NSURL URLWithString:@"ATest://"];
    // 2.判断手机中是否安装了对应程序
    if ([[UIApplication sharedApplication] canOpenURL:appUrl]) {
        // 3. 打开应用程序App
        [[UIApplication sharedApplication] openURL:appUrl];
    } else {
        NSLog(@"没有安装App");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

/*
 导航栏的返回按钮
 
 在页面 A（父级） 中加入如下代码：
 override func viewDidLoad() {
 super.viewDidLoad()
    // 定义所有子页面返回按钮的名称
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
 }
 */
