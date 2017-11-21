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

- (void)loadCarouselData;
@end
