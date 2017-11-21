//
//  UIImage+XFFNavOriImage.h
//  彩票
//
//  Created by liyongfei on 2017/9/23.
//  Copyright © 2017年 liyongfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZMNavOriImage)

//把导航栏中的图片转换成未渲染的图片
+ (UIImage *)imageWithRandAsOriImagename:(NSString *)imageName;

@end
