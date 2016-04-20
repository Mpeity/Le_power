//
//  MotionServer.m
//  RUNwithu
//
//  Created by 冲锋只需勇气 on 15/9/9.
//  Copyright (c) 2015年 mty. All rights reserved.
//

#import "MotionServer.h"

@implementation MotionServer
{
    NSTimer* _timer;
    
    BOOL valiadCountStep;
    
    
}



- (CMPedometer *)stepCounter{
    if (!_stepCounter) {
        _stepCounter = [[CMPedometer alloc]init];
    }
    return _stepCounter;
}

+ (instancetype)shareMotionServer{
    
    static MotionServer* motionServer = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        motionServer = [[[self class] alloc] init];
    });
    
    return motionServer;
}

- (void)beginRunning{
    
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    
    if ([CMPedometer isStepCountingAvailable]) {
        self.stepCounter = [[CMPedometer alloc] init];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        NSDate *date = [[NSDate alloc] init];
        
        [self.stepCounter startPedometerUpdatesFromDate:date withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            
//                        self.countLabel.text = [NSString stringWithFormat:@"已经走了%@步", pedometerData.numberOfSteps];
                        NSLog(@"已经走了%@步", pedometerData.numberOfSteps);
        }];
        
        
//        [self.stepCounter startStepCountingUpdatesToQueue:queue updateOn:5 withHandler:^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error) {
////            self.countLabel.text = [NSString stringWithFormat:@"已经走了%ld步", (long)numberOfSteps];
//            NSLog(@"已经走了%ld步", (long)numberOfSteps);
//        }];
    }
    else{
//        self.countLabel.text = @"计步器不可用";
        NSLog(@"计步器不可用");
    }
    

    pedometer = [[CMPedometer alloc] init];
    if ([CMPedometer isStepCountingAvailable]) {
        NSLog(@"Yes");
    }else{
        NSLog(@"No");
    }
    _begindate = [[NSDate alloc] init];
    
    [pedometer startPedometerUpdatesFromDate:_begindate
                                 withHandler:^(CMPedometerData *pedometerData, NSError *error) {
                                     
                                     if (error) {
                                         NSLog(@"%@",error);
                                     }
                                     NSLog(@"%@",pedometerData);
                                 }];
    
    //启动定时器，每一秒查看一次总步数
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateAction) userInfo:nil repeats:YES];
    
}

//每一秒回报一次记录步数，对数据使用block方法
- (void)updateAction{
    
    NSDate* dateNow = [[NSDate alloc] init];
    [pedometer queryPedometerDataFromDate:_begindate toDate:dateNow withHandler:^(CMPedometerData *pedometerData, NSError *error) {
        NSNumber* number = pedometerData.numberOfSteps;
        NSInteger stemps = number.integerValue;
        NSLog(@"%li",(long)stemps);
        
        //set方法重写了
        [self setNowstep:stemps];
    }];

}

- (void)setNowstep:(NSInteger)nowstep{
    
    //每一秒发送一次通知
    NSNumber* temp = [NSNumber numberWithUnsignedInteger:nowstep];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"nowStepChanged" object:temp];
    
}


//
//#pragma mark - 计步算法
//
//- (void)startUpdateAccelerometer
//{
////     设置采样的频率，单位是秒
//    NSTimeInterval updateInterval = 0.05; // 每秒采样20次
//    
//    //    CGSize size = [self superview].frame.size;
//    //    __block CGRect f = [self frame];
//    __block int stepCount = 0; // 步数
//    //在block中，只能使用weakSelf。
////     判断是否加速度传感器可用，如果可用则继续
//    if ([_motionManager isAccelerometerAvailable] == YES) {
////         给采样频率赋值，单位是秒 
//        [_motionManager setAccelerometerUpdateInterval:updateInterval];
//        
////         加速度传感器开始采样，每次采样结果在block中处理 
//        [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
//         {
//             
//             CGFloat sqrtValue =sqrt(accelerometerData.acceleration.x*accelerometerData.acceleration.x+accelerometerData.acceleration.y*accelerometerData.acceleration.y+accelerometerData.acceleration.z*accelerometerData.acceleration.z);
//             
//             // 走路产生的震动率
//             if (sqrtValue > 1.552188 && valiadCountStep)
//             {
//                 CADisplayLink.paused = NO;
//                 [Database save:TableLocalFoot entity:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"footid",[[NSUserDefaults standardUserDefaults] valueForKey:@"token"],@"userid",[NSDate date],@"time", nil]];
//                 
//                 //                 [self.delegate totleNum:stepCount];
//                 stepCount +=1;
//                 valiadCountStep = NO;
//             }
//             
//         }];
//    }
//    
//}







@end
