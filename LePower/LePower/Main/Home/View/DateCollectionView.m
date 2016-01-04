//
//  DateCollectionView.m
//  RUNwithu
//
//  Created by 冲锋只需勇气 on 15/9/6.
//  Copyright (c) 2015年 mty. All rights reserved.
//

#import "DateCollectionView.h"


@implementation DateCollectionView

static NSString* cellId = @"DateCollectionViewCell";


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor colorWithRed:0 green:0.7 blue:1 alpha:0.7];
        [self registerClass:[DateViewCell class] forCellWithReuseIdentifier:cellId];
        
    }
    
    return self;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 14;
}





- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DateViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    
    cell.dateLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
