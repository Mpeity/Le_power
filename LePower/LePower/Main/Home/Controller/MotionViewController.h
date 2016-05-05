//
//  MotionViewController.h
//  LePower
//
//  Created by nick_beibei on 16/4/28.
//  Copyright © 2016年 nick_beibei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DateCollectionView.h"
#import "TargetProgressView.h"
#import "DataServer.h"
#import "WeatherView.h"


@interface MotionViewController :BaseViewController

//@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
//
//@property (weak, nonatomic) IBOutlet UILabel *motionTypeLabel;
//
//@property (weak, nonatomic) IBOutlet UILabel *isShakingLabel;
//
//@property (weak, nonatomic) IBOutlet UILabel *stepCountLabel;
//
//@property (weak, nonatomic) IBOutlet TargetProgressView *targetProgressView;

@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *motionTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *isShakingLabel;

@property (weak, nonatomic) IBOutlet UILabel *stepCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *targetLabel;


@property (assign,nonatomic) NSInteger target; // 目标
@property (assign,nonatomic) NSInteger completed; // 当前步数

@end
