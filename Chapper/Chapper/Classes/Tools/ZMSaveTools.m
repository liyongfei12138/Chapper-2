//
//  ZMSaveTools.m
//  Chapper
//
//  Created by liyongfei on 2017/11/2.
//  Copyright © 2017年 liyongfei. All rights reserved.
// **********
// 保存工具
// **********

#import "ZMSaveTools.h"

@implementation ZMSaveTools
+ (id)objectForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}

+ (void)setObject:(id)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
