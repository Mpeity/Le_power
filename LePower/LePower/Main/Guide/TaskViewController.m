//
//  TaskViewController.m
//  LePower
//
//  Created by nick_beibei on 16/1/25.
//  Copyright © 2016年 nick_beibei. All rights reserved.
//

#import "TaskViewController.h"
#import "MainTabBarController.h"

@interface TaskViewController ()

@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self _createSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 完成按钮响应方法
- (IBAction)completeBtnAction:(id)sender {
    MainTabBarController *vc = [[MainTabBarController alloc] init];
    [self.navigationController presentViewController:vc animated:nil completion:nil];
}

#pragma mark - 滑块视图响应方法
- (IBAction)sliderAction:(id)sender {
    self.countSlider = (UISlider *)sender;
    NSLog(@"%lf",self.countSlider.value);
}


#pragma mark - 创建子视图
- (void)_createSubviews {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blueViolet]];
    
    // 步数Label
    self.countLabel.text = @"1111111步";
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.font = [UIFont systemFontOfSize:50];
    self.countLabel.textColor = [UIColor beigeColor];
    [self.view addSubview:self.countLabel];
    
    // 卡路里Label
    [self.view addSubview:self.calLabel];
    
    // 距离Label
    [self.view addSubview:self.distanceLabel];
    
    // 时间Label
    [self.view addSubview:self.timeLabel];
    
    //目标View
    [self.view addSubview:self.taskView];
    [self.taskView addSubview:self.countSlider];
    self.countSlider.minimumValue = 3000;
    self.countSlider.maximumValue = 10000;
    self.countSlider.continuous = YES;
}


#pragma mark - tools
- (void)backAction {
    [self dismissViewControllerAnimated:nil completion:nil];
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
