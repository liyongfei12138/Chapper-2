//
//  ZMGoodsHeadView.m
//  Chapper
//
//  Created by liyongfei on 2017/11/8.
//  Copyright © 2017年 liyongfei. All rights reserved.
// **********
// 商品优选
// **********
#import "ZMGoodsHeadView.h"

#import <UIImageView+WebCache.h>
#import "ZMClassifyItem.h"
#import "ZMTodayItem.h"
#import "ZMProductViewController.h"
@interface ZMGoodsHeadView() <BHInfiniteScrollViewDelegate>

// 获取领卷中心URL
@property (nonatomic, strong) NSString *getUrl;

@end
@implementation ZMGoodsHeadView



-(void)layoutSubviews
{
    [super layoutSubviews];
//    self.goodVC = [[ZMGoodsVC alloc]init];
    
  
    
    
    // 接受通知
    self.goods = [NSDictionary dictionary];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"goods" object:nil];
    
    CGFloat height =  kDeviceWidth * 1.5 + 130;
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, height)];
//    [headerView setBackgroundColor:[UIColor whiteColor]];
    self.frame = CGRectMake(0, 0, kDeviceWidth, height);
    
    //    NSArray* arr = [[NSArray alloc]initWithObjects:[_dataDic objectForKey:@"itemImage"], nil];
    NSArray *arr = [[NSArray alloc]initWithObjects:[UIImage imageNamed:@"loading"],nil];
    _infinitePageView = [BHInfiniteScrollView infiniteScrollViewWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth) Delegate:self ImagesArray:arr];
    //    _infinitePageView.isToolInfor = YES;
    //    _infinitePageView.pageControl.dotSize = 10;
    //    _infinitePageView.pageControlAlignmentOffset = CGSizeMake(0, 10);
    _infinitePageView.autoScrollToNextPage = NO;
    _infinitePageView.scrollTimeInterval = 0;
    _infinitePageView.delegate = self;
    
    
    [self addSubview:_infinitePageView];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.width = kDeviceWidth - 20;
    self.nameLabel.centerX = kDeviceWidth * 0.5;
    self.nameLabel.height = 50;
    self.nameLabel.y = kCICLYHEIGHT + 3;
    self.nameLabel.numberOfLines = 2;
    //    nameLabel.text = [_dataDic objectForKey:@"itemName"];
//    self.nameLabel.text = @"这是测试的lable";
    [self addSubview:self.nameLabel];
