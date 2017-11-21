//
//  ZMLoginNavVC.m
//  Chapper
//
//  Created by liyongfei on 2017/11/15.
//  Copyright © 2017年 liyongfei. All rights reserved.
// **********
// 所有加载网址的都用这个nav
// **********

#import "ZMWebNavigationController.h"

@interface ZMWebNavigationController ()

//@property ()

@end

@implementation ZMWebNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 返回按钮
    UIButton *backBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn1.frame = CGRectMake(20, 30, 40, 40);
    backBtn1.centerY = self.navigationBar.centerY + 20;
    [backBtn1 setImage:[UIImage imageNamed:@"icon_xq_fanhui2.png"] forState:UIControlStateNormal];
    [backBtn1 sizeToFit];
    backBtn1.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [self.view addSubview:backBtn1];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn1];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    [backBtn1 addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.title = self.title;
}

-(void)backBtn
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
