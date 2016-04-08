//
//  TopBgView.m
//  LePower
//
//  Created by nick_beibei on 16/4/6.
//  Copyright © 2016年 nick_beibei. All rights reserved.
//

#import "TopBgView.h"

@implementation TopBgView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _createSubviews];
        
    }
    return self;
}

- (void)_createSubviews {
    _headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    _headerImgView.image = [UIImage imageNamed:@"group_introducation_top"];
    [self addSubview:_headerImgView];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 215, kScreenWidth, 30)];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.text = @"使用群组功能，你可以:";
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_textLabel];
    
//    group_introducation_calendar group_introducation_pk  group_introducation_share
    NSArray *imgArray = @[@"group_introducation_share",@"group_introducation_pk",@"group_introducation_calendar"];
    NSArray *textArray = @[@"在微信群中晒成绩",@"与好友 PK 运动量",@"每日打卡赢取奖品"];
    for (int i = 0; i<3; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-190)/2, 280+i*32.5+20*i, 25, 25)];
        imgView.image = [UIImage imageNamed:imgArray[i]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-190)/2+40, 280+i*30+20*i, 150, 30)];
        label.text = [NSString stringWithFormat:@"%@",textArray[i]];
        [self addSubview:imgView];
        [self addSubview:label];
    }
}










@end
