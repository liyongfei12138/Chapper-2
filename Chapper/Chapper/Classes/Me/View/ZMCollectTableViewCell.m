//
//  ZMCollectTableViewCell.m
//  Chapper
//
//  Created by liyongfei on 2017/11/22.
//  Copyright © 2017年 liyongfei. All rights reserved.
//

#import "ZMCollectTableViewCell.h"

@implementation ZMCollectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//
-(void)layoutSubviews
{
    [super layoutSubviews];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
           for (UIView *v in control.subviews)
           {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (self.selected) {
                        img.image=[UIImage imageNamed:@"button_xuanze2.png"];
                    }else
                    {
                        img.image=[UIImage imageNamed:@"button_xuanze1.png"];
                    }
                }
            }
        }
    }
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
