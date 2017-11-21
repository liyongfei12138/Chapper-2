//
//  ZMHotCollectionViewCell.h
//  Chapper
//
//  Created by liyongfei on 2017/11/6.
//  Copyright © 2017年 liyongfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMHotCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *inforLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *beforMoneyLabel;
@end

