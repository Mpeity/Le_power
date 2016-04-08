//
//  WeightViewController.m
//  RUNwithu
//
//  Created by mty on 15/9/7.
//  Copyright (c) 2015年 mty. All rights reserved.
//

#import "WeightViewController.h"
#import "EditBtnViewController.h"
#import "Commen.h"
#import "UIColor+Wonderful.h"
#import "FMDB_weight.h"

@interface WeightViewController ()
{
    EditBtnViewController *_editBtnVC;
    NSInteger _index;
    NSString *_data; // 改变的体重数据
    FMDB_weight *_FMDBweight;
    
    NSNumber *_heightData; // 之前保存的体重数据
    NSNumber *_weightData;
    NSNumber *_ageData;
    NSString *_BMIData;
}

@end

@implementation WeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _FMDBweight = [[FMDB_weight alloc] init];

    _index = 1;
    self.view.backgroundColor = [UIColor lotusRoot];
    [self _createnavigationBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeData:) name:DataChangeNotification object:nil];
    if (_data == nil) {
        _data = [NSString stringWithFormat:@"%@",_weightData];
        
    } else {
        NSLog(@"%@",[_FMDBweight queryBtn]);
        _data = [_FMDBweight queryBtn];
    }
    
    // 取出保存的个人信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:PersonInfo]) {
        NSLog(@"%@",[userDefaults objectForKey:PersonInfo]);
        _heightData = [[userDefaults objectForKey:PersonInfo] objectForKey:@"heightData"];
        _weightData = [[userDefaults objectForKey:PersonInfo] objectForKey:@"weightData"];
        _ageData = [[userDefaults objectForKey:PersonInfo] objectForKey:@"ageData"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeData:(NSNotification *)notification {
    NSLog(@"%s",__func__);
    NSLog(@"%@",notification.userInfo);
    _data = [notification.userInfo objectForKey:DataChange];
    _weightLabel.text = _data;
    NSString *str = [NSString stringWithFormat:@"%lf",[_data doubleValue]*10000/([_heightData floatValue]*[_heightData floatValue])];
    NSString *BMIStr = [DataServer decimalwithFormat:@"0.0" floatV:[str floatValue]];
    _BMILabel.text = [NSString stringWithFormat:@"BMI:%@",BMIStr];
    
    NSDictionary *BMIDic = [[NSDictionary alloc] initWithObjectsAndKeys:BMIStr,@"BMIDic", nil];
    [[NSUserDefaults standardUserDefaults] setObject:BMIDic forKey:@"BMIData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self _dataDbFuncWithData:_data];
    _index++;
}

- (void)_dataDbFuncWithData:(NSString *)weightData {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    NSLog(@"date\n%lld",date);
    NSDate *dd = [NSDate dateWithTimeIntervalSince1970:date];
    NSLog(@"dd:%@",dd);
    [_FMDBweight createDb];
    [_FMDBweight addIndex:_index WithData:weightData WithCurrentDate:dd];
    [_FMDBweight queryBtn];

    
//    [_dataDb insertIndex:_index WithData:weightData WithCurrentDate:dd];
//    [_dataDb searchValues];
}

#pragma mark - 创建子视图
- (void)_createnavigationBar {
    
    // 设置返回按钮
    UIButton *itemBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [itemBtn setTitle:@"体重趋势" forState:UIControlStateNormal];
    
    // 设置字体颜色
    [itemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [itemBtn addTarget:self action:@selector(itemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:itemBtn];
    
    // 设置编辑按钮
    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(250, 0, 64, 40)];
    [editBtn setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_add@2x"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置删除按钮
    UIButton *deletionBtn = [[UIButton alloc] initWithFrame:CGRectMake(300, 0, 64, 40)];
    [deletionBtn setImage:[UIImage imageNamed:@"tabbar_discover_highlighted@2x"] forState:UIControlStateNormal];
    [deletionBtn addTarget:self action:@selector(deletionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:editBtn];
    [self.navigationController.navigationBar addSubview:deletionBtn];

   

    
    // 体重Label
    _weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, kScreenWidth/2-20, 100)];
    _weightLabel.backgroundColor = [UIColor skyBlue];
    

    _weightLabel.text = [NSString stringWithFormat:@"%@ Kg",_data];
    _weightLabel.font = [UIFont systemFontOfSize:30];
    _weightLabel.textAlignment = NSTextAlignmentCenter;
    _weightLabel.textColor = [UIColor silverColor];
    [self.view addSubview:_weightLabel];
    

   
    //BMI 体质指数（BMI）=体重（kg）÷ 身高^2（m）
    _BMILabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, 80, kScreenWidth/2-10, 100)];
    _BMILabel.backgroundColor = [UIColor skyBlue];
//    _BMILabel.text = @"24.6";
    
//    NSString *str = [NSString stringWithFormat:@"%lf",[_data doubleValue]*10000/([_heightData  floatValue]*[_heightData floatValue])];
//    NSString *weightStr = [DataServer decimalwithFormat:@"0.0" floatV:[str floatValue]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([[userDefaults objectForKey:@"BMIDic"] objectForKey:@"BMIData"]) {
        _BMIData = [[userDefaults objectForKey:@"BMIDic"] objectForKey:@"BMIData"];

    }
    _BMILabel.text = [NSString stringWithFormat:@"BMI:%@",_BMIData];
    
    _BMILabel.font = [UIFont systemFontOfSize:30];
    _BMILabel.textAlignment = NSTextAlignmentCenter;
    _BMILabel.textColor = [UIColor silverColor];
    [self.view addSubview:_BMILabel];
}

// 返回按钮 响应方法
- (void)itemBtnAction:(UIButton *)button {

    [self dismissViewControllerAnimated:YES completion:nil];
}

// 编辑按钮 响应方法
- (void)editBtnAction:(UIButton *)button {
    
    _editBtnVC = [[EditBtnViewController alloc] init];
    [self.navigationController pushViewController:_editBtnVC animated:NO];
}

// 删除按钮 响应方法
- (void)deletionBtnAction:(UIButton *)button {
    NSInteger identy = (NSInteger)[_FMDBweight.db lastInsertRowId];
    NSLog(@"%ld",identy);
    [_FMDBweight deleteDataWithIndex:identy];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定要删除这条体重" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确定");
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"取消");
    }];
    [alertController addAction:action];
    [alertController addAction:cancelAction];
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
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
