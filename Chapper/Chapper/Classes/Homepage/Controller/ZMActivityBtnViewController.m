//
//  ZMClickBtnViewController.m
//  Chapper
//
//  Created by liyongfei on 2017/11/20.
//  Copyright © 2017年 liyongfei. All rights reserved.
//

#import "ZMActivityBtnViewController.h"
#import "ZMChioceTableViewCell.h"
#import "ZMTodayItem.h"
#import <MJExtension.h>
#import "MJRefresh.h"
#import <UIImageView+WebCache.h>
#import "ZMWebNavigationController.h"
#import "ZMProductViewController.h"
@interface ZMActivityBtnViewController () <UITableViewDelegate,UITableViewDataSource>
// 模型数组
@property (nonatomic, strong) NSMutableArray *todayArr;
// 页面整体的tableview
@property (nonatomic, strong) UITableView *tableV;
// 刷新页数
@property (nonatomic, assign) NSInteger index;
@end

@implementation ZMActivityBtnViewController
// 懒加载
- (NSMutableArray *)todayArr
{
    if (_todayArr == nil) {
        _todayArr = [NSMutableArray array];
    }
    return _todayArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = kSmallRed;
    self.index = 1;
    [self loadCarouselData];
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - 64) style: UITableViewStyleGrouped];
    tableV.delegate = self;
    tableV.dataSource = self;

    // 下拉刷新
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadCarouselData)];
    [footer setTitle:@"点击或者上拉刷新" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"---没有更多数据---" forState:MJRefreshStateNoMoreData];
    [footer setTitle:@"松开开始加载" forState:MJRefreshStatePulling];
    tableV.mj_footer = footer;
    tableV.mj_footer.y -= 20;
//    footer.mj_y -= 60;
    [self.view addSubview:tableV];
    self.tableV = tableV;
//    self.tableV.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
}
// 设置nav
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 返回按钮
    UIButton *backBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    backBtn1.frame = CGRectMake(20, 30, 40, 40);
    //    backBtn1.centerY = self.navigationBar.centerY + 20;
    [backBtn1 setImage:[UIImage imageNamed:@"icon_xq_fanhui2.png"] forState:UIControlStateNormal];
    [backBtn1 sizeToFit];
    backBtn1.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    //    [self.view addSubview:backBtn1];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn1];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [backBtn1 addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];

}
// nav 点击返回事件
-(void)backBtn
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
// 通过设置分组模式来取消加载问题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 20)];
    view.backgroundColor = kSmallGray;
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 20)];
    view.backgroundColor = kSmallGray;
    return view;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.todayArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cellID";
    
    ZMChioceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZMChioceTableViewCell" owner:nil options:nil]lastObject];
    }
    if (self.todayArr.count > 0) {
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
        int couponP = beforP - finalP;
        cell.couponLable.text = [NSString stringWithFormat:@"¥%d",couponP];
        
    }
    return cell;
}
// tableView点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ZMProductViewController *goodVC = [[ZMProductViewController alloc] init];
    goodVC.todayArr = self.todayArr[indexPath.row];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:goodVC];
    [self presentViewController:nav animated:YES completion:nil];
//    [self.navigationController pushViewController:nav animated:YES];
    
}
/******************
 *** 数据解析
 ******************/
#pragma mark - 数据解析
- (void)loadCarouselData
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInt:_poseType] forKey:@"query_type"];
    [parameters setObject:_keyWorld forKey:@"query_data"];
    [parameters setObject:[NSNumber numberWithInt:_index] forKey:@"page_index"];
    [parameters setObject:[NSNumber numberWithInt:20] forKey:@"page_size"];
    [ZMHttpTool post:ZMItemUrl params:parameters success:^(id responseObj) {
        
        //        self.todayArr = [responseObj objectForKey:@"item"];
        NSArray *todayArr = [ZMTodayItem mj_objectArrayWithKeyValuesArray:responseObj[@"item"]];
        [self.todayArr addObjectsFromArray:todayArr];
        
        [self.tableV reloadData];
        [self.tableV.mj_footer endRefreshing];
        // 页数
        _index ++;
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


@end
