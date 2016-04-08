//
//  PersonalViewController.m
//  LePower
//
//  Created by nick_beibei on 16/1/18.
//  Copyright © 2016年 nick_beibei. All rights reserved.
//

#import "PersonalViewController.h"
#import "ChoiceViewController.h"
#import "TaskViewController.h"
#import "MainTabBarController.h"
#import "ZHRulerview.h"

//static CGFloat const rulerMultiple=10;

@interface PersonalViewController ()<ZHRulerViewDelegate>
{
    ZHRulerView *_weightRulerview; // 体重
    ZHRulerView *_heightRulerview; // 身高
    ZHRulerView *_ageRulerview; // 年龄
    UILabel *_weightLabel; // 记录体重
    UILabel *_heightLabel; // 记录身高
    UILabel *_ageLabel; // 记录年份
    NSDictionary *_personInfoDic; // 记录个人信息
    
    CGFloat _weightData;
    CGFloat _ageData;
    CGFloat _heightData;
    
}

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightCyan];
    [self _createSubviews];
    //查看本地 有没有上一次选择的信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _personInfoDic = [defaults objectForKey:PersonInfo];
    if ([_personInfoDic objectForKey:@"weightData"] && [_personInfoDic objectForKey:@"ageData"] && [_personInfoDic objectForKey:@"heightData"]) {
        _weightLabel.text = [_personInfoDic objectForKey:@"weightData"];
        _ageLabel.text = [_personInfoDic objectForKey:@"ageData"];
        _heightLabel.text = [_personInfoDic objectForKey:@"heightData"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 创建子视图
- (void)_createSubviews {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor orpimentColor]];
    UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 75, kScreenWidth, 20)];
    pointLabel.textAlignment = NSTextAlignmentLeft;
//    pointLabel.backgroundColor = [UIColor beigeColor];
    pointLabel.text = @"请选择您的出生年份、身高及体重";
    [self.view addSubview:pointLabel];
    CGFloat rulerViewWidth = kScreenWidth*0.6;
    for (int i = 0; i<3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(rulerViewWidth+15, 120+130*i, kScreenWidth*0.4-20, 50)];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 200+i;
        // 将第一个尺子控件隐藏
        ZHRulerView *rulerView = [[ZHRulerView alloc] initWithMixNuber:10 maxNuber:100 showType:rulerViewshowHorizontalType rulerMultiple:1];
        rulerView.frame = CGRectMake(0, 0, kScreenWidth, 40);
        rulerView.backgroundColor = [UIColor realgarColor];
        [self.view addSubview:rulerView];
        rulerView.hidden = YES;
        
        if (label.tag == 200) {
            label.backgroundColor = [UIColor lavender];
            _ageLabel = label;
            _ageLabel.text = @"2000 年";
            _ageRulerview = [[ZHRulerView alloc] initWithMixNuber:1949 maxNuber:2016 showType:rulerViewshowHorizontalType rulerMultiple:1];
            _ageRulerview.frame = CGRectMake(5, 120, rulerViewWidth, 50);
            _ageRulerview.backgroundColor = [UIColor lavender];
            _ageRulerview.defaultVaule=2000;
            _ageRulerview.tag = 210;
            _ageRulerview.delegate = self;
            [self.view addSubview:_ageRulerview];
        } else if (label.tag == 201) {
            label.backgroundColor = [UIColor honeydew];
            _heightLabel = label;
            _heightLabel.text = @"160.0 cm";
            _heightRulerview = [[ZHRulerView alloc] initWithMixNuber:100 maxNuber:250 showType:rulerViewshowHorizontalType rulerMultiple:1];
            _heightRulerview.frame = CGRectMake(5, 250, rulerViewWidth, 50);
            _heightRulerview.backgroundColor = [UIColor honeydew];
            _heightRulerview.defaultVaule = 170;
            _heightRulerview.tag = 211;
            _heightRulerview.delegate = self;
            [self.view addSubview:_heightRulerview];
        } else {
            label.backgroundColor = [UIColor LemonChiffon];
            _weightLabel = label;
            _weightLabel.text = @"50.0 Kg";
            _weightRulerview = [[ZHRulerView alloc] initWithMixNuber:30 maxNuber:200 showType:rulerViewshowHorizontalType rulerMultiple:10];
            _weightRulerview.frame = CGRectMake(5, 380, rulerViewWidth, 50);
            _weightRulerview.backgroundColor = [UIColor LemonChiffon];
            _weightRulerview.defaultVaule = 50;
            _weightRulerview.tag = 212;
            _weightRulerview.delegate = self;
            [self.view addSubview:_weightRulerview];
        }
        [self.view addSubview:label];
    }
    for (int i = 0; i<2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-70)*(i+0.5)/2, kScreenHeight*0.8, 70, 70)];
        button.backgroundColor = [UIColor plumColor];
        button.tag = i+100;
        if (button.tag == 100) {
            [button setTitle:@"上一步" forState:UIControlStateNormal];
        } else {
            [button setTitle:@"下一步" forState:UIControlStateNormal];
        }
        button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

#pragma mark - rulerviewDelagete
-(void)getRulerValue:(CGFloat)rulerValue withScrollRulerView:(ZHRulerView *)rulerView{
    if (rulerView.tag == 210) {
//        _ageLabel = (UILabel *)[self.view viewWithTag:200];
        _ageLabel.text = [NSString stringWithFormat:@"年份:%i 年",(int)roundf(rulerValue)];
        _ageData = (int)roundf(rulerValue);
    } else if (rulerView.tag == 211) {
        _heightLabel.text = [NSString stringWithFormat:@"身高:%@ cm",[self decimalwithFormat:@"0.0" floatV:rulerValue]];
        _heightData = [[self decimalwithFormat:@"0.0" floatV:rulerValue] floatValue];
    } else {
        _weightLabel.text = [NSString stringWithFormat:@"体重:%@ Kg",[self decimalwithFormat:@"0.0" floatV:rulerValue]];
        _weightData = [[self decimalwithFormat:@"0.0" floatV:rulerValue] floatValue];
    }


}

#pragma mark - 格式话小数 四舍五入类型
- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:format];
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

#pragma mark - Tools
- (void)backAction {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)buttonAction:(UIButton *)btn {
    if (btn.tag == 100) {
        NSLog(@"上一步");
        [self dismissViewControllerAnimated:NO completion:nil];
    } else {
        NSLog(@"下一步");
        // 点击下一步时保存 年龄 身高 体重
//        NSDictionary *personInfo = [NSDictionary dictionaryWithObjectsAndKeys:_weightLabel.text,@"weightData",_heightLabel.text,@"heightData",_ageLabel.text,@"ageData", nil];
        NSDictionary *personInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:_weightData],@"weightData",[NSNumber numberWithFloat:_heightData],@"heightData",[NSNumber numberWithFloat:_ageData],@"ageData", nil];
        [[NSUserDefaults standardUserDefaults] setObject:personInfo forKey:PersonInfo];
        [[NSUserDefaults standardUserDefaults] synchronize];
        TaskViewController *vc = [[TaskViewController alloc] initWithNibName:@"TaskViewController" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:nil completion:nil];
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
