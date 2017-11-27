//
//  ZMHeadView.m
//  Chapper
//
//  Created by liyongfei on 2017/11/4.
//  Copyright © 2017年 liyongfei. All rights reserved.
// **********
// 主页头部view
// **********

#import "ZMHeadView.h"
#import <BHInfiniteScrollView/BHInfiniteScrollView.h>
//#import "ZMHotHeadView.h"
#import "ZMProductViewController.h"
#import <AFNetworking.h>
#import <UIButton+WebCache.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>
//#import "ZMClassifyViewController.h"
//#import "ZMFAQVC.h"
#import "ZMDeserveViewController.h"
//#import "ZMWebVC.h"
#import "ZMWebViewController.h"
#import "ZMWebViewController.h"
#import "ZMWebNavigationController.h"
#import "ZMButton.h"
#import "ZMActivityBtnViewController.h"
//#import "ZMNavViewController.h"

@interface ZMHeadView ()<BHInfiniteScrollViewDelegate>
/** 活动按钮数据数组**/
@property (nonatomic, strong) NSMutableArray *acBtnDataArr;

/** 轮播图**/
@property (nonatomic, strong) NSMutableArray *infScroImagArr;

@property (nonatomic, strong) BHInfiniteScrollView *infinitePageView;
@property (nonatomic, strong) ZMDeserveViewController *btnVC;

@property (nonatomic, strong) NSMutableArray *infinArr;

@property (nonatomic, strong) ZMActivityBtnViewController *imageVC;
@end
@implementation ZMHeadView


