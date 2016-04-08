//
//  MainCollectionView.h
//  RUNwithu
//
//  Created by 冲锋只需勇气 on 15/9/8.
//  Copyright (c) 2015年 mty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCollectionViewCell.h"


@interface MainCollectionView : UICollectionView<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    NSInteger count;
}


@end
