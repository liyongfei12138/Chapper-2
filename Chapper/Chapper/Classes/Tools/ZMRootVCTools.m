//
//  ZMRootVCTools.m
//  Chapper
//
//  Created by liyongfei on 2017/11/2.
//  Copyright © 2017年 liyongfei. All rights reserved.
// **********
// 进入主页选择根控制器
// **********

#import "ZMRootVCTools.h"
#import "ZMSaveTools.h"
#import "ZMMainTabBarController.h"
#define ZMVersion @"version"


@implementation ZMRootVCTools

//选择跟控制器
+ (UIViewController *)chooseWindowRootVC
{
    //判断是否进入引导页
    /*
    //获取版本号
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    //上次打开版本号
    NSString *lastVersion = [ZMSaveTools objectForKey:ZMVersion];
    
    UIViewController *vc = [[UIViewController alloc] init];
    
    //判断是否进去引导页
    if (version != lastVersion) {
        //进去引导页
    }
    else{
        
    }
    */

    ZMMainTabBarController *vc = [[ZMMainTabBarController alloc] init];
//    vc.view.backgroundColor = [UIColor redColor];
    return vc;
}

@end
