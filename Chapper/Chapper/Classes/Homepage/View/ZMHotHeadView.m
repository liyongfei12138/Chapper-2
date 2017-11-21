//
//  ZMHotHeadView.m
//  Chapper
//
//  Created by liyongfei on 2017/11/4.
//  Copyright © 2017年 liyongfei. All rights reserved.
//
// **********
// 主页 热门商品view
// **********
#import "ZMHotHeadView.h"
#import "ZMHotCollectionViewCell.h"
#import "ZMProductViewController.h"
//#import "ZMHeadView.m"
#import "ZMHomeViewController.h"
#import "UIImageView+WebCache.h"
@interface ZMHotHeadView() <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

// 数据模型数组
@property (nonatomic, strong) NSMutableArray *hotArr;

@end
@implementation ZMHotHeadView

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self initValue];
//    self.backgroundColor = kSmallGray;
    [self loadCarouselData];
    
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0.5;
    layout.minimumInteritemSpacing = 0.5;
    [layout setSectionInset:UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5)];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, kDeviceWidth, collectedHeight) collectionViewLayout:layout];
//    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, kDeviceWidth, collectedHeight) collectionViewLayout:layout];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    //设置代理
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    collectionView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:[self setUpHeadView]];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
//    [self.collectionView reloadData];
}

// 创建热门商品头view
- (UIView *) setUpHeadView
{
    UIImageView *hotImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_rementj.png"]];
    [hotImage sizeToFit];
    hotImage.x = 10;
    hotImage.y = 10;
//    [hotBg addSubview:hotImage];
    return hotImage;

}
#pragma mark collectdelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((float)(kDeviceWidth) * 0.4 - 1,((float)(kDeviceWidth) * 0.4 - 0.5) / 4.0 * 5.0);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSLog(@"*****************%zd",self.hotArr.count);
    return self.hotArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [self loadCarouselData];
    static NSString *Indentifi = @"HotCell";
    
    UINib *nib = [UINib nibWithNibName:@"ZMHotCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:Indentifi];
    
    ZMHotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Indentifi forIndexPath:indexPath];
    if (_hotArr.count > 0 && _hotArr[indexPath.row]) {
        NSString *url = [self.hotArr[indexPath.row] objectForKey:@"carouselImage"];
        [cell.photo sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
        NSString *totleStr = [_hotArr[indexPath.row] objectForKey:@"carouselName"];
        // 分割字符
        NSArray *array = [totleStr componentsSeparatedByString:@",,,"];
        // 设置内容
        if(array.count >= 2)
        {
            cell.inforLabel.text = array[0];
            cell.moneyLabel.text = array[1];
            
            
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:array[2] attributes:attribtDic];
            cell.beforMoneyLabel.attributedText = attribtStr;
            
            [cell.moneyLabel sizeToFit];
            [cell.beforMoneyLabel sizeToFit];
            
        }
        
    }
    
//    cell.backgroundColor = [UIColor greenColor];
    
    return cell;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.5;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.5;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZMProductViewController *goodVC = [[ZMProductViewController alloc] init];
    NSLog(@"<测试>按钮点击------");
    goodVC.toolID = [[_hotArr objectAtIndex:indexPath.row] objectForKey:@"carouselValue"];
//    NSLog(@"%@",goodVC.toolID);
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:goodVC];

    [self.hotOwner presentViewController:nav animated:NO completion:nil];
}
#pragma mark - 初始化数组
- (void)initValue
{
    self.hotArr = [NSMutableArray array];
}

#pragma mark - 数据请求
- (void)loadCarouselData
{
    [ZMHttpTool post:ZMMainUrl params:nil success:^(id responseObj) {
        self.hotArr = [[responseObj objectAtIndex:2] objectForKey:@"carousels"];
//                NSLog(@"%@",self.hotArr);
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
    
