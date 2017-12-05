//
//  AppDelegate.m
//  Chapper
//
//  Created by liyongfei on 2017/11/2.
//  Copyright © 2017年 liyongfei. All rights reserved.
//

#import "AppDelegate.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
//#import "ZMRootVCTools.h"
#import "ZMMainTabBarController.h"
#import "ZMADViewController.h"
#import <UMMobClick/MobClick.h>
#import <JPUSHService.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate ()<JPUSHRegisterDelegate>

//@property (nonatomic, assign) CGFloat sw;
@property (nonatomic, strong )UIViewController *vc;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
//    UIViewController *vc = [[UIViewController alloc] init];
    // 获取开关
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        //    [mgr setSecurityPolicy:securityPolicy];
        
        mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSDictionary *dict = @{
                               @"control":@"50001"
                               };
        [mgr POST:ZMSwitchUrl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            Byte *testByte = (Byte *)[responseObject bytes];
            NSString *str = [NSString stringWithFormat:@"%s",testByte];
            CGFloat sw = [str floatValue];
//            self.sw = sw;
            // 判断是否隐藏 0不隐藏 1 隐藏
            if (sw == 0) {
                self.vc = [[ZMADViewController alloc] init];
            }else{
                self.vc = [[ZMMainTabBarController alloc] init];
            }
            self.window.rootViewController = self.vc;
            [self.window makeKeyAndVisible];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 当请求失败直接进如主页
            self.vc = [[ZMMainTabBarController alloc] init];
            self.window.rootViewController = self.vc;
            [self.window makeKeyAndVisible];
        }];

    //设置原始跟控制器
    
    
    // 百川平台基础SDK初始化，加载并初始化各个业务能力插件
    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
        
        NSLog(@"----------V---------------");
        
    } failure:^(NSError *error) {
        NSLog(@"Init failed: %@", error.description);
    }];
    // 开发阶段打开日志开关，方便排查错误信息
    //默认调试模式打开日志,release关闭,可以不调用下面的函数
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:YES];
    
    // 配置全局的淘客参数
    //如果没有阿里妈妈的淘客账号,setTaokeParams函数需要调用
    AlibcTradeTaokeParams *taokeParams = [[AlibcTradeTaokeParams alloc] init];
    taokeParams.pid = @"mm_124530257_31350353_115428071"; //mm_XXXXX为你自己申请的阿里妈妈淘客pid
    
    [[AlibcTradeSDK sharedInstance] setTaokeParams:taokeParams];
    
    //设置全局的app标识，在电商模块里等同于isv_code
    //没有申请过isv_code的接入方,默认不需要调用该函数
    [[AlibcTradeSDK sharedInstance] setISVCode:@"your_isv_code"];
    
    // 设置全局配置，是否强制使用h5
    [[AlibcTradeSDK sharedInstance] setIsForceH5:NO];
    
    // 极光推送
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
//    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"9fd00ca066cc2fec78a11ed2"
                          channel:@"App Store"
                 apsForProduction:1
            advertisingIdentifier:nil];
    
    
    // 友盟
//    5a162916f43e4861fd00012e
    UMConfigInstance.appKey = @"5965893fb27b0a5a560016d0";
    UMConfigInstance.channelId = @"App Store";
    
    [MobClick startWithConfigure:UMConfigInstance];
    
    // 设置启动图片的停留时间
    // 启动图片延时: 1秒
    [NSThread sleepForTimeInterval:1];
    

    
    return YES;
}



- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    // 新接口写法
    if (![[AlibcTradeSDK sharedInstance] application:application
                                             openURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation]) {
        // 处理其他app跳转到自己的app
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    
    // 新接口写法
    if (![[AlibcTradeSDK sharedInstance] application:application
                                             openURL:url
                                             options:options]) {
        //处理其他app跳转到自己的app，如果百川处理过会返回YES
    }
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
