//
//  ZMNoDataView.m
//  Chapper
//
//  Created by liyongfei on 2017/11/28.
//  Copyright © 2017年 liyongfei. All rights reserved.
//

#import "ZMNoDataView.h"

@implementation ZMNoDataView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = kSmallGray;
    // 添加图片
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.bounds = CGRectMake(0, 0, 200, 200);
    imageV.center = self.center;
    imageV.y -= 100;
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    
    imageV.image = [UIImage imageNamed:@"nodata"];
    [self addSubview:imageV];
    
    // 添加文字
    UILabel *label = [[UILabel alloc] init];
    label.text = @"还没有收藏呦~~";
    label.textColor = ZMColor(109, 109, 109);
    label.textAlignment = NSTextAlignmentCenter;
    label.bounds = CGRectMake(0, 0, 300, 30);
    label.centerX = imageV.centerX;
    label.y = CGRectGetMaxY(imageV.frame) ;
    label.font = [UIFont systemFontOfSize:18];
    
    [self addSubview:label];
    
    
    
}

@end
