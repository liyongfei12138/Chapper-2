//
//  ZMMyVC.m
//  Chapper
//
//  Created by liyongfei on 2017/11/2.
//  Copyright © 2017年 liyongfei. All rights reserved.
//
// **********
// 我的
// **********

#import "ZMDetailViewController.h"
#import "ZMDetailTableViewCell.H"
//#import "ZMMyFootView.h"
#import "ZMDetailItem.h"
#import <MJExtension.h>
//#import "ZMFAQVC.h"
//#import "ZMAboutVC2.h"
#import "ZMWebViewController.h"
#import "ZMWebNavigationController.h"
#import <AlibabaAuthSDK/ALBBSDK.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <UIImageView+WebCache.h>
#import "ZMCollectViewController.h"

@interface ZMDetailViewController () <UITableViewDataSource,UITableViewDelegate>

// 懒加载菜单数组
@property (nonatomic, strong) NSArray *itemArr;

//@property (nonatomic, strong) UINavigationController *nav;

@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIImageView *image1;
@property (nonatomic, strong) UILabel *label;

@end

@implementation ZMDetailViewController

- (NSArray *)itemArr
{
    if (_itemArr == nil) {
        _itemArr = [ZMDetailItem mj_objectArrayWithFilename:@"myMenu.plist"];
    }
    return _itemArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
   // 创建tableview
    [self setTableV];
    
}

// 创建tableview
- (void)setTableV
{
    _isLogin = [[ALBBSession sharedInstance] isLogin];
    
    // 创建我的界面tableview
    UITableView *tableV =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight + 64) style:UITableViewStyleGrouped];
    //    tableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    tableV.tableHeaderView.userInteractionEnabled = YES;
    
//    ZMLoginButton *loginBtn = [ZMLoginButton buttonWithType:UIButtonTypeCustom];
//    loginBtn.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight * 0.25);
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight * 0.25);
    [self.tableV setTableHeaderView:self.loginBtn];
    
    [self.loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_wd_beijing"]];
    imageV.frame = self.loginBtn.frame;
    //    imageV.frame = self.headView.frame;
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.layer.zPosition = 0;
    //    imageV.userInteractionEnabled = YES;
    //    [self.headView addSubview:imageV];
    [self.loginBtn addSubview:imageV];
    self.imageV = imageV;
    
    self.image = [[UIImageView alloc] init];
     [self.image setImage:[UIImage imageNamed:@"button_wd_morentx"]];
    self.image.frame = CGRectMake(kDeviceWidth * 0.08, kDeviceHeight * 0.08, kDeviceWidth * 0.25, kDeviceWidth * 0.25);
    self.image.center = self.imageV.center;
    [self.image.layer setCornerRadius:kDeviceWidth * 0.125];
    self.image.layer.masksToBounds = YES;
    [self.loginBtn addSubview: self.image];
    //    self.image = image;
    
    self.image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"button_wd_touxiangwq"]];
    self.image1.bounds = CGRectMake(0, 0, kDeviceWidth * 0.25, kDeviceWidth * 0.25);
    self.image1.center = self.image.center;
    [self.loginBtn addSubview:  self.image1];
    //    self.image1 = image1;
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth * 0.38, self.loginBtn.height * 0.35 + 25, kDeviceWidth * 0.65, kDeviceHeight * 0.1)];
    //    label.text = @"请先登录";
    self.label.font = [UIFont systemFontOfSize:20];
    self.label.textColor = [UIColor whiteColor];
    self.label.text = @"淘宝登录";
//    [self.loginBtn.label sizeToFit];
    [self.label sizeToFit];
//    self.label.centerY =  self.image.centerY;
    self.label.y = CGRectGetMaxY(self.image1.frame) + 5;
    self.label.centerX = self.image.centerX;
    [self.loginBtn addSubview:self.label];
    
    
    
    [tableV setTableHeaderView:self.loginBtn];
//
//    [loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
//    self.loginBtn = loginBtn;
    
    tableV.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    tableV.delegate = self;
    tableV.dataSource = self;
    [self.view addSubview:tableV];
    

    // 声明
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
    titleLabel.text = @"声明:所有活动均与苹果公司无关!";
    [titleLabel setTextColor:kSmallRed];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.y = kDeviceHeight
    [self.view addSubview:titleLabel];
    [tableV setTableFooterView:titleLabel];
    
    self.tableV = tableV;
//    [self.tableV reloadData];
}
// 隐藏nav
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
 
     [self.navigationController.navigationBar setHidden:YES];
}
 // 时判断设置头像部分
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if([[ALBBSession sharedInstance] isLogin])
    {
        [self.image sd_setImageWithURL:[NSURL URLWithString:[[ALBBSession sharedInstance] getUser].avatarUrl]];
        self.label.text = [[ALBBSession sharedInstance] getUser].nick;
        [self.label sizeToFit];
        self.label.centerX = self.image.centerX;
        _isLogin = true;
        [self.tableV reloadData];
    }
    else
    {
         self.label.centerX = self.image.centerX;
    }

}
#pragma mark - 点击登入
- (void)clickLoginBtn
{
//    [self.loginBtn removeAllChild];
    NSLog(@"11");
    if(![[ALBBSession sharedInstance] isLogin])
    {
        [[ALBBSDK sharedInstance] auth:self successCallback:^(ALBBSession *session)
         {
             _isLogin = YES;
             [self.image sd_setImageWithURL:[NSURL URLWithString:[[ALBBSession sharedInstance] getUser].avatarUrl]];
             self.label.text = [[ALBBSession sharedInstance] getUser].nick;
             [self.label sizeToFit];
             self.label.centerX = self.image.centerX;
             [self.tableV reloadData];
             
//             [MobClick profileSignInWithPUID:[session getUser].openId];
//             [MobClick event:@"ChapLogin"];
         }
                       failureCallback:^(ALBBSession *session, NSError *error)
         {
             _isLogin = NO;
//             [self.tableV reloadData];
             self.label.centerX = self.image.centerX;
         }];
    }
    else
    {
        
    }
}
#pragma mark - UITableViewDataSource -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 判断是否登入
    NSInteger tag = _isLogin ? 3 : 2;
    
    return tag;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }if (section == 1) {
        return 4;
    }
    else{
        return 1;
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellID = @"ownTableCell";
    ZMDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellID];
