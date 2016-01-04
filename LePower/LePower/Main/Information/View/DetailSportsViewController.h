//
//  DetailSportsViewController.h
//  RUNwithu
//
//  Created by mty on 15/9/7.
//  Copyright (c) 2015年 mty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportsModel.h"

@interface DetailSportsViewController : UIViewController
{
    
    UILabel *_dateLabel; // 日期Label
    
    UILabel *_timeLabel; // 时间Label
        
    UIView *_deletionOrcompletionView; // 创建取消视图以及确定视图
    
    UIButton *_deletionBtn; // 取消按钮
    
    UIButton *_completionBtn; // 确定按钮
}

@property (nonatomic,strong) SportsModel *sportsModel;

@end
