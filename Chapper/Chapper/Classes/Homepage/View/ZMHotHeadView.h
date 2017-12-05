//
//  ZMHotHeadView.h
//  Chapper
//
//  Created by liyongfei on 2017/11/4.
//  Copyright © 2017年 liyongfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMHotHeadView : UIView

@property (nonatomic,strong) UIViewController *hotOwner;
// 数据模型数组
@property (nonatomic, strong) NSMutableArray *hotArr;
- (void)loadCarouselData;
@end
