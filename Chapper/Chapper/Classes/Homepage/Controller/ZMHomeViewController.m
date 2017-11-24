//
//  ZMHomepageVC.m
//  Chapper
//
//  Created by liyongfei on 2017/11/2.
//  Copyright © 2017年 liyongfei. All rights reserved.
//
// **********
// 主页
// **********
#import "ZMHomeViewController.h"
#import "ZMHeadView.h"
#import <AFNetworking.h>
#import <PYSearch.h>
#import <MJExtension.h>
#import "ZMSearchViewController.h"
#import "ZMHotHeadView.h"
#import "MJRefresh.h"
#import "ZMTodayItem.h"
#import "ZMChioceTableViewCell.h"
#import "ZMProductViewController.h"
#import <UIImageView+WebCache.h>
@interface ZMHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *todayArr;
//@property (nonatomic, strong) ZMChoiceViewController *dayVC;
@property (nonatomic, strong) NSMutableArray *hotSearchArr;
//默认页数
@property (nonatomic, assign) int index;

// 商品Id 商品的唯一识别方式
@property (nonatomic, strong) NSString *itemId;
@end

@implementation ZMHomeViewController
// **********
// 宏
// **********
//#define collectedHeight ((float)(kDeviceWidth) * 0.4 - 0.5)/ 4.0 * 5.0
//获取searchBar中field
#define searchFieldKey @"_searchField"
//获取placeholder中text
#define placeholderKey @"_placeholderLabel.font"
// 懒加载
- (NSMutableArray *)todayArr
{
    if (_todayArr == nil) {
        _todayArr = [NSMutableArray array];
    }
    return _todayArr;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.todayArr = [NSMutableArray array];
    [self initValue];
    [self loadCarouselData];
    [self loadKeyData];
    //设置背景颜色
    self.view.backgroundColor = kSmallGray;
    // 创建tableview
    [self setUpTableView];

}

// 创建tableview
- (void)setUpTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight + 49 - 110) style:UITableViewStylePlain];
    self.tableView.backgroundColor = kSmallGray;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    ZMHeadView *headView = [[ZMHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KCarouselHeight + KButtonHeight * 2 + collectedHeight + 60 + 100)];
    headView.backgroundColor = [UIColor redColor];
    headView.owner = self;
//    headView.twoOwner = self;
    [self.tableView setTableHeaderView:headView];
//    [self.tableView setRowHeight:kDeviceHeight];
    
//    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

    //创建hot页面
    ZMHotHeadView *hotView = [[ZMHotHeadView alloc] initWithFrame:CGRectMake(0, KCarouselHeight + KButtonHeight * 2 + 10 - 40, kDeviceWidth, collectedHeight)];
    hotView.hotOwner = self;
    hotView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:hotView];

    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:
                                     ^{
                                         //Call this Block When enter the refresh status automatically
                                         [self.tableView.mj_footer resetNoMoreData];
//                                         [_todayArr removeAllObjects];
                                         [headView loadCarouselData];
                                         [hotView loadCarouselData];
                                         [self reloadTypeView];
                                         
                                     }];
//    [header beginRefreshing];
    self.tableView.mj_header.y -= 20;
    self.tableView.mj_header = header;
    self.tableView.mj_header.hidden = NO;
    [header setTitle:@"正在加载呦..." forState:MJRefreshStateRefreshing];
    
    //上拉更新

    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadCarouselData)];
    [footer setTitle:@"点击或者上拉刷新" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"---没有更多数据---" forState:MJRefreshStateNoMoreData];
    [footer setTitle:@"松开开始加载" forState:MJRefreshStatePulling];
    self.tableView.mj_footer = footer;
    self.tableView.mj_footer.y -= 20;
    
}
// 上拉刷新
- (void)reloadTypeView
{
    [self loadCarouselData];
    [self.tableView.mj_header endRefreshing];

    
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.todayArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *showUserInfoCellIdentifier = @"cellID";
    ZMChioceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZMChioceTableViewCell" owner:nil options:nil] lastObject];
    }
    
    ZMTodayItem *item = self.todayArr[indexPath.row];
    [cell.photo sd_setImageWithURL:[NSURL URLWithString:item.itemImage]];
    cell.name.text = item.itemName;
    cell.moneyLabel .text = item.finalPrice;
    cell.beforMoneyLabel.text = item.price;
    
    // 设置中划线效果
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:item.price attributes:attribtDic];
    cell.beforMoneyLabel.attributedText = attribtStr;
    cell.personLabel.text = item.sellAmount;
    [cell.personLabel sizeToFit];
    // 转换类型
    CGFloat finalP = [item.finalPrice floatValue];
    CGFloat beforP = [item.price floatValue];
    CGFloat couponP = beforP - finalP;
    cell.couponLable.text = [NSString stringWithFormat:@"¥%.0f",couponP];
    
    return cell;
}
// tableView点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ZMProductViewController *goodVC = [[ZMProductViewController alloc] init];
    goodVC.todayArr = self.todayArr[indexPath.row];
    
    ZMTodayItem *item = self.todayArr[indexPath.row];
    self.itemId = item.itemId;
    goodVC.itemId = self.itemId;
    NSLog(@"%@",self.itemId);
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:goodVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 130;
}
// tableViewcell头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 30;
    
}
//今日优品头部view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *tableSectionHeart = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30)];
    [tableSectionHeart setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView* imageName = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_jinriyp"]];
    [imageName sizeToFit];
    imageName.x = 10;
    imageName.centerY = tableSectionHeart.height * 0.5;
    [tableSectionHeart addSubview:imageName];
    return tableSectionHeart;
}
//// 点击cell时间
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

