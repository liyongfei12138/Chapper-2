//
//  ZMBaseViewController.m
//  Chapper
//
//  Created by liyongfei on 2017/11/27.
//  Copyright © 2017年 liyongfei. All rights reserved.
// **********
// 超值9.9 20封顶 畅销榜都是这个页面
// **********


#import "ZMBaseViewController.h"
#import "MJRefresh.h"
#import "ZMTreatureCollectionViewCell.h"
#import "ZMClassifyItem.h"
#import "ZMProductViewController.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import "ZMTodayItem.h"
@interface ZMBaseViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArr;
// 商品Id 商品的唯一识别方式
@property (nonatomic, strong) NSString *itemId;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger index;
@end

@implementation ZMBaseViewController

// 懒加载数组
- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

// 设置nav
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64white"] forBarMetrics:UIBarMetricsDefault];
}
// 初始化数据
- (void)initValue
{
    self.index = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initValue];
    // 解析数据
    [self loadCarouselData];
    
    //    self.view.backgroundColor = [UIColor yellowColor];
    //    self.view.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0.5;
    layout.minimumLineSpacing = 0.5;
    [layout setSectionInset:UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5)];
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - 64) collectionViewLayout:layout];
    layout.minimumInteritemSpacing = 0.5;
    layout.minimumLineSpacing = 0.5;
    [layout setSectionInset:UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5)];
    
    [collectionView setBackgroundColor:kSmallGray];
    [self.view addSubview:collectionView];
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    
    //    _dataArr = [[NSMutableArray alloc]init];
    collectionView.height = kDeviceHeight - 64;
    // 适配iPhone X
    if (IS_IPHONE_X) {
        collectionView.height -= 22;
    }
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadCarouselData)];
    
    [footer setTitle:@"点击或者上拉刷新" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"---没有更多数据---" forState:MJRefreshStateNoMoreData];
    [footer setTitle:@"松开开始加载" forState:MJRefreshStatePulling];
    collectionView.mj_footer.hidden = YES;
    collectionView.mj_footer = footer;
    
    self.collectionView = collectionView;
}


#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((float)(kDeviceWidth) * 0.5 - 1, kDeviceWidth * 0.5 * 1.2 ) ;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifi = @"TreatureCollectionCell";
    
    UINib *nib = [UINib nibWithNibName:@"ZMTreatureCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:cellIndentifi];
    
    ZMTreatureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifi forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    //    cell.backgroundColor = [UIColor grayColor];
    if (self.dataArr.count > 0) {
        ZMClassifyItem *item = self.dataArr[indexPath.row];
        [cell.photo sd_setImageWithURL:[NSURL URLWithString:item.itemImage]];
        cell.inforLabel.text = item.itemName;
        cell.progressLabel.text = [NSString stringWithFormat:@"%@",item.finalPrice];
        cell.personLabel.text = item.sellAmount;
    }
    
    
    return cell;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZMProductViewController *goodVC = [[ZMProductViewController alloc] init];
    goodVC.lotterArr = _dataArr[indexPath.row];
    
    ZMTodayItem *item = self.dataArr[indexPath.row];
    self.itemId = item.itemId;
    goodVC.itemId = self.itemId;
    NSLog(@"%@",self.itemId);
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:goodVC];
    
    [self presentViewController:nav animated:NO completion:nil];
    //    [self.owner.navigationController pushViewController:goodVC animated:NO];
}/******************
 *** 数据解析
 ******************/
#pragma mark - 数据解析
- (void)loadCarouselData
{

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (_queryType == 5) {
        [parameters setObject:_queryData forKey:@"query_data"];
        [parameters setObject:[NSNumber numberWithInteger:_queryType] forKey:@"query_type"];
    }else if (_queryType == 6)
    {
        [parameters setObject:[NSNumber numberWithInteger:_queryType] forKey:@"query_type"];
        
    }
    [parameters setObject:[NSNumber numberWithInt:_index] forKey:@"page_index"];
    [ZMHttpTool post:ZMItemUrl params:parameters success:^(id responseObj) {
        
        NSDictionary *goodDict = [NSDictionary dictionary];
        goodDict = [responseObj valueForKey:@"item"];
        
        //      [ZMClassItem mj_objectWithKeyValues:self.goodDict];
        NSArray *arr = [ZMClassifyItem mj_objectArrayWithKeyValuesArray:goodDict];
        [self.dataArr addObjectsFromArray:arr];
        
        //        [self.dataArr removeAllObjects];
        [self.collectionView reloadData];
        [self.collectionView.mj_footer endRefreshing];
        _index ++;
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络"];
        [SVProgressHUD dismissWithDelay:0.5];
    }];
}

@end
