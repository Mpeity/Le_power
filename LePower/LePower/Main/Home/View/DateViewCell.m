//
//  DateViewCell.m
//  RUNwithu
//
//  Created by 冲锋只需勇气 on 15/9/8.
//  Copyright (c) 2015年 mty. All rights reserved.
//

#import "DateViewCell.h"
#import "Commen.h"


@implementation DateViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
    
        self.backgroundColor = [UIColor clearColor];
        [self _creatLabel];
    }
    
    return self;
}

- (void)_creatLabel{
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _dateLabel.font = [UIFont boldSystemFontOfSize:17];
    _dateLabel.backgroundColor = [UIColor clearColor];
          
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_dateLabel];
    
    
    self.layer.cornerRadius = 22;
    self.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0.7 alpha:1];


}


@end
