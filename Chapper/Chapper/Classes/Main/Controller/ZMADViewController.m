//
//  ZMADViewController.m
//  Chapper
//
//  Created by liyongfei on 2017/12/4.
//  Copyright © 2017年 liyongfei. All rights reserved.
//

#import "ZMADViewController.h"
#import "ZMMainTabBarController.h"
#import <UMMobClick/MobClick.h>

@interface ZMADViewController ()
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;
@property (weak, nonatomic) IBOutlet UIView *adView;

// 定时器
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation ZMADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // 设置按钮
    [self setjumpBtn];
    // 创建定时器
    _timer =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    // 创建手势
    [self setTapGest];
}
    // 创建手势
- (void)setTapGest
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.adView addGestureRecognizer:tap];
}
// 点击广告
- (void)tap
{
//    [MobClick profileSignInWithPUID:[session getUser].openId];
    [MobClick event:@"readAD"];
    
    // 跳转到界面 => safari
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/%E6%AC%A2%E4%B9%90%E7%82%B8%E9%87%91%E8%8A%B1-%E5%85%A8%E6%B0%91%E7%82%B8%E9%87%91%E8%8A%B1%E7%9C%9F%E4%BA%BA%E7%89%88/id1289569132?l=zh&ls=1&mt=8"];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }
}
// 设置按钮
- (void)setjumpBtn
{
    // 设置文字颜色
    [self.jumpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // 设置背景图片
    UIImage *backImage = [self imageByApplyingAlpha:0.3 image:[UIImage imageNamed:@"JumpBtnImgae"]];

    [self.jumpBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    // 监听点击事件
    [self.jumpBtn addTarget:self action:@selector(clickJumpBtn) forControlEvents:UIControlEventTouchUpInside];
     // 设置圆角
    self.jumpBtn.clipsToBounds = YES;
    self.jumpBtn.layer.cornerRadius = 10;
    
}
// 点击跳过按钮
- (void)clickJumpBtn {
   
    
    ZMMainTabBarController *mainVC = [[ZMMainTabBarController alloc] init];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = mainVC;

    // 干掉定时器
    [_timer invalidate];
}
// 定时
- (void)timeChange
{
    // 倒计时
    static int i = 4;
    if (i == 1) {
        [self clickJumpBtn];
    }
    
    i--;
    // 设置跳转按钮文字
    [self.jumpBtn setTitle:[NSString stringWithFormat:@"跳过(%d)",i] forState:UIControlStateNormal];
}
/**
 * @param alpha 透明度
 * @param image 图片
 */
-(UIImage *)imageByApplyingAlpha:(CGFloat )alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, image.CGImage);

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
    
}
@end