//    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZMDetailTableViewCell" owner:nil options:nil] lastObject];
    }
//    cell.textLabel.text = @"test";
    if(indexPath.section == 0){
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.item = self.itemArr[indexPath.row];
//    ZMLOG(@"%@",cell.item.name);
    }
   else if(indexPath.section == 1) {
        cell.item = self.itemArr[indexPath.row + 1];
    }
    else
    {
        cell = [[ZMDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myCellID];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
        [label setText:@"退出登录"];
        [label setFont:[UIFont systemFontOfSize:15]];
        [label sizeToFit];
        label.centerX = kDeviceWidth * 0.5;
        label.centerY = 25;
        
        [cell.contentView addSubview:label];
        
    }
    return cell;
}

// tableView点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    // 取消选中状态
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        // 订单查询
        ZMWebViewController *findVC = [[ZMWebViewController alloc] initWithWebView];
        ZMWebNavigationController *findNav = [[ZMWebNavigationController alloc] initWithRootViewController:findVC];
        //查询订单
        id<AlibcTradePage> page = [AlibcTradePageFactory myOrdersPage:0 isAllOrder:YES];
        //淘客信息
        AlibcTradeTaokeParams *taoKeParams=[[AlibcTradeTaokeParams alloc] init];
        taoKeParams.pid= nil;
        //打开方式
        AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
        showParam.openType = AlibcOpenTypeAuto;
        
        findVC.title = @"订单查询";
        NSInteger ret = [[AlibcTradeSDK sharedInstance].tradeService show: findVC webView: findVC.webView page:page showParams:showParam taoKeParams: taoKeParams trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result){
        }
       tradeProcessFailedCallback:^(NSError * _Nullable error)
       {
                             
        }];
        if(ret == 1)
        {
            [self.navigationController presentViewController:findNav animated:YES completion:^{
            }];
        }
    }

    else if (indexPath.section == 1) {
    // 收藏
    ZMCollectViewController *collectVC = [[ZMCollectViewController alloc] init];
    ZMWebNavigationController *collectNav = [[ZMWebNavigationController alloc] initWithRootViewController:collectVC];
    // 相关问题
    ZMWebViewController *faqVC = [[ZMWebViewController alloc] initWithWebView];
        faqVC.webUrl = FAQUrl;
    ZMWebNavigationController *faqNav = [[ZMWebNavigationController alloc] initWithRootViewController:faqVC];
    // 关于
    ZMWebViewController *aboutVC = [[ZMWebViewController alloc] initWithWebView];
        aboutVC.webUrl = AboutUrl;
    ZMWebNavigationController *aboutNav = [[ZMWebNavigationController alloc] initWithRootViewController:aboutVC];

    switch (indexPath.row) {
        case 0:
            collectVC.navigationItem.title = @"我的收藏";
            [self presentViewController:collectNav animated:YES completion:nil];
            break;
        case 1:

            faqVC.navigationItem.title = @"常见问题";
            [self presentViewController:faqNav animated:YES completion:nil];
            
            break;
        case 2:
            [self clickClean];
            break;
            
        case 3:
//            ZMLOG(@"你点击了第%zd的cell",indexPath.row);
            aboutVC.navigationItem.title = @"关于";
            [self presentViewController:aboutNav animated:YES completion:nil];
            break;

       }
    }
    else
    {
        //退出
        [[ALBBSDK sharedInstance] logout];
        
        _isLogin = NO;
        
        [self.image setImage:[UIImage imageNamed:@"button_wd_morentx"]];
         self.label.text = @"请先登录";
        [self.label sizeToFit];
        self.label.centerX = self.image.centerX;
//        [self.view setNeedsDisplay];
        [self.tableV reloadData];
        
    
    }
}
// 让cell选中无阴影

- (void)clickClean
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除缓存" message:@"确定清除缓存?" preferredStyle:UIAlertControllerStyleAlert];
    // 点击确定
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        // 清除缓存
        NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
        NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
//        NSLog ( @"cachpath = %@" , cachPath);
        for ( NSString * p in files) {
            NSError * error = nil ;
            NSString * path = [cachPath stringByAppendingPathComponent :p];
            if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
                [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
            }
        }
        [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject :nil waitUntilDone : YES ];
        [self clearCachSuccess];
    }];
    // 点击返回
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    // 添加action
    [alert addAction:action];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)clearCachSuccess
{
//    NSLog ( @" 清理成功 " );
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"缓存清理完毕" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
// 返回按钮
-(void)backBtn
{
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 获取tableview偏移量
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat yOffset = scrollView.contentOffset.y; // 获取偏移量
    CGFloat viewH =  kDeviceHeight * 0.25;
    // 判断 ->向下是负值
    if (yOffset < 0) {
        self.imageV.frame = CGRectMake(0, yOffset, kDeviceWidth, viewH - yOffset);
    }
}
@end
