//
//  DetailSportsViewController.m
//  RUNwithu
//
//  Created by mty on 15/9/7.
//  Copyright (c) 2015年 mty. All rights reserved.
//

#import "DetailSportsViewController.h"
#import "SportsViewController.h"
#import "Commen.h"

@interface DetailSportsViewController ()
{
    
    UILabel *_dateLabel; // 日期Label
    UILabel *_timeLabel; // 时间Label
    UIView *_deletionOrcompletionView; // 创建取消视图以及确定视图
    UIButton *_deletionBtn; // 取消按钮
    UIButton *_completionBtn; // 确定按钮
    UIButton *_nextBtn; // 下一步
    UIImageView *_iconImgView;
}


@end

@implementation DetailSportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lavender];
    [self _createNavigationItem];
    [self _createSubview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -  自定制左边按钮 以及 响应方法

// 自定义左侧按钮
- (void)_createNavigationItem {
    NSString *title = self.sportsModel.name;
    // 自定义左侧按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(popButtonAction:)];
    // 设置导航栏右侧按钮
    self.navigationItem.leftBarButtonItem = leftItem;
}

//  左边按钮 响应方法
- (void)popButtonAction:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建子视图
- (void)_createSubview {
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 200, kScreenWidth, 250)];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    _datePicker.locale = locale;
    NSDate *myDate = _datePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    cccc, MMM d, hh:mm aa  英文版日期
//    yyyy-MM-dd hh:mm:ss 12小时制
//    yyyy-MM-dd HH:mm:ss 24小时制
    [dateFormat setDateFormat:@"HH:mm"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    [_datePicker addTarget:self action:@selector(datePickerValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_datePicker];
    
    _timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 200, kScreenWidth, 250)];
    [_timePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    _timePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    [_timePicker addTarget:self action:@selector(timePickerValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_timePicker];
    _timePicker.hidden = YES;
    
    _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 50, 50)];
    _iconImgView.image = [UIImage imageNamed:self.sportsModel.icon];
    [self.view addSubview:_iconImgView];
    
    UILabel *beginTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 80, 100, 40)];
    beginTimeLabel.text = @"开始时间";
    beginTimeLabel.font = [UIFont systemFontOfSize:21];
    beginTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:beginTimeLabel];
    
    UIImageView *manualSpliteImgView01 =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-110, 112, 100, 1)];
    manualSpliteImgView01.image = [UIImage imageNamed:@"manual_split"];
    [self.view addSubview:manualSpliteImgView01];
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-110, 80, 100, 40)];
    _dateLabel.text = prettyVersion;
    _dateLabel.font = [UIFont systemFontOfSize:22];
    _dateLabel.textColor = [UIColor orangeColor];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_dateLabel];
    
    
    UILabel *continueTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 130, 100, 40)];
    continueTimeLabel.text = @"持续时间";
    continueTimeLabel.font = [UIFont systemFontOfSize:21];
    continueTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:continueTimeLabel];
    UIImageView *manualSpliteImgView02 =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-110, 162, 100, 1)];
    manualSpliteImgView02.image = [UIImage imageNamed:@"manual_split"];
    [self.view addSubview:manualSpliteImgView02];
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-110, 130, 100, 40)];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.text = @"...";
    _timeLabel.textColor = [UIColor orangeColor];
    [self.view addSubview:_timeLabel];
    
    UIImageView *manualSpliteImgView0 =[[UIImageView alloc] initWithFrame:CGRectMake(0, 210, kScreenWidth, 2)];
    manualSpliteImgView0.image = [UIImage imageNamed:@"manual_split"];
    [self.view addSubview:manualSpliteImgView0];
    
    // manual_split
    UIImageView *manualSpliteImgView1 =[[UIImageView alloc] initWithFrame:CGRectMake(0, 307, kScreenWidth, 2)];
    manualSpliteImgView1.image = [UIImage imageNamed:@"manual_split"];
    [self.view addSubview:manualSpliteImgView1];
    
    // 创建取消视图以及确定视图
    _deletionOrcompletionView = [[UIView alloc] initWithFrame:CGRectMake(0, 475, kScreenWidth, 125)];
    [self.view addSubview:_deletionOrcompletionView];
//    widget_split_line 
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-1)/2, 0, 1, _deletionOrcompletionView.height)];
    lineImgView.image = [UIImage imageNamed:@"manual_vertical_split"];
    [_deletionOrcompletionView addSubview:lineImgView];
    
    
    // 取消按钮
    _deletionBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2-140, 0, 125, 125)];
    [_deletionBtn setTitle:@"算了吧" forState:UIControlStateNormal];
    [_deletionBtn setImage:[UIImage imageNamed:@"login_btn_cancel"] forState:UIControlStateNormal];
    _deletionBtn.imageEdgeInsets = UIEdgeInsetsMake(20, 37.5, 55, 0);
    _deletionBtn.titleEdgeInsets = UIEdgeInsetsMake(80,-10, 25, 37.5);
    [_deletionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_deletionBtn addTarget:self action:@selector(deletionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_deletionOrcompletionView addSubview:_deletionBtn];
    
    // 下一步按钮
    _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2+15, 0, 125, 125)];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setImage:[UIImage imageNamed:@"day_btn_right_down"] forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _nextBtn.imageEdgeInsets = UIEdgeInsetsMake(20, 37.5, 55, 0);
    _nextBtn.titleEdgeInsets = UIEdgeInsetsMake(80,-10, 25, 37.5);
    [_nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_deletionOrcompletionView addSubview:_nextBtn];
    
    // 确定按钮 accept    accept_p
    _completionBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2+15, 0, 125, 125)];
    [_completionBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_completionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_completionBtn setImage:[UIImage imageNamed:@"accept_p"] forState:UIControlStateNormal];
    _completionBtn.imageEdgeInsets = UIEdgeInsetsMake(20, 37.5, 55, 0);
    _completionBtn.titleEdgeInsets = UIEdgeInsetsMake(80,-15, 25, 37.5);
    [_completionBtn addTarget:self action:@selector(completionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _completionBtn.hidden = YES;
    [_deletionOrcompletionView addSubview:_completionBtn];
}



#pragma mark - button 响应方法
- (void)datePickerValueChange:(UIDatePicker *)datePicker {
    NSDate *date = datePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //    cccc, MMM d, hh:mm aa  英文版日期
    //    yyyy-MM-dd hh:mm:ss 12小时制
    //    yyyy-MM-dd HH:mm:ss 24小时制
    [dateFormat setDateFormat:@"HH:mm"];
    NSString *prettyVersion = [dateFormat stringFromDate:date];
    _dateLabel.text = prettyVersion;
}


- (void)timePickerValueChange:(UIDatePicker *)datePicker {
    NSInteger count = [[NSNumber numberWithDouble:datePicker.countDownDuration/60] integerValue];
    NSString *timeString = [NSString stringWithFormat:@"%02li:%02li",count/60,count%60];
    _timeLabel.text = timeString;
}


// 取消按钮
- (void)deletionBtnAction:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:NO];
}

// 下一步按钮  保存起始时间
- (void)nextBtnAction:(UIButton *)button {
    _datePicker.hidden = YES;
    button.hidden = YES;
    _timePicker.hidden = NO;
    _completionBtn.hidden = NO;
}

// 确定按钮 (可以用HUD试一下)
- (void)completionBtnAction:(UIButton *)button {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"活动添加成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:NO completion:nil];
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
