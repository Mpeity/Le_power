//
//  GuideView.m
//  LePower
//
//  Created by nick_beibei on 16/3/11.
//  Copyright © 2016年 nick_beibei. All rights reserved.
//

#import "GuideView.h"
#import "Commen.h"
#import "UIColor+Wonderful.h"
#import "WXApi.h"
#import "DataServer.h"
#import "ChoiceViewController.h"

@implementation GuideView
{
    UIView *_homePage; // 起始页
    UIImageView *_imageView; //
    NSTimer *_timer; // 计时器
    NSInteger _index; //
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self _createSubviews];
    }
    return self;
}

#pragma mark - 创建子视图
- (void)_createSubviews {
    _homePage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _homePage.backgroundColor = [UIColor seaShell];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2, kScreenHeight*0.75, 100, 40)];
    [button setTitle:@"欢迎使用" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor lightGreen];
    [_homePage addSubview:button];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_homePage];
    
    //创建UIImageView，添加到界面
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-150)/2, (kScreenHeight-150)/2, 150, 150)];
    [self addSubview:_imageView];
    //创建一个数组，数组中按顺序添加要播放的图片（图片为静态的图片）
    NSMutableArray *imgArray = [NSMutableArray array];
    for (int i=0; i<32; i++) {
        NSString *imageName = [NSString stringWithFormat:@"leg_000%02d.png",i];
        UIImage *image = [UIImage imageNamed:imageName];
        [imgArray addObject:image];
    }
    //把存有UIImage的数组赋给动画图片数组
    _imageView.animationImages = imgArray;
    //设置执行一次完整动画的时长
    _imageView.animationDuration = 1.2;
    //动画重复次数 （0为重复播放）
    _imageView.animationRepeatCount = 0;
    //开始播放动画
    [_imageView startAnimating];
}

- (void)buttonAction {
    ChoiceViewController *vc = [[ChoiceViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window.rootViewController presentViewController:nav animated:NO completion:nil];
}





















/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
