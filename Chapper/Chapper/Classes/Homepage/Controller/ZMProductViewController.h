//
//  ZMGoodsVC.h
//  Chapper
//
//  Created by liyongfei on 2017/11/8.
//  Copyright © 2017年 liyongfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCICLYHEIGHT (kDeviceWidth)
@interface ZMProductViewController : UIViewController

// 主页商品ID
@property (nonatomic, strong) NSString *toolID;

// 分类商品数组
@property (nonatomic,strong) NSMutableArray *lotterArr;

// 今日商品数组
@property (nonatomic,strong) NSMutableArray *todayArr;

@end
