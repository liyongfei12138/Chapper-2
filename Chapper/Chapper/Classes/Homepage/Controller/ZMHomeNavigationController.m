//
//  ZMHomepageNavVC.m
//  Chapper
//
//  Created by liyongfei on 2017/11/3.
//  Copyright © 2017年 liyongfei. All rights reserved.
//
// **********
// 主页NAV 
// **********
#import "ZMHomeNavigationController.h"
//#import <WRNavigationBar.h>
@interface ZMHomeNavigationController ()

@end

@implementation ZMHomeNavigationController

+ (void)initialize
{
    if (self == [ZMHomeNavigationController class]) {
        //创建navBar
        UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[ZMHomeNavigationController class]]];
        
    }
}

@end
