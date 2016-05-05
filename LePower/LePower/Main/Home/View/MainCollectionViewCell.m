
//
//  MainCollectionViewCell.m
//  RUNwithu
//
//  Created by 冲锋只需勇气 on 15/9/8.
//  Copyright (c) 2015年 mty. All rights reserved.
//

#import "MainCollectionViewCell.h"
#import "TargetProgressView.h"

@implementation MainCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"homeBG"]];

    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {

//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"homeBG.jpg"]];
    }
    return self;
}

- (void)setCompleted:(NSInteger)completed{
    
    if (!(completed == _completed)) {
        
        _completed = completed;
        _progressView.progress = _completed/_target;
        
        [self setNeedsLayout];
    }
}

- (void)setTarget:(NSInteger)target{
    
    if (target != _target) {
        _target = target;
        
        [self setNeedsLayout];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
//    NSDictionary* targetAttributeDic = @{
//                                   NSFontAttributeName:@"27"
//                                   };
//    NSString* targetString = [NSString stringWithFormat:@"%ld",_target];
//    NSAttributedString* target = [[NSAttributedString alloc] initWithString:targetString attributes:targetAttributeDic];
//    
//    //@"step"
//    NSDictionary* stepAttributeDic = @{
//                                         NSFontAttributeName:@"13"
//                                         };
//    NSAttributedString* stepString = [[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@"step"] attributes:stepAttributeDic];
//    //拼接
//    NSMutableAttributedString* showedTargetString = [[NSMutableAttributedString alloc] init];
//    [showedTargetString appendAttributedString:target];
//    [showedTargetString appendAttributedString:stepString];
    
//    self.targetValueLabel.attributedText = showedTargetString;
    
 
    self.targetValueLabel.text = [NSString stringWithFormat:@"%ld步",(long)_target];
    NSLog(@"%ld",(long)_target);
    
    self.completedValueLabel.text = [NSString stringWithFormat:@"%ld步",(long)_completed];
    NSLog(@"%ld",(long)_completed);
    
    self.targetValueLabel.font = [UIFont systemFontOfSize:30];
    self.completedValueLabel.font = [UIFont systemFontOfSize:30];

    
 
//    self.progressView.progress = progress;
    
}










@end
