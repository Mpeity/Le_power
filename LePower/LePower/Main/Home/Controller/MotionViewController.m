//
//  MotionViewController.m
//  LePower
//
//  Created by nick_beibei on 16/4/28.
//  Copyright © 2016年 nick_beibei. All rights reserved.
//

#import "MotionViewController.h"
#import "SOMotionDetector.h"
#import "SOStepDetector.h"
#import "MainCollectionView.h"
#import "MainCollectionViewCell.h"
#import "Commen.h"
#import "UIColor+Wonderful.h"

@interface MotionViewController ()
{
    WeatherView* _weatherView;
    NSDate* _beginDate;
    MainCollectionView* _mainCollectionView;
    NSDictionary *_completedDic;
}

@end

@implementation MotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor skyBlue];
//     取出今日目标
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:CountData] objectForKey:@"stepCount"]) {
        NSString *countStr = [NSString stringWithFormat:@"%@",[[defaults objectForKey:CountData] objectForKey:@"stepCount"]];
        _target = [countStr integerValue];
    }
    [self _creatSubview];
    [self _motionAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_creatSubview{
    
    [self _createDateCollectionView];
    [self _creatWeatherView];
    
}


- (void)setTarget:(NSInteger)target{
    
    if (target != _target) {
        _target = target;
    }
}

- (void)_motionAction {
    __weak MotionViewController *weakSelf = self;
    [SOMotionDetector sharedInstance].motionTypeChangedBlock = ^(SOMotionType motionType) {
        NSString *type = @"";
        switch (motionType) {
            case MotionTypeNotMoving:
                type = @"Not moving";
                break;
            case MotionTypeWalking:
                type = @"Walking";
                break;
            case MotionTypeRunning:
                type = @"Running";
                break;
            case MotionTypeAutomotive:
                type = @"Automotive";
                break;
        }
        weakSelf.motionTypeLabel.text = type;
    };
    [SOMotionDetector sharedInstance].locationChangedBlock = ^(CLLocation *location) {
//        weakSelf.speedLabel.text = [NSString stringWithFormat:@"%.2f km/h",[SOMotionDetector sharedInstance].currentSpeed * 3.6f];
    };
    [SOMotionDetector sharedInstance].accelerationChangedBlock = ^(CMAcceleration acceleration) {
        BOOL isShaking = [SOMotionDetector sharedInstance].isShaking;
        weakSelf.isShakingLabel.text = isShaking ? @"shaking":@"not shaking";
    };
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [SOMotionDetector sharedInstance].useM7IfAvailable = YES; //Use M7 chip if available, otherwise use lib's algorithm
    }
    //This is required for iOS > 9.0 if you want to receive location updates in the background
    [SOLocationManager sharedInstance].allowsBackgroundLocationUpdates = YES;
    
    //Starting motion detector
    [[SOMotionDetector sharedInstance] startDetection];
    
    //Starting pedometer
    [[SOStepDetector sharedInstance] startDetectionWithUpdateBlock:^(NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }        
        self.completed++;
        self.stepCountLabel.text = [NSString stringWithFormat:@"已完成: %li", (long)self.completed];
        [_completedDic setValue:[NSNumber numberWithInteger:self.completed] forKey:@"completed"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"completedNotification" object:self userInfo:_completedDic];
    }];
}

#pragma mark - CreateSubviews

// 创建头部日期视图
- (void)_createDateCollectionView {
    
    //左边NavigationBar Items
    UIButton *calendarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [calendarBtn setImage:[UIImage imageNamed:@"home_run"] forState:UIControlStateNormal];
    [calendarBtn addTarget:self action:@selector(runBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* calendarItem = [[UIBarButtonItem alloc] initWithCustomView:calendarBtn];
    self.navigationItem.leftBarButtonItem = calendarItem;
    
    UIButton* weatherBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [weatherBtn setImage:[UIImage imageNamed:@"home_weather"] forState:UIControlStateNormal];
    [weatherBtn addTarget:self action:@selector(weatherBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* weatherItem = [[UIBarButtonItem alloc] initWithCustomView:weatherBtn];
    self.navigationItem.rightBarButtonItem = weatherItem;
    
    self.targetLabel.text = [NSString stringWithFormat:@"目标:%li",(long)_target];
}

- (void)_creatMainCollectionView{
    //创建主要信息collectionView
    UICollectionViewFlowLayout* mainLayout = [[UICollectionViewFlowLayout alloc] init];
    mainLayout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight/2);
    mainLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    mainLayout.minimumLineSpacing = 0;
    
    _mainCollectionView = [[MainCollectionView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight/2) collectionViewLayout:mainLayout];
    [self.view addSubview:_mainCollectionView];
}

#pragma mark - weatherView
- (void)_creatWeatherView{
    _weatherView = [[WeatherView alloc] initWithFrame:CGRectMake(kScreenWidth - 200, 10, 180, 300)];
    _weatherView.hidden = YES;
    [DataServer weatherDataWithCityName:@"杭州" block:^(id result) {
        
        NSString* weather = [result valueForKey:@"weather"];
        NSString* temp = [result valueForKey:@"temp"];
        NSString* aqi = [result valueForKey:@"aqi"];
        NSString* pm25 = [result valueForKey:@"pm25"];
        NSString* suit = @"";
        if (pm25.integerValue > 156) {
            suit = @"空气质量差\n不宜外出运动";
        }else{
            suit = @"适宜户外锻炼";
        }
        NSString* weatherString = [NSString stringWithFormat:@" 杭州 \n %@ \n 温度:%@ \n 空气质量:%@\n pm2.5:%@\n\n\n %@",weather,temp,aqi,pm25,suit];
        
        _weatherView.weatherLabel.text = weatherString;
    }];
    [self.view addSubview:_weatherView];
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWeatherView)];
    [self.view addGestureRecognizer:gesture];
}

- (void)closeWeatherView{
    
    if (!_weatherView.isHidden) {
        [UIView animateWithDuration:1 animations:^{
            _weatherView.hidden = YES;
        }];
        _weatherView.top = 10;
    }
    
}


#pragma mark - NavigationBtn 按钮响应方法

- (void)runBtnAction:(UIButton *)button {
    
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"制定计划" message:@"本次运动目标步数为" delegate:self cancelButtonTitle:@"我不跑啦" otherButtonTitles:@"确定", nil];
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [alert show];

}

- (void)weatherBtnAction{
    if (_weatherView.isHidden) {
        [UIView animateWithDuration:1 animations:^{
            _weatherView.top = 30;
            _weatherView.hidden = NO;
        }];
    }else{
        [UIView animateWithDuration:1 animations:^{
            _weatherView.hidden = YES;
        }];
        _weatherView.top = 10;
    }
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
