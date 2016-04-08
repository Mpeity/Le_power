//
//  TopViewController.m
//  RUNwithu
//
//  Created by mty on 15/8/20.
//  Copyright (c) 2015年 mty. All rights reserved.
//

#import "TopViewController.h"
#import "UIColor+Wonderful.h"
#import "WXApi.h"
#import "Commen.h"
#import "TopBgView.h"
#import "WechatLogViewController.h"

@interface TopViewController ()
{
    TopBgView *_topView;
}

@end

@implementation TopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置背景颜色
//    self.view.backgroundColor = [UIColor lightPink];
    
    [self _createSubviews];
}

- (void)_createSubviews {
    
    _topView = [[TopBgView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_topView];
    
    
    UIButton *clickBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-200)/2, kScreenHeight*0.75, 200, 30)];
    clickBtn.layer.cornerRadius = 5;
    clickBtn.layer.masksToBounds = YES;
//    [clickBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    clickBtn.backgroundColor = [UIColor bronzeColor];
    [clickBtn setTitle:@"开始使用" forState:UIControlStateNormal];
    [clickBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:clickBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tools

// 点击按钮响应方法
- (void)clickBtn:(UIButton *)button {
    WechatLogViewController *vc = [[WechatLogViewController alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
