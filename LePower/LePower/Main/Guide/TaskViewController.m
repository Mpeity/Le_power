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
{
    NSDictionary *_countDataDic;
}

@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor soilColor];
    [self _createSubviews];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:CountData] objectForKey:@"stepCount"]) {
        self.countLabel.text = [NSString stringWithFormat:@"%@",[[defaults objectForKey:CountData] objectForKey:@"stepCount"]];
    }
    

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
    self.countSlider = (ASValueTrackingSlider *)sender;
    NSLog(@"%lf",self.countSlider.value);
    
//    NSString *stepCount = [NSString stringWithFormat:@"今日运动目标:%i步",(int)roundf(self.countSlider.value)];
    NSString *countStr = [NSString stringWithFormat:@"今日运动目标:"];
    NSString *stepCount = [NSString stringWithFormat:@"%i",(int)roundf(self.countSlider.value)];
    NSString *str = [countStr stringByAppendingString:stepCount];
    NSString *string = [str stringByAppendingString:@"步"];
    self.countLabel.text = string;
    _countDataDic = [NSDictionary dictionaryWithObjectsAndKeys:stepCount,@"stepCount", nil];
    [[NSUserDefaults standardUserDefaults] setObject:_countDataDic forKey:CountData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - 创建子视图
- (void)_createSubviews {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blueViolet]];
    
    // 完成按钮
    self.completeBtn.backgroundColor = [UIColor clearColor];
    self.completeBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    
    // 步数Label
    self.countLabel.backgroundColor = [UIColor clearColor];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.font = [UIFont systemFontOfSize:28];
    self.countLabel.textColor = [UIColor beigeColor];
    self.countLabel.text = @"今日运动目标:";
    [self.view addSubview:self.countLabel];

    // 卡路里Label
    self.calLabel.backgroundColor = [UIColor clearColor];
    self.calLabel.textAlignment = NSTextAlignmentCenter;
    self.calLabel.font = [UIFont systemFontOfSize:21];
    self.calorie.backgroundColor = [UIColor clearColor];
    self.calorie.textAlignment = NSTextAlignmentCenter;
    self.calorie.text = @"卡路里";
    self.calorie.font = [UIFont systemFontOfSize:19];
    [self.view addSubview:self.calLabel];
    
    // 距离Label
    self.distanceLabel.backgroundColor = [UIColor clearColor];
    self.distanceLabel.textAlignment = NSTextAlignmentCenter;
    self.distanceLabel.font = [UIFont systemFontOfSize:21];
    self.distance.backgroundColor = [UIColor clearColor];
    self.distance.textAlignment = NSTextAlignmentCenter;
    self.distance.text = @"距离";
    self.distance.font = [UIFont systemFontOfSize:19];
    [self.view addSubview:self.distanceLabel];
    
    // 时间Label
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont systemFontOfSize:21];
    self.time.backgroundColor = [UIColor clearColor];
    self.time.textAlignment = NSTextAlignmentCenter;
    self.time.text = @"时间";
    self.time.font = [UIFont systemFontOfSize:19];
    [self.view addSubview:self.timeLabel];
    
    // 目标View
    self.taskView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.taskView];
    [self.taskView addSubview:self.countSlider];
    self.countSlider.minimumValue = 500;
    self.countSlider.maximumValue = 19000;
    [self.countSlider setMaxFractionDigitsDisplayed:0];
    self.countSlider.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
    self.countSlider.font = [UIFont fontWithName:@"Menlo-Bold" size:22];
    self.countSlider.textColor = [UIColor colorWithHue:0.55 saturation:1.0 brightness:0.5 alpha:0.7];

    // 文字说明Label
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.text = @"根据您的个人情况推荐的运动目标";
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont systemFontOfSize:20];

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
