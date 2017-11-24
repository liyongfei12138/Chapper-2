//
//  ZMCollectTableViewCell.h
//  Chapper
//
//  Created by liyongfei on 2017/11/22.
//  Copyright © 2017年 liyongfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMCollectTableViewCell : UITableViewCell
/** 图片**/
@property (weak, nonatomic) IBOutlet UIImageView *image;
/** 名称**/
@property (weak, nonatomic) IBOutlet UILabel *name;
/** 券后价格**/
@property (weak, nonatomic) IBOutlet UILabel *afterPrice;
/** 之前价格**/
@property (weak, nonatomic) IBOutlet UILabel *beforPrice;

@end
