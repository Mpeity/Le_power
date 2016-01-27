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


@interface TopViewController ()

@end

@implementation TopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置背景颜色
    self.view.backgroundColor = [UIColor lightPink];
    
    [self _createSubviews];
}

- (void)_createSubviews {
    UIButton *clickBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2, kScreenHeight*0.70, 100, 30)];
    clickBtn.backgroundColor = [UIColor bronzeColor];
    [self.view addSubview:clickBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tools

// 点击按钮响应方法
- (void)clickBtn:(UIButton *)button {
    
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
