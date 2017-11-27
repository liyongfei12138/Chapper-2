//
//  ZMCollectViewController.m
//  Chapper
//
//  Created by liyongfei on 2017/11/21.
//  Copyright © 2017年 liyongfei. All rights reserved.
// **********
// 收藏
// **********

#import "ZMCollectViewController.h"
#import "ZMCollectTableViewCell.h"
#import <MJExtension.h>
#import "ZMCollectItem.h"
//#import "ZMTodayItem.h"
#import "ZMProductViewController.h"
#import <UIImageView+WebCache.h>
#import "ZMTodayItem.h"
#import <SVProgressHUD.h>
#import "ZMWebNavigationController.h"
#import "ZMWebViewController.h"
#import <AlibabaAuthSDK/ALBBSDK.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>
@interface ZMCollectViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableV;

//// 收藏商品数据
//@property (nonatomic, strong) NSMutableArray *data;
// 收藏商品数据
@property (nonatomic, strong) NSMutableArray *data;
// 底部view
@property (nonatomic, strong) UIView *bottomView;
// 购买数
@property (nonatomic, strong) UILabel *buyCountLabel;
// 是否在编辑状态
@property (nonatomic, assign) BOOL isSelect;
// 选中的数组
@property (nonatomic,strong) NSMutableArray *selectArr;

// 全选按钮
@property (nonatomic,strong) UIButton *allSelectBtn;

// 模型数组
@property (nonatomic,strong) NSMutableArray *itemArr;
// 商品Id 商品的唯一识别方式
@property (nonatomic, strong) NSString *itemId;

@end

@implementation ZMCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
//    self.data = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8 ", nil];
    NSArray *arr1  = [ZMSaveTools objectForKey:@"toolID"];
    
    
    // 初始化数据
    [self initValue];
    
    [self.data addObjectsFromArray:arr1];
//    [self.data insertObject:arr1 atIndex:0];
    // 数组转换模型
//     self.itemArr = [ZMCollectItem mj_objectArrayWithKeyValuesArray:self.data];
    self.itemArr = [ZMCollectItem mj_objectArrayWithKeyValuesArray:self.data];

    
    //    // 创建tableview
    [self setTableView];
    // 创建底部view
    [self setBottomView];
    
    [self.tableV reloadData];
    // 当有数据时候显示提醒
    if (self.itemArr.count > 0) {
        [SVProgressHUD showImage:[UIImage imageNamed:@"zhuyi"] status:@"直接点击商品就可以领卷购买哟"];
        [SVProgressHUD dismissWithDelay:1.3];
    }
   
}
// 在页面将要显示时创建编辑按钮
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    // 返回按钮
    UIButton *backBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn1 addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [backBtn1 setImage:[UIImage imageNamed:@"icon_xq_fanhui2.png"] forState:UIControlStateNormal];
    [backBtn1 sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn1];;
    
    backBtn1.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [self.view addSubview:backBtn1];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:kSmallRed forState:UIControlStateNormal];

    [editBtn setTitle:@"完成" forState:UIControlStateSelected];
    [editBtn setTitleColor:kSmallRed forState:UIControlStateSelected];
    [editBtn addTarget:self action:@selector(clickEditBtn:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];;
}
-(void)backBtn
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

