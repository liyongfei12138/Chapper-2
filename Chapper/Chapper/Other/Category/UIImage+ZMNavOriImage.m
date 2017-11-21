//
//  UIImage+XFFNavOriImage.m
//  彩票
//
//  Created by liyongfei on 2017/9/23.
//  Copyright © 2017年 liyongfei. All rights reserved.
//

#import "UIImage+ZMNavOriImage.h"

@implementation UIImage (ZMNavOriImage)

+ (UIImage *)imageWithRandAsOriImagename:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
