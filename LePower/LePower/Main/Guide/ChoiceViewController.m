//
//  ChoiceViewController.m
//  LePower
//
//  Created by nick_beibei on 16/1/15.
//  Copyright © 2016年 nick_beibei. All rights reserved.
//

#import "ChoiceViewController.h"
#import "UIColor+Wonderful.h"
#import "Commen.h"
#import "PersonalViewController.h"

@interface ChoiceViewController ()

@end

@implementation ChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _createSubviews];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)_createSubviews {
    self.view.backgroundColor = [UIColor lavender];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor orpimentColor]];
    for (int i = 0; i<2; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-150)/2, (kScreenHeight-150)*(i+0.5)/2, 150, 150)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i+100;
        [self.view addSubview:imageView];
        if (imageView.tag == 100) {
            imageView.image = [UIImage imageNamed:@"userinfo_head_1"];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
            button.backgroundColor = [UIColor clearColor];
            button.tag = 10;
            [imageView addSubview:button];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame), CGRectGetMaxY(imageView.frame), 150, 20)];
            label.backgroundColor = [UIColor clearColor];
            label.text = @"女";
            label.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:label];
        }
        if (imageView.tag == 101) {
            imageView.image = [UIImage imageNamed:@"userinfo_head_2"];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
            button.backgroundColor = [UIColor clearColor];
            button.tag = 11;
            [imageView addSubview:button];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame), CGRectGetMaxY(imageView.frame), 150, 20)];
            label.backgroundColor = [UIColor clearColor];
            label.text = @"男";
            label.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:label];
        }
    }
}


#pragma mark - Tools
- (void)backAction {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#warning -性别选择
- (void)buttonAction:(UIButton *)btn {

    NSString *sexValue = btn.currentTitle;
    if (btn.tag == 10) {
        sexValue = @"女";
    }
    if (btn.tag == 11) {
        sexValue = @"男";
    }
    NSLog(@"%@",sexValue);
    NSDictionary *dic;
    [dic setValue:sexValue forKey:SexValue];
    NSUserDefaults *sexValueDefaults = [NSUserDefaults standardUserDefaults]; // 保存到本地
    [sexValueDefaults setValue:sexValue forKey:SexValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:SexValueNotification object:self userInfo:dic];
    PersonalViewController *vc = [[PersonalViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:NO completion:nil];
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
