//
//  UserCell.m
//  RUNwithu
//
//  Created by 揽揽揽 on 15/9/8.
//  Copyright (c) 2015年 mty. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

- (void)awakeFromNib {
    
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.targetInform.textAlignment = NSTextAlignmentCenter;
    self.target.textAlignment = NSTextAlignmentCenter;
    self.nextTarget.textAlignment = NSTextAlignmentCenter;
    self.nextTarget.textColor = [UIColor lightGrayColor];
}

@end