// 在页面将要显示时创建nav
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //使用分类更改nav背景
//    [self.navigationController.navigationBar lt_setBackgroundColor:kSmallRed];
    // 隐藏Nav下线
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth * 0.9, 44)];
    titleView.backgroundColor = [UIColor whiteColor];
//     UIColor *color =  self.navigationController.navigationBar.backgroundColor ;
    
    //设置nav标题图片
    UIImageView *titleImageV = [[UIImageView alloc] initWithImage:[UIImage imageWithRandAsOriImagename:@"logo"]];
    [titleImageV sizeToFit];
    titleImageV.centerY = titleView.height * 0.5 - 2;
    titleImageV.x = 0;
    [titleView addSubview:titleImageV];
    
    //创建searchBar
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.frame = CGRectMake(titleImageV.x + titleImageV.width + 20, 3, titleView.width - titleImageV.width - 20, 35);
//    searchBar.backgroundColor = ZMColor(236, 237, 239);
    searchBar.layer.cornerRadius = 18;
    searchBar.layer.masksToBounds = YES;
    [searchBar.layer setBorderWidth:0];
//    [searchBar.layer setBorderColor:ZMColor(236, 237, 239).CGColor];
    
    
    searchBar.placeholder = @"搜索好宝贝";
    //修改placeholder字体颜色和大小
    UITextField *searchField = [searchBar valueForKey:searchFieldKey];
    searchField.backgroundColor = ZMColor(236, 237, 239);
    [searchField setValue:[UIFont systemFontOfSize:16] forKeyPath:placeholderKey];
    searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    [searchBar setContentMode:UIViewContentModeCenter];//设置内容模式
    [titleView addSubview:searchBar];
    
    self.navigationItem.titleView = titleView;
    
}


// 初始化数据
- (void)initValue
{
    //初始化默认页数
    self.index = 1;
    self.todayArr = [NSMutableArray array];
    self.hotSearchArr = [NSMutableArray array];
}

#pragma mark search
// 使用第三方创建搜索
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    PYSearchViewController *searchVC = [PYSearchViewController searchViewControllerWithHotSearches:self.hotSearchArr searchBarPlaceholder:@"搜索好宝贝" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        
        ZMSearchViewController *findVC = [[ZMSearchViewController alloc]init];
        findVC.keyWorld = searchText;
        findVC.poseType = 2;
        
//        searchViewController.cancelButton.title = @"123";
        [searchViewController.navigationController pushViewController:findVC animated:NO];
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchVC];
    

    
    searchVC.hotSearchStyle = PYHotSearchStyleColorfulTag;
    searchVC.searchHistoryStyle = PYSearchHistoryStyleBorderTag;
    searchVC.searchHistoryTitle = @"历史搜索";

//    searchVC.
    [self presentViewController:nav animated:NO completion:nil];
}

#pragma mark - 数据searchKey解析
- (void)loadKeyData
{
    [ZMHttpTool post:ZMHotSearchUrl params:nil success:^(id responseObj) {
        NSArray *array = responseObj;
        for (int i = 0; i < array.count; i++) {
            NSString *key = [[responseObj objectAtIndex:i] objectForKey:@"keyWord"];
            
            [self.hotSearchArr addObject:key];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


/******************
 *** 数据解析
 ******************/
#pragma mark - 数据解析
- (void)loadCarouselData
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInt:0] forKey:@"query_type"];
    [parameters setObject:[NSNumber numberWithInt:8] forKey:@"page_size"];
    [parameters setObject:[NSNumber numberWithInt:_index] forKey:@"page_index"];
    [ZMHttpTool post:ZMItemUrl params:parameters success:^(id responseObj) {
        
        //        self.todayArr = [responseObj objectForKey:@"item"];
        NSArray *todayArr = [ZMTodayItem mj_objectArrayWithKeyValuesArray:responseObj[@"item"]];
        [self.todayArr addObjectsFromArray:todayArr];
        
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.todayArr,@"dayArray",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dayH" object:nil userInfo:dict];
        
//        [self reloadAllData];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        // 页数
        _index ++;
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


@end
