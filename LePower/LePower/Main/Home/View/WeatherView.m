//
//  WeatherView.m
//  RUNwithu
//
//  Created by 冲锋只需勇气 on 15/9/8.
//  Copyright (c) 2015年 mty. All rights reserved.
//

#import "WeatherView.h"
#import "Commen.h"

@implementation WeatherView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self _creatView];
        self.backgroundColor = [UIColor colorWithRed:0.4 green:0.8 blue:0.8 alpha:0.5];
        self.layer.cornerRadius = 10;

    }

    return self;
}

- (void)_creatView{
    _weatherLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _weatherLabel.numberOfLines = 0;
    [self addSubview:_weatherLabel];    
}

- (void)layoutSubviews{
    
    _weatherLabel.frame = CGRectMake(5, 5, self.width-10, self.height -10);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
