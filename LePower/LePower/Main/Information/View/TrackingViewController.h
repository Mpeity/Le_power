//
//  TrackingViewController.h
//  LePower
//
//  Created by nick_beibei on 16/5/3.
//  Copyright © 2016年 nick_beibei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import "Tracking.h"

@interface TrackingViewController : UIViewController<MAMapViewDelegate, TrackingDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) Tracking *tracking;

@end
