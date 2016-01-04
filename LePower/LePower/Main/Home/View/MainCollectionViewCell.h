//
//  MainCollectionViewCell.h
//  RUNwithu
//
//  Created by 冲锋只需勇气 on 15/9/8.
//  Copyright (c) 2015年 mty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TargetProgressView.h"

@interface MainCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *targetValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *completedValueLabel;
@property (weak, nonatomic) IBOutlet TargetProgressView *progressView;

@property (assign,nonatomic) NSInteger target;
@property (assign,nonatomic) NSInteger completed;

@end
