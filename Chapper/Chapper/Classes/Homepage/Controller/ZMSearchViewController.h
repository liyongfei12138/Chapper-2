//
//  ZMLotteryVCViewController.h
//  Chapper
//
//  Created by liyongfei on 2017/11/7.
//  Copyright © 2017年 liyongfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMSearchViewController : UIViewController
// 0-所有;1-根据商品分类编号;2-根据关键字;3-根据频道id;4-根据itemid;5-根据金额;6-销量;
@property (nonatomic,strong) NSString *keyWorld;
// 查询的类型具体查询条件
@property (nonatomic,assign) NSInteger poseType;

@end