// 在页面消失的时候赋值
- (void)viewWillDisappear:(BOOL)animated
{
    NSArray *saveArr = [[NSArray alloc]initWithArray:self.data];
    [ZMSaveTools setObject:saveArr forKey:@"toolID"];

}
// 初始化数据
- (void)initValue
{
    // 初始化选中的数组
    self.selectArr = [NSMutableArray array];
    self.isSelect = NO;
    self.data = [NSMutableArray array];
}
// 创建tableview
- (void)setTableView
{
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];
    tableV.backgroundColor = kSmallGray;
    tableV.delegate = self;
    tableV.dataSource = self;
    [self.view addSubview:tableV];
    self.tableV = tableV;
    
}
// 创建底部view
- (void)setBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight - 60 , kDeviceWidth, 60)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.hidden = YES;
    
    // 上部下划线
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , kDeviceWidth, 1)];
    shadowView.backgroundColor = kSmallGray;
    [bottomView addSubview:shadowView];
    
    // 底部删除按钮∫
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame = CGRectMake(kDeviceWidth - 100, 0, 100,bottomView.height);
    [removeBtn setTitle:@"删除" forState:UIControlStateNormal];
    [removeBtn setBackgroundColor:kSmallRed];
    [removeBtn addTarget:self action:@selector(clickRemoveBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:removeBtn];
    
    // 已买多少件
    UILabel *buyCountLabel = [[UILabel alloc] init];
    buyCountLabel.text = [NSString stringWithFormat:@"已选中%d件商品",0];
    buyCountLabel.font = [UIFont systemFontOfSize:16];
    [buyCountLabel sizeToFit];
    buyCountLabel.centerY = removeBtn.centerY;
    buyCountLabel.x = removeBtn.x - 15 - buyCountLabel.width;
    buyCountLabel.textColor = ZMColor(64, 64, 64);
    [bottomView addSubview:buyCountLabel];
    self.buyCountLabel = buyCountLabel;
    
    // 全选按钮
    UIButton *allSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    allSelectBtn.frame = CGRectMake(0, 0, 60, 60);
    [allSelectBtn sizeToFit];
    allSelectBtn.x = 20;
    allSelectBtn.centerY = buyCountLabel.centerY;
    [allSelectBtn setImage:[UIImage imageNamed:@"button_xuanze1"] forState:UIControlStateNormal];
    [allSelectBtn setImage:[UIImage imageNamed:@"button_xuanze2"] forState:UIControlStateSelected];
    [allSelectBtn addTarget:self action:@selector(clickAllSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:allSelectBtn];
    self.allSelectBtn = allSelectBtn;
    // 全选文字
    UILabel *allSelectLabel = [[UILabel alloc] init];
    allSelectLabel.text = @"全选";
    allSelectLabel.font = [UIFont systemFontOfSize:19];
    [allSelectLabel sizeToFit];
    allSelectLabel.centerY = allSelectBtn.centerY;
    allSelectLabel.x = CGRectGetMaxX(allSelectBtn.frame) + 10;
    allSelectLabel.textColor = [UIColor blackColor];
    [bottomView addSubview:allSelectLabel];
    
    [self.navigationController.view addSubview:bottomView];
    
    self.bottomView = bottomView;
//    return bottomView;
}
#pragma mark - 点击编辑按钮
// 点击编辑按钮
- (void)clickEditBtn:(UIButton *)button
{
    NSArray *saveArr = [[NSArray alloc]initWithArray:self.data];
    [ZMSaveTools setObject:saveArr forKey:@"toolID"];
    
    
    [self.tableV reloadData];
    // 当刚开始编辑时或者完成编辑元素那一定不是全选
    self.allSelectBtn.selected = NO;
    
    BOOL isSelect = !(button.selected);
    // 每次点击取反
    
    button.selected = isSelect;
    // 出现左侧编辑
    [self.tableV setEditing:isSelect animated:YES];
    // 底部view状态和按钮状态一致
    self.bottomView.hidden = !isSelect;
    // 判断当编辑状态下改变tableview的高度
    if (isSelect) {
        self.tableV.height =kDeviceHeight - self.bottomView.height - 30;
    }else{
        self.tableV.height = kDeviceHeight;
    }
    
    self.isSelect = isSelect;

    
    // 编辑中选中数组清零
    [self.selectArr removeAllObjects];
    self.buyCountLabel.text = [NSString stringWithFormat:@"已选中%lu件商品",self.selectArr.count];
    
    
  
}

#pragma mark - 点击删除按钮
- (void)clickRemoveBtn
{
    
//    [self.data removeObjectsInArray:self.selectArr];
//    [self.tableV reloadData];

    
//    NSString *str = [[self.selectArr objectAtIndex:0] objectForKey:@"itemId"];
    [self.data removeObjectsInArray:self.selectArr];
    
    [self.tableV reloadData];
    
    
    // 编辑中选中数组清零
    [self.selectArr removeAllObjects];
   
    self.buyCountLabel.text = [NSString stringWithFormat:@"已选中%d件商品",0];
//    [self.tableV reloadData];
    
    self.allSelectBtn.selected = NO;
    
    NSArray *saveArr = [[NSArray alloc]initWithArray:self.data];
    [ZMSaveTools setObject:saveArr forKey:@"toolID"];
}
#pragma mark - 点击全选按钮
- (void)clickAllSelectBtn:(UIButton *)button
{
    // 判断当没有收藏时全选按钮不能点击
    if (self.data.count == 0) {
        button.enabled = NO;
    }
    
    button.selected = YES;
//    button.enabled = !(button.selected);
    
    // 编辑中选中数组清零
    [self.selectArr removeAllObjects];
    for (int i = 0; i < self.data.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.tableV selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    // 添加收藏的数组
    [self.selectArr addObjectsFromArray:self.data];

    self.buyCountLabel.text = [NSString stringWithFormat:@"已选中%lu件商品",self.selectArr.count];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
// 设置tableview 数据 UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"collectCellID";
    
    ZMCollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZMCollectTableViewCell" owner:nil options:nil] lastObject];

    }

    NSString *imStr = [[self.data objectAtIndex:indexPath.row] objectForKey:@"itemImage"];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:imStr]];
    cell.afterPrice.text = [[self.data objectAtIndex:indexPath.row] objectForKey:@"finalPrice"];
    cell.beforPrice.text = [[self.data objectAtIndex:indexPath.row] objectForKey:@"price"];
    cell.name.text = [[self.data objectAtIndex:indexPath.row] objectForKey:@"itemName"];
    
    return cell;
}


