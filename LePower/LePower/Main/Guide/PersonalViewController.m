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

@interface PersonalViewController ()
{
    UILabel *_weightLabel; // 体重
    UILabel *_heightLabel; // 身高
    UILabel *_ageLabel; // 体重
}

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _createSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 创建子视图
- (void)_createSubviews {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor orpimentColor]];
    
    _weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth*0.1, 150, kScreenWidth*0.8, 70)];
    _weightLabel.backgroundColor = [UIColor olive];
    [self.view addSubview:_weightLabel];
    
    
    
    for (int i = 0; i<2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-50)*(i+0.5)/2, kScreenHeight*0.8, 50, 50)];
        button.backgroundColor = [UIColor plumColor];
        button.tag = i+100;
        button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];

    }
}

#pragma mark - Tools 
- (void)backAction {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)buttonAction:(UIButton *)btn {
    if (btn.tag == 100) {
        NSLog(@"上一步");
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    else {
        NSLog(@"下一步");
        
        TaskViewController *vc = [[TaskViewController alloc] initWithNibName:@"TaskViewController" bundle:nil];
//        TaskViewController *vc = [[TaskViewController alloc] init];
//        MainTabBarController *vc = [[MainTabBarController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//        [self.navigationController pushViewController:vc animated:nil];
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
