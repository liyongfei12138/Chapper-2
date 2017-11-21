//
//  ZMLoginWebVC.h
//  Chapper
//
//  Created by liyongfei on 2017/11/15.
//  Copyright © 2017年 liyongfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMWebViewController : UIViewController

- (instancetype)initWithWebView;

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSString* webUrl;


@end