// 选中时选中数组添加
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
     ZMCollectItem *item = self.itemArr[indexPath.row];
    // 判断是否有选中状态
    if (_isSelect) {
        // 在编辑状态可以点击
//        self.data[indexPath.row];
//        NSInteger i = indexPath.row;
//        NSString *str = [[self.data objectAtIndex:indexPath.row] objectForKey:@"itemId"];
        [self.selectArr addObject:[self.data objectAtIndex:indexPath.row]];
//        [self.selectArr addObject:str];
        NSLog(@"%@",self.selectArr);
        self.buyCountLabel.text = [NSString stringWithFormat:@"已选中%lu件商品",self.selectArr.count];
        
        // 判断如果数组个数相等为全选
        if (self.selectArr.count == self.data.count) {
            self.allSelectBtn.selected = YES;
        }
        
    }else
    {
        // 取消选中状态
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        // 如果用户没有登入
        if(![[ALBBSession sharedInstance] isLogin])
        {
            // 成功回调
            [[ALBBSDK sharedInstance] auth:self successCallback:^(ALBBSession *session)
             {
                 ZMWebViewController *getVC = [[ZMWebViewController alloc] initWithWebView];
                 getVC.title = @"领券中心";
//                 getVC.webUrl = self.url;
                
                 getVC.webUrl = item.promotionURL;
                 
                 ZMWebNavigationController *getNav = [[ZMWebNavigationController alloc] initWithRootViewController:getVC];
                 
                 [self presentViewController:getNav animated:YES completion:nil];
             }
             // 失败回调
                           failureCallback:^(ALBBSession *session, NSError *error)
             {
                 
                 
             }];
        }
        else
        {
            ZMWebViewController *getVC = [[ZMWebViewController alloc] initWithWebView];
            getVC.title = @"领券中心";

            getVC.webUrl = item.promotionURL;
            
            ZMWebNavigationController *getNav = [[ZMWebNavigationController alloc] initWithRootViewController:getVC];
            
            [self presentViewController:getNav animated:YES completion:nil];
            
        }
    }
}
// 取消时选中数组移除
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    // 当移除元素那一定不是全选
    self.allSelectBtn.selected = NO;
    [self.selectArr removeObject:[self.data objectAtIndex:indexPath.row]];
//    [self.selectArr removeObjectAtIndex:indexPath.row];
    
    self.buyCountLabel.text = [NSString stringWithFormat:@"已选中%lu件商品",self.selectArr.count];
    
    
}




// 隐藏头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 20)];
    view.backgroundColor = kSmallGray;
    return view;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
// 设置tableview  UITableViewDelegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.data removeObjectAtIndex:indexPath.row];
    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {

        [self.data removeObjectAtIndex:indexPath.row];
        [self.tableV deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
//       [ZMSaveTools  setObject:self.itemArr forKey:@"removeID"];
//    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isSelect) {
        return UITableViewCellEditingStyleDelete;
    }else {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }
//
}
// 当滑动并点击删除时候调用 保存数组
- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *saveArr = [[NSArray alloc]initWithArray:self.data];
    [ZMSaveTools setObject:saveArr forKey:@"toolID"];
}


@end
