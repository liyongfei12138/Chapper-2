//
//  ZMGoodsHeadView.h
//  Chapper
//
//  Created by liyongfei on 2017/11/8.
//  Copyright © 2017年 liyongfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BHInfiniteScrollView.h>
#define kCICLYHEIGHT (kDeviceWidth)


@interface ZMGoodsHeadView : UIView

@property (nonatomic, strong) NSDictionary *goods;

@property (nonatomic, strong) BHInfiniteScrollView *infinitePageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *beforLabel;
@property (nonatomic, strong) UILabel *afterLabel;
@property (nonatomic, strong) UILabel *personLabel;

// 分类商品数组
@property (nonatomic,strong) NSMutableArray *lotterArr;


// 今日商品数组
@property (nonatomic,strong) NSMutableArray *todayArr;

//@property (nonatomic,strong) UIViewController *own;

@end
