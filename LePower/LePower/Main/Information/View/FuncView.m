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
#import "TrackingViewController.h"
#import "MapViewController.h"
#import "YSMapViewController.h"


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
    // manual_add_new_activity   manual_add_weight  manual_start_new_activity
    
    // 创建透明button 加在半透明视图上
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [clearButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    clearButton.backgroundColor = [UIColor clearColor];
    [self addSubview:clearButton];
    
    // 取消按钮
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-49)/2, kScreenHeight-49, 49, 49)];
    [_cancelButton setImage:[UIImage imageNamed:@"XXabc_ic_clear_mtrl_alpha"] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 创建sportButton
    _sportButton= [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth/3-70)/2, self.height+40, 70, 70)];
    [_sportButton setImage:[UIImage imageNamed:@"manual_add_new_activity"] forState:UIControlStateNormal];
    [_sportButton addTarget:self action:@selector(sportBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *sportlabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth/3-70)/2, self.height-167, 70, 15)];
    sportlabel.text = @"记录运动";
    sportlabel.textColor = [UIColor whiteColor];
    sportlabel.textAlignment = NSTextAlignmentCenter;
    [clearButton addSubview:sportlabel];
    sportlabel.hidden = YES;
    
    // 创建runButton
    _runButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/3+(kScreenWidth/3-70)/2, self.height+40, 70, 70)];
    [_runButton setImage:[UIImage imageNamed:@"manual_start_new_activity"] forState:UIControlStateNormal];
    [_runButton addTarget:self action:@selector(runBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *runlabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/3+(kScreenWidth/3-70)/2, self.height-167, 70, 15)];
    runlabel.text = @"开始跑步";
    runlabel.textColor = [UIColor whiteColor];
    runlabel.textAlignment = NSTextAlignmentCenter;
    [clearButton addSubview:runlabel];
    runlabel.hidden = YES;
    
    // 创建weightButton
    _weightButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/3*2+(kScreenWidth/3-70)/2, self.height+40, 70, 70)];
    [_weightButton setImage:[UIImage imageNamed:@"manual_add_weight"] forState:UIControlStateNormal];
    [_weightButton addTarget:self action:@selector(weightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *weightlabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/3*2+(kScreenWidth/3-70)/2, self.height-167, 70, 15)];
    weightlabel.text = @"记录体重";
    weightlabel.textColor = [UIColor whiteColor];
    weightlabel.textAlignment = NSTextAlignmentCenter;
    [clearButton addSubview:weightlabel];
    weightlabel.hidden = YES;
    
    // 取消按钮动画
    [UIView animateWithDuration:0.5 animations:^{
        [clearButton addSubview:_cancelButton];
        _cancelButton.transform = CGAffineTransformMakeRotation(M_PI_2);
    } completion:^(BOOL finished) {
        
    }];
    
    // 将三个按钮添加到clearButton上
    [clearButton addSubview:_sportButton];
    [clearButton addSubview:_runButton];
    [clearButton addSubview:_weightButton];
    [self testMoveToPoint:0.6 withView:_runButton];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self testMoveToPoint:0.6 withView:_sportButton];
        [self testMoveToPoint:0.6 withView:_weightButton];
    });
    
    sportlabel.hidden = NO;
    runlabel.hidden = NO;
    weightlabel.hidden = NO;
    
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
    
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(view.frame.origin.x - 35,self.height+40)];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(view.frame.origin.x - 35,self.height-187)];
    NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(view.frame.origin.x - 35,self.height-137)];
    
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
    _sportButton.frame = CGRectMake((kScreenWidth/3-70)/2, self.height-137, 70, 70);
    _runButton.frame = CGRectMake(kScreenWidth/3+(kScreenWidth/3-70)/2, self.height-137, 70, 70);
    _weightButton.frame = CGRectMake(kScreenWidth/3*2+(kScreenWidth/3-70)/2, self.height -137, 70, 70);
}




#pragma mark- ButonAction
// sportButton 纪录运动
- (void)sportBtnAction:(UIButton *)button {
    
    self.hidden = YES;
    SportsViewController *vc = [[SportsViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController presentViewController:nav animated:NO completion:nil];
//    MainTabBarController *vca = [[MainTabBarController alloc] init];
    
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
//    NSLog(@"%@",[UIApplication sharedApplication].windows);
}

// runButton 开始跑步
- (void)runBtnAction:(UIButton *)button {
    
    self.hidden = YES;
//    TrackingViewController *vc = [[TrackingViewController alloc] init];
    MapViewController *vc = [[MapViewController alloc] init];
//    YSMapViewController *vc = [[YSMapViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController presentViewController:nav animated:NO completion:nil];
    
}

// weightButton 纪录体重
- (void)weightBtnAction:(UIButton *)button {
    self.hidden = YES;
    WeightViewController *vc = [[WeightViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController presentViewController:nav animated:NO completion:nil];
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
