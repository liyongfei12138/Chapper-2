//
//  ZMLotteryVCViewController.m
//  Chapper
//
//  Created by liyongfei on 2017/11/7.
//  Copyright © 2017年 liyongfei. All rights reserved.
// **********
// 搜索
// **********

#import "ZMSearchViewController.h"
#import "MJRefresh.h"
#import "ZMTreatureCollectionViewCell.h"
#import "ZMProductViewController.h"
#import "ZMClassifyItem.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import "ZMTodayItem.h"
@interface ZMSearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

// 数据数组
@property (nonatomic, strong) NSMutableArray *searchArr;
@property (nonatomic, strong) UICollectionView *collectionView;
// 数据加载页数
@property (nonatomic, assign) NSInteger index;

// 商品Id 商品的唯一识别方式
@property (nonatomic, strong) NSString *itemId;
@end

@implementation ZMSearchViewController

- (NSMutableArray *)searchArr
{
    if (_searchArr == nil) {
        _searchArr = [NSMutableArray array];
    }
    return _searchArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化数据
    [self initValue];
    // 加载数据
    [self loadCarouselData];
//    self.view.backgroundColor = kSmallGray;
    // 返回按钮
    [self setBackBtn];
//    self.view.backgroundColor = [UIColor yellowColor];
//    self.view.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];

    layout.minimumInteritemSpacing = 0.5;
    layout.minimumLineSpacing = 0.5;
    [layout setSectionInset:UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5)];
//    layout.minimumInteritemSpacing = 0.5;
//    layout.minimumLineSpacing = 0.5;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - self.tabBarController.tabBar.bounds.size.height) collectionViewLayout:layout];
    layout.minimumInteritemSpacing = 0.5;
    layout.minimumLineSpacing = 0.5;
    [layout setSectionInset:UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5)];
    [collectionView setBackgroundColor:kSmallGray];
    
    // 设置代理
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    
    //    _dataArr = [[NSMutableArray alloc]init];
    collectionView.height = kDeviceHeight - 64;
    
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadCarouselData)];
    
    [footer setTitle:@"点击或者上拉刷新" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"---没有更多数据---" forState:MJRefreshStateNoMoreData];
    [footer setTitle:@"松开开始加载" forState:MJRefreshStatePulling];
    collectionView.mj_footer.hidden = YES;
    collectionView.mj_footer = footer;
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

// 返回按钮
- (void)setBackBtn
{
    UIButton *backBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn1.frame = CGRectMake(40, 0, 40, 40);
    [backBtn1 setImage:[UIImage imageNamed:@"icon_xq_fanhui2"] forState:UIControlStateNormal];
    [backBtn1 addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [backBtn1 sizeToFit];
    backBtn1.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn1];
}
// 设置nav
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_reset];
}
- (void)viewDidAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    UILabel *topView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 64)];
    topView.text = @"搜索结果";
    topView.font = topView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    [topView setTextAlignment:NSTextAlignmentCenter];
    self.navigationController.navigationBar.topItem.titleView.hidden = NO;
    self.navigationController.navigationBar.topItem.titleView= topView;
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.translucent = NO;
}
// 初始化数据
- (void)initValue
{
//    self.goodDict = [NSDictionary dictionary];
    //    self.dataArr = [NSMutableArray array];
    self.index = 1;
}
// 返回方法
-(void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((float)(kDeviceWidth) * 0.5 - 1, kDeviceWidth * 0.5 * 1.2);
//    return CGSizeMake((float)(kDeviceWidth) * 0.5 - 1, kDeviceWidth * 0.5 * 1.2 );
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.searchArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifi = @"TreatureCollectionCell";
    
    UINib *nib = [UINib nibWithNibName:@"ZMTreatureCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:cellIndentifi];
    
    ZMTreatureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifi forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (self.searchArr.count > 0) {
        ZMClassifyItem *item = self.searchArr[indexPath.row];
        [cell.photo sd_setImageWithURL:[NSURL URLWithString:item.itemImage]];
        cell.inforLabel.text = item.itemName;
        cell.progressLabel.text = [NSString stringWithFormat:@"¥%@",item.finalPrice];
        cell.personLabel.text = item.sellAmount;
    }
    
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
    goodVC.lotterArr = _searchArr[indexPath.row];
    
    
    ZMTodayItem *item = self.searchArr[indexPath.row];
    self.itemId = item.itemId;
    goodVC.itemId = self.itemId;
    
    NSLog(@"<测试>按钮点击");
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:goodVC];
    
    [self presentViewController:nav animated:NO completion:nil];
}
#pragma mark - 数据请求
- (void)loadCarouselData
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:_keyWorld forKey:@"query_data"];
//    [parameters setObject:[NSNumber numberWithInt:_poseType] forKey:@"page_order"];
    [parameters setObject:[NSNumber numberWithInt:2] forKey:@"query_type"];
    [parameters setObject:[NSNumber numberWithInt:20] forKey:@"page_size"];
     [parameters setObject:[NSNumber numberWithInt:_index] forKey:@"page_index"];
    [ZMHttpTool post:ZMItemUrl params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = [responseObj valueForKey:@"item"];
        NSArray *arr = [ZMClassifyItem mj_objectArrayWithKeyValuesArray:dict];
        [self.searchArr addObjectsFromArray:arr];
        
        [self.collectionView reloadData];
        // 刷新数据
        [self.collectionView.mj_footer endRefreshing];
        _index ++;
        
    } failure:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"请检查网络"];
        [SVProgressHUD dismissWithDelay:0.5];
    }];
}
@end
