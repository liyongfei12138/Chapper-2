//
//  ZMCollectItem.h
//  Chapper
//
//  Created by liyongfei on 2017/11/23.
//  Copyright © 2017年 liyongfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMCollectItem : NSObject

/** 图片 **/
@property (nonatomic, strong) NSString *itemImage;

/** 名称 **/
@property (nonatomic, strong) NSString *itemName;

/** 价格 **/
@property (nonatomic, strong) NSString *finalPrice;

/** 之前价格 **/
@property (nonatomic, strong) NSString *price;

/** 商品ID **/
@property (nonatomic, strong) NSString *itemId;

/** 领卷中心 **/
@property (nonatomic, strong) NSString *promotionURL;

@end
