//
//  GuideViewController.m
//  LePower
//
//  Created by nick_beibei on 16/1/11.
//  Copyright © 2016年 nick_beibei. All rights reserved.
//

#import "GuideViewController.h"
#import "Commen.h"
#import "UIColor+Wonderful.h"
#import "WXApi.h"
#import "DataServer.h"
#import "ChoiceViewController.h"


@interface GuideViewController ()
{
    UIView *_homePage; // 起始页
    UIImageView *_imageView; //
    NSTimer *_timer; // 计时器
    NSInteger _index; //
}

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _createSubviews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 创建子视图
- (void)_createSubviews {
    _homePage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _homePage.backgroundColor = [UIColor seaShell];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2, kScreenHeight*0.75, 100, 40)];
    [button setTitle:@"欢迎使用" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor lightGreen];
    [_homePage addSubview:button];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_homePage];
    
    //创建UIImageView，添加到界面
   _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-150)/2, (kScreenHeight-150)/2, 150, 150)];
    [self.view addSubview:_imageView];
    //创建一个数组，数组中按顺序添加要播放的图片（图片为静态的图片）
    NSMutableArray *imgArray = [NSMutableArray array];
    for (int i=0; i<32; i++) {
        NSString *imageName = [NSString stringWithFormat:@"leg_000%02d.png",i];
        UIImage *image = [UIImage imageNamed:imageName];
        [imgArray addObject:image];
    }
    //把存有UIImage的数组赋给动画图片数组
    _imageView.animationImages = imgArray;
    //设置执行一次完整动画的时长
    _imageView.animationDuration = 1.2;
    //动画重复次数 （0为重复播放）
    _imageView.animationRepeatCount = 0;
    //开始播放动画
    [_imageView startAnimating];
}

- (void)buttonAction {
    ChoiceViewController *vc = [[ChoiceViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:NO completion:nil];
}

// 微信登录相关
/*
#pragma mark - 创建子视图
- (void)_createSubview {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2, kScreenHeight*0.6, 100, 30)];
    [button setTitle:@"微信登录" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor peachRed];
    [self.view addSubview:button];    
}

#pragma mark - 微信登录
-(void)sendAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}


- (void)logIn {
//    https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    NSString *urlString = @"https://api.weixin.qq.com/sns/oauth2/access_token?";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *appid = WXAppID;
    NSString *secret = WXAppSecret;
    NSString *code = @"CODE";
    NSString *grant_type = @"authorization_code";
    [params setObject:appid forKey:@"appid"];
    [params setObject:secret forKey:@"secret"];
    [params setObject:code forKey:@"code"];
    [params setObject:grant_type forKey:@"grant_type"];
    
    [DataServer requestWithFullUrlString:urlString params:params method:@"GET" data:nil block:^(id result) {
        
        NSLog(@"%@",result);
    }];
}
  */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
