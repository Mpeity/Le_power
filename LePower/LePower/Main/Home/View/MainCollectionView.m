//
//  MainCollectionView.m
//  RUNwithu
//
//  Created by 冲锋只需勇气 on 15/9/8.
//  Copyright (c) 2015年 mty. All rights reserved.
//

#import "MainCollectionView.h"

@implementation MainCollectionView

static NSString* cellId = @"MainCollectionViewCell";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.delegate = self;
        self.dataSource = self;
        self.pagingEnabled = YES;
        
        UINib* nib = [UINib nibWithNibName:@"MainCollectionViewCell" bundle:nil];
        [self registerNib:nib forCellWithReuseIdentifier:cellId];
//        [self registerClass:[MainCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return 14;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MainCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    NSLog(@"%ld,item = %ld",indexPath.section,indexPath.item);
    
    
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
