//
//  HomeViewController.m
//  RUNwithu
//
//  Created by mty on 15/8/20.
//  Copyright (c) 2015年 mty. All rights reserved.
//

#import "HomeViewController.h"
#import "MainCollectionView.h"
#import "MainCollectionViewCell.h"
#import "Commen.h"
#import "UIColor+Wonderful.h"


@interface HomeViewController ()
{
    WeatherView* _weatherView;
    MotionServer* _motionServer;
        NSDate* _beginDate;
    MainCollectionView* _mainCollectionView;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor skyBlue];
    //关闭自动偏移
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.edgesForExtendedLayout = NO;
    [super viewDidLoad];
    [self _creatSubview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receaveNotification:) name:@"nowStepChanged" object:nil];
}

- (void)_creatSubview{    
    [self _createDateCollectionView];
    [self _creatMainCollectionView];
    [self _creatWeatherView];
    [self _creatMotionServer];
    
}

#pragma mark - 计步器通知处理
- (void)receaveNotification:(NSNotification*)notification{
    
    NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];

    MainCollectionViewCell* cell = (MainCollectionViewCell*)[_mainCollectionView cellForItemAtIndexPath:path];
    
    float nowsteps = [[notification object] floatValue];
    NSLog(@"%f",nowsteps);
    
    float progress = nowsteps/cell.target;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        cell.completed = nowsteps;
        
        cell.progressView.progress = progress;
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CreateSubviews

// 创建头部日期视图
- (void)_createDateCollectionView {
    
    // 创建头部日期小视图
    UICollectionViewFlowLayout *dateLayout = [[UICollectionViewFlowLayout alloc] init];
//    layout.itemSize = CGSizeMake(kScreenWidth/7, kScreenWidth/7);
    dateLayout.itemSize = CGSizeMake(44, 44);
    dateLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    DateCollectionView *dateView = [[DateCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44) collectionViewLayout:dateLayout];
    [self.view addSubview:dateView];
    
    
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

}

- (void)_creatMainCollectionView{
    //创建主要信息collectionView
    UICollectionViewFlowLayout* mainLayout = [[UICollectionViewFlowLayout alloc] init];
    mainLayout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight-49-44);
    mainLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    mainLayout.minimumLineSpacing = 0;
    
    _mainCollectionView = [[MainCollectionView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight-49-44) collectionViewLayout:mainLayout];
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
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"制定计划" message:@"本次运动目标步数为" delegate:self cancelButtonTitle:@"我不跑啦" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        //获取设定的目标运动距离
        UITextField* fl = [alertView textFieldAtIndex:0];
        _runningTarget = fl.text.integerValue;
        //设定计步器方法
        
        [_motionServer beginRunning];
        NSIndexPath* path = [NSIndexPath indexPathForItem:0 inSection:0];
        MainCollectionViewCell* cell = (MainCollectionViewCell*)[_mainCollectionView cellForItemAtIndexPath:path];
        cell.target = _runningTarget;
        
    }
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

#pragma mark - 计步器

- (void)_creatMotionServer{
    
    _motionServer = [MotionServer shareMotionServer];
    
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
