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
#import "ZHRulerview.h"

@interface WeightViewController ()<ZHRulerViewDelegate>
{
    EditBtnViewController *_editBtnVC;
    NSInteger _index;
    NSString *_data; // 改变的体重数据
    FMDB_weight *_FMDBweight;
    CGFloat _weight;
    
    NSNumber *_heightData; // 之前保存的体重数据
    NSNumber *_weightData;
    NSNumber *_ageData;
    NSString *_BMIData;
    ZHRulerView *_weightRulerview; //
    UILabel *_weightLabel; // 体重
    UILabel *_BMILabel; // BMI
}

@end

@implementation WeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor lotusRoot];
    // 取出保存的个人信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:PersonInfo]) {
        NSLog(@"%@",[userDefaults objectForKey:PersonInfo]);
        _heightData = [[userDefaults objectForKey:PersonInfo] objectForKey:@"heightData"];
        _weightData = [[userDefaults objectForKey:PersonInfo] objectForKey:@"weightData"];
        _ageData = [[userDefaults objectForKey:PersonInfo] objectForKey:@"ageData"];
    }
    
    [self _createnavigationBar];
    
    NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
    if ([userDefaults1 objectForKey:@"changeWeight"]) {
        _weightLabel.text = [NSString stringWithFormat:@"%@ Kg",[userDefaults objectForKey:@"changeWeight"]];
    }
    
    NSUserDefaults *userDefaults2 = [NSUserDefaults standardUserDefaults];
    if ([userDefaults2 objectForKey:@"BMIData"]) {
//        _BMIData = [userDefaults objectForKey:@"BMIDic"];
        _BMILabel.text = [NSString stringWithFormat:@"BMI:%@",[userDefaults objectForKey:@"BMIData"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 创建子视图
- (void)_createnavigationBar {
    
    // 设置返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"体重记录" style:UIBarButtonItemStylePlain target:self action:@selector(itemBtnAction:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];

    
//    // 设置编辑按钮
//    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(250, 0, 64, 40)];
//    [editBtn setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_add@2x"] forState:UIControlStateNormal];
//    [editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.navigationBar addSubview:editBtn];

    
//    // 设置删除按钮
//    UIButton *deletionBtn = [[UIButton alloc] initWithFrame:CGRectMake(300, 0, 64, 40)];
//    [deletionBtn setImage:[UIImage imageNamed:@"tabbar_discover_highlighted@2x"] forState:UIControlStateNormal];
//    [deletionBtn addTarget:self action:@selector(deletionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.navigationBar addSubview:deletionBtn];

   

    
    // 体重Label
    _weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, kScreenWidth/2-20, 100)];
    _weightLabel.backgroundColor = [UIColor skyBlue];
    

    _weightLabel.text = [NSString stringWithFormat:@"%@ Kg",_weightData];
    _weightLabel.font = [UIFont systemFontOfSize:30];
    _weightLabel.textAlignment = NSTextAlignmentCenter;
    _weightLabel.textColor = [UIColor silverColor];
    [self.view addSubview:_weightLabel];
    

   
    //BMI 体质指数（BMI）=体重（kg）÷ 身高^2（m）
    _BMILabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, 80, kScreenWidth/2-10, 100)];
    _BMILabel.backgroundColor = [UIColor skyBlue];

    NSString *str = [NSString stringWithFormat:@"%lf",[_weightData floatValue]*10000/([_heightData floatValue]*[_heightData floatValue])];
    NSString *BMIStr = [DataServer decimalwithFormat:@"0.0" floatV:[str floatValue]];
    _BMILabel.text = [NSString stringWithFormat:@"BMI:%@",BMIStr];
    
//    _BMILabel.text = [NSString stringWithFormat:@"BMI:%@",str];
    _BMILabel.font = [UIFont systemFontOfSize:30];
    _BMILabel.textAlignment = NSTextAlignmentCenter;
    _BMILabel.textColor = [UIColor silverColor];
    [self.view addSubview:_BMILabel];
    
    
    UIImageView *weightImgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2, 240, 100, 100)];
    weightImgView.image = [UIImage imageNamed:@"weight"];
    [self.view addSubview:weightImgView];
    
    _weightRulerview = [[ZHRulerView alloc] initWithMixNuber:25 maxNuber:200 showType:rulerViewshowHorizontalType rulerMultiple:1];
    _weightRulerview.frame = CGRectMake(0, 380, kScreenWidth, 45);
    _weightRulerview.backgroundColor = [UIColor LemonChiffon];
    _weightRulerview.defaultVaule = 45;
    _weightRulerview.tag = 110;
    _weightRulerview.delegate = self;
    [self.view addSubview:_weightRulerview];
    
    UIButton *addWeight = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2, 500, 100, 30)];
    [addWeight setTitle:@"添加体重" forState:UIControlStateNormal];
    [addWeight addTarget:self action:@selector(addWeightAction:) forControlEvents:UIControlEventTouchUpInside];
    addWeight.backgroundColor = [UIColor plumColor];
    [self.view addSubview:addWeight];
}

- (void)addWeightAction:(UIButton *)button {
    _weightLabel.text = [NSString stringWithFormat:@"%.1lf Kg",_weight];
    NSString *str = [NSString stringWithFormat:@"%lf",_weight*10000/([_heightData floatValue]*[_heightData floatValue])];
    NSString *BMIStr = [DataServer decimalwithFormat:@"0.0" floatV:[str floatValue]];
    _BMILabel.text = [NSString stringWithFormat:@"BMI:%@",BMIStr];
//    NSDictionary *BMIDic = [[NSDictionary alloc] initWithObjectsAndKeys:BMIStr,@"BMIDic", nil];
    [[NSUserDefaults standardUserDefaults] setObject:BMIStr forKey:@"BMIData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//
-(void)getRulerValue:(CGFloat)rulerValue withScrollRulerView:(ZHRulerView *)rulerView {
    if (rulerView.tag == 110) {
        NSLog(@"%lf",rulerValue);
        _weight = rulerValue;
        _weight = [[DataServer decimalwithFormat:@"0.0" floatV:rulerValue] doubleValue];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:_weight] forKey:@"changeWeight"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

// 返回按钮 响应方法
- (void)itemBtnAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//// 编辑按钮 响应方法
//- (void)editBtnAction:(UIButton *)button {
//    _editBtnVC = [[EditBtnViewController alloc] init];
//    [self.navigationController pushViewController:_editBtnVC animated:NO];
//}
//
//// 删除按钮 响应方法
//- (void)deletionBtnAction:(UIButton *)button {
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定要删除这条体重" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"确定");
//    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"取消");
//    }];
//    [alertController addAction:action];
//    [alertController addAction:cancelAction];
//    [self.navigationController presentViewController:alertController animated:YES completion:nil];
//}






















/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