//    self.nameLabel = nameLabel;
    
    UILabel *beforLabel = [[UILabel alloc]init];
    //    [beforLabel setText:[NSString stringWithFormat:@"¥%@",[_dataDic objectForKey:@"price"]]];
    [beforLabel setText:[NSString stringWithFormat:@"¥%@",@"10000"]];
    [beforLabel setFont:[UIFont systemFontOfSize:20]];
    [beforLabel sizeToFit];
    beforLabel.x = 10;
    beforLabel.centerY = kCICLYHEIGHT + 70;
    [self addSubview:beforLabel];
    self.beforLabel = beforLabel;
    
    UILabel *afterInfor = [[UILabel alloc]init];
    [afterInfor setText:@"实际券后价"];
    [afterInfor setFont:[UIFont systemFontOfSize:16]];
    [afterInfor sizeToFit];
    [afterInfor setTextColor:[UIColor lightGrayColor]];
    afterInfor.x = beforLabel.x + beforLabel.width + 15;
    afterInfor.centerY = kCICLYHEIGHT + 70;
    [self addSubview:afterInfor];
    
    
    UILabel *afterLabel = [[UILabel alloc]init];
    //    [afterLabel setText:[NSString stringWithFormat:@"¥%@",[_dataDic objectForKey:@"finalPrice"]]];
    [afterLabel setText:[NSString stringWithFormat:@"¥%@",@"10000"]];
    [afterLabel setFont:[UIFont systemFontOfSize:20]];
    [afterLabel sizeToFit];
    [afterLabel setTextColor:kSmallRed];
    afterLabel.x = afterInfor.x + afterInfor.width + 5;
    afterLabel.centerY = kCICLYHEIGHT + 70;
    [self addSubview:afterLabel];
    self.afterLabel = afterLabel;
    
    UILabel *personLabel = [[UILabel alloc]init];
    //    [personLabel setText:[NSString stringWithFormat:@"月销%d件",[[_dataDic objectForKey:@"sellAmount"] intValue]]];
    [personLabel setText:[NSString stringWithFormat:@"月销%@件",@"10000"]];
    [personLabel setFont:[UIFont systemFontOfSize:16]];
    [personLabel sizeToFit];
    [personLabel setTextColor:[UIColor lightGrayColor]];
    personLabel.x = kDeviceWidth - 10 - personLabel.width;
    personLabel.centerY = kCICLYHEIGHT + 70;
    [self addSubview:personLabel];
    self.personLabel = personLabel;
    
    UIView *colorView = [[UIView alloc]initWithFrame:CGRectMake(0, kDeviceWidth + 90, kDeviceWidth, kDeviceWidth * 0.5  + 5)];
    [colorView setBackgroundColor:kSmallGray];
    [self addSubview:colorView];
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xq_goumaixuzhi"]];
    image.width = kDeviceWidth;
    image.height = kDeviceWidth * 0.5;
    image.x =  0 ;
    image.y = 5;
    [colorView addSubview:image];
    // 设置分类商品页面
    ZMClassifyItem *item = (ZMClassifyItem *)self.lotterArr;
    if (item) {
        self.nameLabel.text = item.itemName;
        self.afterLabel.text = [NSString stringWithFormat:@"¥%@", item.finalPrice];
        self.beforLabel.text = [NSString stringWithFormat:@"¥%@", item.price];
        self.personLabel.text = [NSString stringWithFormat:@"月销%@件",item.sellAmount];
        NSMutableArray *imageArr = [NSMutableArray arrayWithObject:item.itemImage];
        
//        self.goodVC.webUrl
        [_infinitePageView setImagesArray:imageArr];
        // 移除元素
//        [self.lotterArr removeAllObjects];
        
        // 获取领卷中心URL
        self.getUrl = item.promotionURL;
        NSDictionary *dictGet =[[NSDictionary alloc] initWithObjectsAndKeys:self.getUrl,@"urlDict",nil];
        //创建通知
        NSNotification *Getnotification =[NSNotification notificationWithName:@"getUrl" object:nil userInfo:dictGet];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:Getnotification];
    }
    // 设置今日商品页面
    ZMTodayItem *todayItem = (ZMTodayItem *)self.todayArr;
    if (todayItem) {
        self.nameLabel.text = todayItem.itemName;
        self.afterLabel.text = [NSString stringWithFormat:@"¥%@", todayItem.finalPrice];
        self.beforLabel.text = [NSString stringWithFormat:@"¥%@", todayItem.price];
        self.personLabel.text = [NSString stringWithFormat:@"月销%@件",todayItem.sellAmount];
        NSMutableArray *imageArr = [NSMutableArray arrayWithObject:todayItem.itemImage];
        [_infinitePageView setImagesArray:imageArr];
        // 移除元素
        //        [self.lotterArr removeAllObjects];
        // 获取领卷中心URL
        self.getUrl = todayItem.promotionURL;
        NSDictionary *dictGet =[[NSDictionary alloc] initWithObjectsAndKeys:self.getUrl,@"urlDict",nil];
        //创建通知
        NSNotification *Getnotification =[NSNotification notificationWithName:@"getUrl" object:nil userInfo:dictGet];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:Getnotification];
    }
}


// 接受通知
- (void)notification:(NSNotification *)text{
    
    self.goods = text.userInfo[@"goodDict"];
    self.nameLabel.text = [[self.goods valueForKey:@"itemName"] objectAtIndex:0];
    self.beforLabel.text = [NSString stringWithFormat:@"¥%@",[[self.goods valueForKey:@"price"] objectAtIndex:0]];
    self.afterLabel.text = [NSString stringWithFormat:@"¥%@",[[self.goods valueForKey:@"finalPrice"] objectAtIndex:0]];
    self.personLabel.text = [NSString stringWithFormat:@"月销%@件",[[self.goods valueForKey:@"sellAmount"] objectAtIndex:0]];
     NSArray *imArr = [self.goods valueForKey:@"itemImage"];
    [_infinitePageView setImagesArray:imArr];
    
    // 获取领卷中心URL
   self.getUrl = [[self.goods valueForKey:@"promotionURL"] objectAtIndex:0];
//    NSMutableArray *array = [NSMutableArray arrayWithObject:imArr];
//    [self.infinitePageView setImagesArray:array];
    NSDictionary *dictGet =[[NSDictionary alloc] initWithObjectsAndKeys:self.getUrl,@"urlDict",nil];
    //创建通知
    NSNotification *Getnotification =[NSNotification notificationWithName:@"getUrl" object:nil userInfo:dictGet];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:Getnotification];
}



@end
