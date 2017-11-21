//
//  ZMSaveTools.h
//  Chapper
//
//  Created by liyongfei on 2017/11/2.
//  Copyright © 2017年 liyongfei. All rights reserved.

// 保存工具类

#import <Foundation/Foundation.h>

@interface ZMSaveTools : NSObject

// 存放法
+ (nullable id)objectForKey:(NSString *_Nullable)defaultName;

//取方法
+ (void)setObject:(nullable id)value forKey:(NSString *_Nullable)defaultName;

@end
