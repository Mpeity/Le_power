//
//  FuncView.m
//  RUNwithu
//
//  Created by mty on 15/9/7.
//  Copyright (c) 2015年 mty. All rights reserved.
//

#import "FuncView.h"
#import "SportsViewController.h"
#import "WeightViewController.h"
#import "RunningViewController.h"
#import "Commen.h"
#import "MainTabBarController.h"

@implementation FuncView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _createSubviews];
    }
    return self;
}

// 创建三个button
- (void)_createSubviews {
    
    //    sportButton 纪录运动
    //    runButton 开始跑步
    //    weightButton 纪录体重
    
    
    // 创建透明button 加在半透明视图上
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [clearButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    clearButton.backgroundColor = [UIColor clearColor];
    [self addSubview:clearButton];
    
    // 创建sportButton
    _sportButton= [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth/3-50)/2, self.height+40, 50, 50)];
//    _sportButton.backgroundColor = [UIColor redColor];
    [_sportButton setImage:[UIImage imageNamed:@"sports"] forState:UIControlStateNormal];
    [_sportButton addTarget:self action:@selector(sportBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 创建runButton
    _runButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/3+(kScreenWidth/3-50)/2, self.height+40, 50, 50)];
//    _runButton.backgroundColor = [UIColor greenColor];
    [_runButton setImage:[UIImage imageNamed:@"run"] forState:UIControlStateNormal];
    [_runButton addTarget:self action:@selector(runBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 创建weightButton
    _weightButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/3*2+(kScreenWidth/3-50)/2, self.height+40, 50, 50)];
//    _weightButton.backgroundColor = [UIColor purpleColor];
    [_weightButton setImage:[UIImage imageNamed:@"weight"] forState:UIControlStateNormal];
    [_weightButton addTarget:self action:@selector(weightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
     // 将三个按钮添加到clearButton上
    [clearButton addSubview:_sportButton];
    [clearButton addSubview:_runButton];
    [clearButton addSubview:_weightButton];
    
    
    [self testMoveToPoint:0.6 withView:_runButton];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self testMoveToPoint:0.6 withView:_sportButton];
        [self testMoveToPoint:0.6 withView:_weightButton];
    });
    
    
}


#pragma mark - 关键帧动画－－实现button跳动

- (void)testMoveToPoint:(NSTimeInterval)duration withView:(UIView *)view{
    
    // 设置锚点
    view.layer.anchorPoint = CGPointMake(0, 0);
    
    // 01 创建 动画对象
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // 02 设置 关键值
//    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(view.frame.origin.x - 25,700)];
//    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(view.frame.origin.x - 25,550)];
//    NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(view.frame.origin.x - 25,600)];
    
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(view.frame.origin.x - 25,self.height+40)];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(view.frame.origin.x - 25,self.height-187)];
    NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(view.frame.origin.x - 25,self.height-137)];
    
    // 03 设置animation 的属性
    animation.values = @[value1,value2,value3];
    animation.delegate = self;
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    
    // 04 把animation添加到layer中
    [view.layer addAnimation:animation forKey:nil];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    _sportButton.frame = CGRectMake((kScreenWidth/3-50)/2, 600, 50, 50);
//    _runButton.frame = CGRectMake(kScreenWidth/3+(kScreenWidth/3-50)/2, 600, 50, 50);
//    _weightButton.frame = CGRectMake(kScreenWidth/3*2+(kScreenWidth/3-50)/2, 600, 50, 50);
 
    // 适配
    _sportButton.frame = CGRectMake((kScreenWidth/3-50)/2, self.height-137, 50, 50);
    _runButton.frame = CGRectMake(kScreenWidth/3+(kScreenWidth/3-50)/2, self.height-137, 50, 50);
    _weightButton.frame = CGRectMake(kScreenWidth/3*2+(kScreenWidth/3-50)/2, self.height -137, 50, 50);
}



#pragma mark- ButonAction

// sportButton 纪录运动
- (void)sportBtnAction:(UIButton *)button {
    
    self.hidden = YES;
    SportsViewController *vc = [[SportsViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    MainTabBarController *vca = [[MainTabBarController alloc] init];
    
//    UIResponder *next = self.nextResponder;
//    while (next != nil) {
//        if ([next isKindOfClass:[UIWindow class]]) {
//            //沿着响应者链可以找到vc
//            UIWindow *vc = (UIWindow *)next;
//            [vc.rootViewController presentViewController:nav animated:NO completion:nil];
//            return;
//        }
//        next = next.nextResponder;
//    }
//    [self.window.rootViewController presentViewController:nav animated:NO completion:nil];

//    [vca presentViewController:nav animated:NO completion:nil];
    
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:NO completion:nil];
    NSLog(@"%@",[UIApplication sharedApplication].windows);
}

// runButton 开始跑步
- (void)runBtnAction:(UIButton *)button {
    
    self.hidden = YES;
    RunningViewController *vc = [[RunningViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window.rootViewController presentViewController:nav animated:NO completion:nil];
    
}

// weightButton 纪录体重
- (void)weightBtnAction:(UIButton *)button {
    
    self.hidden = YES;
    WeightViewController *vc = [[WeightViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window.rootViewController presentViewController:nav animated:NO completion:nil];
}



// 点击clearButton 从window上移除阴影部分
- (void)buttonAction:(UIButton *)button {    
    [self removeFromSuperview];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
