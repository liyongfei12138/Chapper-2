//
//  ZMTreatureCollectionViewCell.h
//  Chapper
//
//  Created by liyongfei on 2017/11/7.
//  Copyright © 2017年 liyongfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMTreatureCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (weak, nonatomic) IBOutlet UILabel *inforLabel;

@property (weak, nonatomic) IBOutlet UIImageView *footImage;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@end
