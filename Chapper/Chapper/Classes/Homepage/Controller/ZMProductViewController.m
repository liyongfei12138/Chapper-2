//
//  ZMGoodsVC.m
//  Chapper
//
//  Created by liyongfei on 2017/11/8.
//  Copyright © 2017年 liyongfei. All rights reserved.
// **********
// 商品
// **********
#import "ZMProductViewController.h"
//#import <BHInfiniteScrollView.h>
#import "ZMGoodsHeadView.h"

#import <SVProgressHUD.h>
#import "ZMWebNavigationController.h"
#import "ZMWebViewController.h"
#import <AlibabaAuthSDK/ALBBSDK.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <SVProgressHUD.h>
#import "ZMCollectViewController.h"
@interface ZMProductViewController () <UITableViewDelegate, UITableViewDataSource >
// 商品字典
@property (nonatomic, strong) NSDictionary *goodDict;

@property (nonatomic, strong) NSString *url;

@end

@implementation ZMProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化
    [self initValue];
    // 解析数据
    [self loadCarouselData];
    // 设置背景
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpTableView];
    
    [self setCollectButton];
    [self setBuyButton];
//    [self createTableHeaderView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:@"getUrl" object:nil];
}
- (void)getNotification:(NSNotification *)text
{
    self.url = text.userInfo[@"urlDict"];
}

//// 隐藏nav 以及设置返回按钮
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 隐藏下划线和设置nav透明
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
     // 创建返回按钮
    UIButton *backBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn1.frame = CGRectMake(60, 0, 40, 40);
    [backBtn1 setImage:[UIImage imageNamed:@"icon_xq_fanhui"] forState:UIControlStateNormal];
    [backBtn1 addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [backBtn1 sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn1];
    
     // 创建添加收藏按钮
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(60, 0, 40, 40);
    [collectBtn setImage:[UIImage imageNamed:@"button_xqwdsc"] forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(collectBtn) forControlEvents:UIControlEventTouchUpInside];
    [collectBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:collectBtn];
}
// 初始化
- (void)initValue
{
    self.goodDict = [NSDictionary dictionary];
}

// nav返回事件
-(void)backBtn
{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
// nav收藏事件
- (void)collectBtn
{
    // 收藏
    ZMCollectViewController *collectVC = [[ZMCollectViewController alloc] init];
    ZMWebNavigationController *collectNav = [[ZMWebNavigationController alloc] initWithRootViewController:collectVC];
    collectVC.navigationItem.title = @"我的收藏";
    [self presentViewController:collectNav animated:YES completion:nil];
}

// 创建收藏按钮
- (void)setCollectButton
{
    CGFloat btnH = 64;
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectBtn setBackgroundColor:[UIColor whiteColor]];
    [collectBtn setTitle:@"添加收藏" forState:UIControlStateNormal];
    [collectBtn setTitleColor:kSmallRed forState:UIControlStateNormal];
    collectBtn.frame =CGRectMake(0, kDeviceHeight - 64, kDeviceWidth / 2, btnH);
    [collectBtn addTarget:self action:@selector(didClickCollectBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:collectBtn];
}
#pragma mark - 收藏按钮
- (void)didClickCollectBtn
{
    [SVProgressHUD showSuccessWithStatus:@"添加成功了哦~"];
    [SVProgressHUD dismissWithDelay:1];
    ZMLOG(@"你点击了收藏按钮呦😯");
}
// 创建购买按钮
- (void)setBuyButton
{
    CGFloat btnH = 64;
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setBackgroundColor:kSmallRed];
    [buyBtn setTitle:@"领券购买" forState:UIControlStateNormal];
    buyBtn.frame =CGRectMake(kDeviceWidth / 2, kDeviceHeight - 64, kDeviceWidth / 2, btnH);
    [buyBtn addTarget:self action:@selector(didClickBuyBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyBtn];
}
#pragma mark - 购买按钮
// 购买按钮
- (void)didClickBuyBtn
{
     // 如果用户没有登入
     if(![[ALBBSession sharedInstance] isLogin])
     {
         // 成功回调
         [[ALBBSDK sharedInstance] auth:self successCallback:^(ALBBSession *session)
          {
              ZMWebViewController *getVC = [[ZMWebViewController alloc] initWithWebView];
              getVC.title = @"领券中心";
              getVC.webUrl = self.url;
              UINavigationController *getNav = [[UINavigationController alloc] initWithRootViewController:getVC];
              
              [self presentViewController:getNav animated:YES completion:nil];
          }
          // 失败回调
        failureCallback:^(ALBBSession *session, NSError *error)
          {
              
              
          }];
      }
     else
     {
         ZMWebViewController *getVC = [[ZMWebViewController alloc] initWithWebView];
         getVC.title = @"领券中心";
         getVC.webUrl = self.url;
         ZMWebNavigationController *getNav = [[ZMWebNavigationController alloc] initWithRootViewController:getVC];
         
         [self presentViewController:getNav animated:YES completion:nil];
          
 }
 
}

// 创建tableview
- (void)setUpTableView
{
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];
    [tableV setBackgroundColor:kSmallGray];
    ZMGoodsHeadView *headView = [[ZMGoodsHeadView alloc] initWithFrame:CGRectMake(0, -64, kDeviceWidth, kDeviceHeight)];
//    headView.own = self;
    headView.lotterArr = _lotterArr;
    headView.todayArr = _todayArr;
//    [self createTableHeaderView];
//    UIView *headView = [self createTableHeaderView];
    headView.frame = CGRectMake(0, -64, kDeviceWidth, kDeviceHeight);
    
    headView.backgroundColor = [UIColor whiteColor];
    [tableV setTableHeaderView:headView];
    //    self.navigationController.title = @"商品详情";
    
    [self.view addSubview:tableV];
    [tableV setDelegate:self];
    [tableV setDataSource:self];
    
    

}
#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"goodsID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.01;
}

/******************
 *** 数据解析
 ******************/
#pragma mark - 数据解析
- (void)loadCarouselData
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInt:4] forKey:@"query_type"];
    [parameters setValue:_toolID forKey:@"query_data"];
    
    [ZMHttpTool post:ZMItemUrl params:parameters success:^(id responseObj) {
//        NSLog(@"%@",responseObj);
        self.goodDict = [responseObj valueForKey:@"item"];
//        self.goodArr =
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.goodDict,@"goodDict",nil];
        
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"goods" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"请检查网络"];
//        [SVProgressHUD dismissWithDelay:1];
    }];
}


@end
