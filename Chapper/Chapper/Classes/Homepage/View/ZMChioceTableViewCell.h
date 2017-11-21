//
//  ZMChioceTableViewCell.h
//  Chapper
//
//  Created by liyongfei on 2017/11/17.
//  Copyright © 2017年 liyongfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMChioceTableViewCell : UITableViewCell

/** 图片**/
@property (weak, nonatomic) IBOutlet UIImageView *photo;
/** 购买人数**/
@property (weak, nonatomic) IBOutlet UILabel *personLabel;
/** 券后价钱**/
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
/** 之前价钱**/
@property (weak, nonatomic) IBOutlet UILabel *beforMoneyLabel;
///** 优惠券**/
@property (weak, nonatomic) IBOutlet UILabel *couponLable;
@property (weak, nonatomic) IBOutlet UILabel *name;
@end
