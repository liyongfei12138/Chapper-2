//
//  ZMLoginWebVC.m
//  Chapper
//
//  Created by liyongfei on 2017/11/15.
//  Copyright © 2017年 liyongfei. All rights reserved.
// **********
// 自定义webview
// **********

#import "ZMWebViewController.h"

@interface ZMWebViewController () <UIWebViewDelegate>

@end

@implementation ZMWebViewController

- (instancetype)initWithWebView
{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - 64)];
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    [_webView setDelegate:self];
    [_webView setBackgroundColor:kSmallGray];
    [_webView setOpaque:NO];//opaque是不透明的意思
    [self.view addSubview:_webView];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSURL *url = [NSURL URLWithString:_webUrl];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}






- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;

    if ([url.scheme  isEqualToString:@"tbopen"])
    {
        NSLog(@"%@",url.scheme);
        return NO;
    }

    return YES;
}
@end