- (void)layoutSubviews
{
    [super layoutSubviews];
    // 创建轮播图
    UIView *scrollView = [self setUpScrollView];
    //    view.bounds = CGRectMake(0, 60, kDeviceWidth, 200);
    [self addSubview:scrollView];
    
    // 初始化数据
    [self initValue];
    // 初始化数据
//    [self initValue];
//    self.backgroundColor = [UIColor whiteColor];
   
    
    //[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth * 0.42 + kDeviceWidth * 0.25 * 1.11 +
    self.frame = CGRectMake(0, 0, kDeviceWidth, KCarouselHeight + KButtonHeight * 2 + collectedHeight + 60 - 40);
    
    // 适配iPhone X
    if (IS_IPHONE_X) {
        self.frame = CGRectMake(0, 0, kDeviceWidth, KCarouselHeight + KButtonHeight * 2 + collectedHeight + 60 - 40 + 10);
    }
    
    self.backgroundColor = kSmallGray;
    
    UIView *btnBactView = [[UIView alloc] initWithFrame:CGRectMake(0 , kDeviceWidth * 0.42, kDeviceWidth, KButtonHeight * 2 - 40)];
    btnBactView.backgroundColor = kSmallRed;
    btnBactView.backgroundColor = [UIColor whiteColor];
    [self addSubview:btnBactView];
    // 设置Button
    for (int i = 0 ; i < 10; i++)
    {
//        NSLog(@"%zd",);
//        int count = i / 5;
        ZMButton *btn = [ZMButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kDeviceWidth * 0.2 * (i % 5) , KButtonHeight * (i / 5), kDeviceWidth * 0.2 - 1, KButtonHeight);
//        btn.frame = CGRectMake(kDeviceWidth * 0.2 * (i % 5) , KButtonHeight * (i / 5), 0, 0);
        btn.tag = i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor redColor];
        int count = i + 1;
        NSString *imageName = [NSString stringWithFormat:@"button_huodong%d",count];
        UIImage *btnImage = [UIImage imageNamed:imageName];
        [btn setBackgroundImage:btnImage forState:UIControlStateNormal];
        [btn sizeToFit];
        if (i >= 5) {
              btn.frame = CGRectMake(kDeviceWidth * 0.2 * (i % 5) , KButtonHeight * (i / 5) - 25, kDeviceWidth * 0.2 - 1, KButtonHeight);
            // 适配iPhone X
            if (IS_IPHONE_X) {
                btn.frame = CGRectMake(kDeviceWidth * 0.2 * (i % 5) , KButtonHeight * (i / 5) - 25 + 8, kDeviceWidth * 0.2 - 1, KButtonHeight);
            }
        }
        [btn sizeToFit];
        [btnBactView addSubview:btn];

}
    
    // 请求数据
    [self loadCarouselData];

}
// 设置轮播图
- (UIView *)setUpScrollView
{
    
    //要异步下载。。。待做优化
    NSArray *urlsArray = [NSArray array];
//    CGFloat viewHeight =  kDeviceWidth * 0.42;
    
    BHInfiniteScrollView *infinitePageView = [BHInfiniteScrollView
                                               infiniteScrollViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), KCarouselHeight) Delegate:self ImagesArray:urlsArray];

    infinitePageView.dotSpacing = 10;
    infinitePageView.pageControlAlignmentOffset = CGSizeMake(0,10);
    infinitePageView.scrollTimeInterval = 4;
    infinitePageView.autoScrollToNextPage = YES;
    infinitePageView.delegate = self;
    [self addSubview:infinitePageView];
    self.infinitePageView = infinitePageView;
    
    return infinitePageView;
}
// 轮播图点击方法
- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didSelectItemAtIndex:(NSInteger)index
{
    int type = [[[_infinArr objectAtIndex:index] objectForKey:@"carouselType"] intValue];
    
    UIButton *backBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn1.frame = CGRectMake(60, 0, 40, 40);
    [backBtn1 setImage:[UIImage imageNamed:@"icon_xq_fanhui2"] forState:UIControlStateNormal];
    [backBtn1 addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [backBtn1 sizeToFit];
    
    // 类型1
    if (type == 1) {
        ZMProductViewController *goodVC = [[ZMProductViewController alloc] init];
        goodVC.toolID = [[_infinArr objectAtIndex:index] objectForKey:@"carouselValue"];
    }
    else if (type == 2)
    {
        ZMActivityBtnViewController *imageVC = [[ZMActivityBtnViewController alloc] init];
        UINavigationController *navBtn = [[UINavigationController alloc] initWithRootViewController:imageVC];
        [imageVC.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64white"] forBarMetrics:UIBarMetricsDefault];

        [imageVC.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        imageVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn1];

        self.imageVC = imageVC;
        // 添加参数
        NSString *keyWorld = [self.infinArr[index] objectForKey:@"carouselValue"];
        NSString *titleName = [self.infinArr[index] objectForKey:@"carouselName"];
        self.imageVC.navigationItem.title = titleName;
        self.imageVC.keyWorld = keyWorld;
        self.imageVC.poseType = 5;
        [self.owner presentViewController:navBtn animated:YES completion:nil];
    }
    else if (type == 3)
    {
        ZMActivityBtnViewController *imageVC = [[ZMActivityBtnViewController alloc] init];
        UINavigationController *navBtn = [[UINavigationController alloc] initWithRootViewController:imageVC];
        [imageVC.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64white"] forBarMetrics:UIBarMetricsDefault];
        //        [imageVC.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64white"] forBarMetrics:UIBarMetricsDefault];[imageVC.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64white"] forBarMetrics:UIBarMetricsDefault];
        [imageVC.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        imageVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn1];
        
        self.imageVC = imageVC;
        // 添加参数
       NSString *keyWorld = [self.infinArr[index] objectForKey:@"carouselValue"];
        NSString *titleName = [self.infinArr[index] objectForKey:@"carouselName"];
        self.imageVC.navigationItem.title = titleName;
        self.imageVC.keyWorld = keyWorld;
        self.imageVC.poseType = 6;
        [self.owner presentViewController:navBtn animated:YES completion:nil];
    }
    else if (type == 4)
    {
        ZMActivityBtnViewController *imageVC = [[ZMActivityBtnViewController alloc] init];
        UINavigationController *navBtn = [[UINavigationController alloc] initWithRootViewController:imageVC];
        [imageVC.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64white"] forBarMetrics:UIBarMetricsDefault];
        //        [imageVC.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64white"] forBarMetrics:UIBarMetricsDefault];[imageVC.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64white"] forBarMetrics:UIBarMetricsDefault];
        [imageVC.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        imageVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn1];
        
        self.imageVC = imageVC;
        // 添加参数
        NSString *keyWorld = [self.infinArr[index] objectForKey:@"carouselValue"];
        NSString *titleName = [self.infinArr[index] objectForKey:@"carouselName"];
        self.imageVC.navigationItem.title = titleName;
        self.imageVC.keyWorld = keyWorld;
        self.imageVC.poseType = 6;
        [self.owner presentViewController:navBtn animated:YES completion:nil];
    }else if (type == 5)
    {
        ZMWebViewController *webVC = [[ZMWebViewController alloc] init];
        UINavigationController *navWeb = [[UINavigationController alloc] initWithRootViewController:webVC];
        [webVC.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64white"] forBarMetrics:UIBarMetricsDefault];
        //        [imageVC.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64white"] forBarMetrics:UIBarMetricsDefault];[imageVC.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64white"] forBarMetrics:UIBarMetricsDefault];
        [webVC.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        webVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn1];
        
//        self.webVC = webVC;
        // 添加参数
        NSString *webUrl = [self.infinArr[index] objectForKey:@"carouselValue"];
        NSString *titleName = [self.infinArr[index] objectForKey:@"carouselName"];
        webVC.navigationItem.title = titleName;
        webVC.webUrl = webUrl;
//        self.webVC.poseType = 6;
        [self.owner presentViewController:navWeb animated:YES completion:nil];
    }
}

#pragma mark - 点击活动按钮
// 按钮点击
- (void)clickBtn:(ZMButton *)button
{
    // 添加控制
    ZMActivityBtnViewController *VC = [[ZMActivityBtnViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
    [self.owner presentViewController:nav animated:YES completion:nil];
    NSInteger tag = button.tag;
    // 判断 并传递参数
    switch (tag) {
        case 0:
            VC.navigationItem.title = @"女装";
            VC.keyWorld = @"1";
            VC.poseType = 1;
            break;
        case 1:
            VC.navigationItem.title = @"母婴";
            VC.keyWorld = @"2";
            VC.poseType = 1;
            break;
        case 2:
            VC.navigationItem.title = @"化妆品";
            VC.keyWorld = @"3";
            VC.poseType = 1;
            break;
        case 3:
            VC.navigationItem.title = @"居家";
            VC.keyWorld = @"4";
            VC.poseType = 1;
            break;
        case 4:
            VC.navigationItem.title = @"鞋包服饰";
            VC.keyWorld = @"5";
            VC.poseType = 1;
            break;
        case 5:
            VC.navigationItem.title = @"美食";
            VC.keyWorld = @"6";
            VC.poseType = 1;
            break;
        case 6:
            VC.navigationItem.title = @"文体车品";
            VC.keyWorld = @"7";
            VC.poseType = 1;
            break;
        case 7:
            VC.navigationItem.title = @"数码家电";
            VC.keyWorld = @"8";
            VC.poseType = 1;
            break;
        case 8:
            VC.navigationItem.title = @"男装";
            VC.keyWorld = @"9";
            VC.poseType = 1;
            break;
        case 9:
            VC.navigationItem.title = @"内衣";
            VC.keyWorld = @"10";
            VC.poseType = 1;
            break;
        default:
            break;
    }
   
}
// 返回按钮
-(void)backBtn
{
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.owner dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 初始化
// 初始化
- (void)initValue
{
    self.acBtnDataArr = [NSMutableArray array];
    self.infScroImagArr = [NSMutableArray array];
//    self.acBtnArr = [NSMutableArray array];
    self.infinArr = [NSMutableArray array];

}

/******************
 *** 数据解析
 ******************/
#pragma mark - 数据解析
- (void)loadCarouselData
{
    // 初始化数据

     // 请求地址 https://taoboo.kunleen.com/coupon.webapi//api/deploy/carousel
    [ZMHttpTool get:ZMMainUrl params:nil success:^(id responseObj) {

        
        [self.infScroImagArr removeAllObjects];
        // 轮播图数据
        self.infinArr = [[responseObj objectAtIndex:0] objectForKey:@"carousels"];
        
        //添加数组
        for (int i = 0; i < self.infinArr.count; i ++) {
            NSString *infinUrl = [self.infinArr[i] objectForKey:@"carouselImage"];
//            NSURL *url = [NSURL URLWithString:infinUrl];
            [self.infScroImagArr addObject:infinUrl];
        }
        
        [self.infinitePageView setImagesArray:_infScroImagArr];
        
//        [header endRefreshing];

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络繁忙"];
        [SVProgressHUD dismissWithDelay:0.5];
    }];
}

@end
