//
//  HomeViewController.h
//  RUNwithu
//
//  Created by mty on 15/8/20.
//  Copyright (c) 2015年 mty. All rights reserved.
//

#import "BaseViewController.h"
#import "DateCollectionView.h"
#import "TargetProgressView.h"
#import "DataServer.h"
#import "WeatherView.h"
#import "MotionServer.h"
typedef void(^runType)(NSInteger step);



@interface HomeViewController : BaseViewController<UIAlertViewDelegate>
@property(nonatomic,assign)NSInteger runningTarget;


@end
