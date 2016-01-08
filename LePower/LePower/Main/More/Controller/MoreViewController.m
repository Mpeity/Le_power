//
//  MoreViewController.m
//  RUNwithu
//
//  Created by mty on 15/8/20.
//  Copyright (c) 2015年 mty. All rights reserved.
//

#import "MoreViewController.h"
#import "SetViewController.h"
#import "UIViewExt.h"
#import "Commen.h"
#import "UIColor+Wonderful.h"


@interface MoreViewController ()<UIScrollViewDelegate>

@end

@implementation MoreViewController{
    UIButton *_setButton; // 设置按钮
    UIScrollView *_scrollView; // 滑动视图
    UIView *_welfareView; // 乐福利视图
    UIView *_activityView; //乐活动视图
    UIView *_setView; // 设置视图
    NSInteger _index;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _createSubviews];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - CreateSubviews 
// 创建子视图
- (void)_createSubviews {
    // 创建滑动视图
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight*0.40)];
    _scrollView.backgroundColor = [UIColor lightCyan];
    _scrollView.contentSize = CGSizeMake(kScreenWidth*4, kScreenHeight*0.40); // 设置滚动内容的尺寸
    _scrollView.contentOffset = CGPointMake(0, 0); // 设置滚动的偏移量
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];

    _index = 0;
    for (int i = 0; i<4; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%d.png",i+1];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight*0.40)];
//        imgView.image = image;
        imgView.userInteractionEnabled = YES;
        [_scrollView addSubview:imgView];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight*0.40)];
        button.tag = 100+i;
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
        
        if (i == 0) {
            imgView.backgroundColor = [UIColor lotusRoot];
        }
        if (i == 1) {
            imgView.backgroundColor = [UIColor blueViolet];
        }
        if (i == 2) {
            imgView.backgroundColor = [UIColor greenYellow];
        }
    }
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    

    
    
    // 创建乐福利视图
    _welfareView = [[UIView alloc] initWithFrame:CGRectMake(0, _scrollView.height+30, kScreenWidth, kScreenHeight*0.20)];
    _welfareView.backgroundColor = [UIColor paleVioletRed];
    [self.view addSubview:_welfareView];
    
    // 创建乐活动视图
    _activityView = [[UIView alloc] initWithFrame:CGRectMake(0, _welfareView.height+_scrollView.height+40, kScreenWidth, kScreenHeight*0.20)];
    _activityView.backgroundColor = [UIColor mediumOrchid];
    [self.view addSubview:_activityView];
    
    // 创建设置视图
    _setView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_activityView.frame)+10, kScreenWidth, kScreenHeight*0.06)];
    _setView.backgroundColor = [UIColor mistyRose];
    _setView.userInteractionEnabled = YES;
    _setButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _setView.width, _setView.height)];
    [_setButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [_setButton setTitle:@"设置" forState:UIControlStateNormal];
    [_setButton setTitleColor:[UIColor blueViolet] forState:UIControlStateNormal];
    // 设置文字的内边距 UIEdgeInsets(上,左,下,右)
//    [_setButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 0, 0)];
//    _setButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_setView addSubview:_setButton];
    [self.view addSubview:_setView];
}

- (void)btnAction{
    SetViewController *vc = [[SetViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)timerAction:(NSTimer *)timer {
//    [_scrollView setContentOffset:CGPointMake(_index*kScreenWidth, 0) animated:YES];    
    [_scrollView scrollRectToVisible:CGRectMake(_index*kScreenWidth, 0, kScreenWidth, kScreenHeight*0.4) animated:YES];
    if (_index == 4) {
        _index = 0;
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    _index++;
    
}

// 点击图片响应方法
- (void)buttonAction:(UIButton *)btn {
    NSLog(@"%s",__func__);
    NSInteger tag;
    tag = btn.tag;
    switch (tag) {
        case 100:
            NSLog(@"%ld",tag);
            break;
        case 101:
            NSLog(@"%ld",tag);
            break;
        case 102:
            NSLog(@"%ld",tag);
            break;
        case 103:
            NSLog(@"%ld",tag);
            break;
            
        default:
            break;
    }
}

#pragma mark - scrollViewDelegate









@end
