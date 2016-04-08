 //
//  MoreViewController.m
//  RUNwithu
//
//  Created by mty on 15/8/20.
//  Copyright (c) 2015年 mty. All rights reserved.
//

#import "MoreViewController.h"
#import "UIColor+Wonderful.h"
#import "Commen.h"
#import "UIViewExt.h"
#import "UserCell.h"
#import "SetViewController.h"


@interface MoreViewController ()

@end

@implementation MoreViewController{

    
    UIImageView *_headerImageView;
    UIImageView *_iconImageView;
    UILabel *_userNameLabel;
    UILabel *_heightLabel;
    UILabel *_weightLabel;
    UILabel *_BMILabel;
    UILabel *_targetLabel;
    UILabel *_heightDataLabel;
    UILabel *_weightDataLabel;
    UILabel *_BMIDataLabel;
    UILabel *_targetDataLabel;
    UIButton *_setButton;
    UIButton *_logInBtn;
    
    UIView *_funView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _createCollectionView];
    [self _createHeaderView];
    [self _createLabel];
    [self _createDataLabel];
    
    NSUserDefaults *defualts1 = [NSUserDefaults standardUserDefaults];
    if ([[defualts1 objectForKey:PersonInfo] objectForKey:@"heightData"] && [[defualts1 objectForKey:PersonInfo] objectForKey:@"weightData"]) {
        _weightDataLabel.text = [NSString stringWithFormat:@"%@ kg",[[[defualts1 objectForKey:PersonInfo] objectForKey:@"weightData"] stringValue]];
        _heightDataLabel.text = [NSString stringWithFormat:@"%@ cm",[[[defualts1 objectForKey:PersonInfo] objectForKey:@"heightData"] stringValue]];
    }
    NSUserDefaults *defualts2 = [NSUserDefaults standardUserDefaults];
    if ([[defualts2 objectForKey:CountData] objectForKey:@"stepCount"]) {
        _targetDataLabel.text = [NSString stringWithFormat:@"%@ 步",[[defualts2 objectForKey:CountData] objectForKey:@"stepCount"]];
    }
    NSUserDefaults *defualts3 = [NSUserDefaults standardUserDefaults];
    if ([[defualts3 objectForKey:@"BMIDic"] objectForKey:@"BMIData"]) {
        _BMIDataLabel.text = [[defualts3 objectForKey:@"BMIDic"] objectForKey:@"BMIData"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)_createCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(kScreenWidth/2, kScreenWidth*5/8);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor skyBlue];
    [_collectionView registerNib:[UINib nibWithNibName:@"UserCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:_collectionView];
    
}



#pragma mark - 创建子视图
- (void)_createHeaderView{
    
    //01 头部数据
    _funView = [[UIView alloc] initWithFrame:CGRectMake(0, 160, kScreenWidth, 40)];
    
    //自动布局，自适应顶部，顶部空间是变动的，底部对齐父视图
    _funView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -200, kScreenWidth, 200)];
    //自适应宽高比
//    [_headerImageView setImage:[UIImage imageNamed:@"headImage.jpg"]];
    _headerImageView.image = [UIImage imageNamed:@"蓝色.jpg"];
    _headerImageView.contentMode = UIViewContentModeScaleToFill;

    [_headerImageView addSubview:_funView];
    [_collectionView addSubview:_headerImageView];
    _collectionView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    _collectionView.contentOffset = CGPointMake(0, -200);

    
    _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-30, 30, 60, 30)];
    _userNameLabel.text = @"用户id";
    _userNameLabel.highlighted = YES;
    _userNameLabel.textColor = [UIColor whiteColor];
    [_headerImageView addSubview:_userNameLabel];
    
    _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-40, 70, 80, 80)];
    _iconImageView.userInteractionEnabled = YES;
    _iconImageView.image = [UIImage imageNamed:@"iconImage.jpg"];
    _iconImageView.layer.cornerRadius = 40;
    _iconImageView.layer.borderWidth = 1;
    _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconImageView.layer.masksToBounds = YES;
    
    _logInBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [_iconImageView addSubview:_logInBtn];
    [_logInBtn addTarget:self action:@selector(logInBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //_headerImageView.bottom = _collectionView.top;
    [_headerImageView addSubview:_iconImageView];
    
    // more_setting    go_setting
    _setButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 25, 40, 40)];
    [_setButton addTarget:self action:@selector(setButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_setButton setImage:[UIImage imageNamed:@"go_setting"] forState:UIControlStateNormal];
    [self.view addSubview:_setButton];
}

// 设置按钮响应方法
- (void)setButtonAction:(UIButton *)button {
    SetViewController *vc = [[SetViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:NO completion:nil];
}

// 登录按钮方法
- (void)logInBtnAction:(UIButton *)button {
    
}

- (void)_createLabel{
    _heightLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,0,80,20)];
    _heightLabel.text = @"身高";
    _heightLabel.textAlignment = NSTextAlignmentCenter;
    _heightLabel.font = [UIFont systemFontOfSize:15];
    _heightLabel.textColor = [UIColor blackColor];
    [_funView addSubview:_heightLabel];
    
    _weightLabel = [[UILabel alloc]initWithFrame:CGRectMake(110,0,80,20)];
    _weightLabel.text = @"体重";
    _weightLabel.textAlignment = NSTextAlignmentCenter;
    _weightLabel.font = [UIFont systemFontOfSize:15];
    _weightLabel.textColor = [UIColor blackColor];
    [_funView addSubview:_weightLabel];
    
    _BMILabel = [[UILabel alloc]initWithFrame:CGRectMake(200,0,80,20)];
    _BMILabel.text = @"BMI";
    _BMILabel.textAlignment = NSTextAlignmentCenter;
    _BMILabel.font = [UIFont systemFontOfSize:15];
    _BMILabel.textColor = [UIColor blackColor];
    [_funView addSubview:_BMILabel];
    
    _targetLabel = [[UILabel alloc]initWithFrame:CGRectMake(295,0,80,20)];
    _targetLabel.text = @"目标";
    _targetLabel.textAlignment = NSTextAlignmentCenter;
    _targetLabel.font = [UIFont systemFontOfSize:15];
    _targetLabel.textColor = [UIColor blackColor];
    [_funView addSubview:_targetLabel];
    
}
- (void)_createDataLabel{
    _heightDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,15,80,20)];
//    _heightDataLabel.text = @"175cm";
    _heightDataLabel.textAlignment = NSTextAlignmentCenter;
    _heightDataLabel.font = [UIFont systemFontOfSize:15];
    _heightDataLabel.textColor = [UIColor blackColor];
    [_funView addSubview:_heightDataLabel];
    
    _weightDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(110,15,80,20)];
//    _weightDataLabel.text = @"72kg";
    _weightDataLabel.textAlignment = NSTextAlignmentCenter;
    _weightDataLabel.font = [UIFont systemFontOfSize:15];
    _weightDataLabel.textColor = [UIColor blackColor];
    [_funView addSubview:_weightDataLabel];
    
    

    _BMIDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(200,15,80,20)];
//    _BMIDataLabel.text = @"23.5";
    _BMIDataLabel.textAlignment = NSTextAlignmentCenter;
    _BMIDataLabel.font = [UIFont systemFontOfSize:15];
    _BMIDataLabel.textColor = [UIColor blackColor];
    [_funView addSubview:_BMIDataLabel];

    
    _targetDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(295,15,80,20)];
//    _targetDataLabel.text = @"10000步";
    _targetDataLabel.textAlignment = NSTextAlignmentCenter;
    _targetDataLabel.font = [UIFont systemFontOfSize:15];
    _targetDataLabel.textColor = [UIColor blackColor];
    [_funView addSubview:_targetDataLabel];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat y = scrollView.contentOffset.y;
    NSLog(@"%f",y);
    if (y < -200) {//向下
        CGFloat distance = ABS(y)-200; //向下拉动距离
        _headerImageView.top = -200-distance;
        _headerImageView.height = 200+distance;
        
        _iconImageView.top = 70+distance/2;
        _userNameLabel.top = 30+distance/2;

    }

}



#pragma mark - CollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    // disable_daka   disable_leijijuli  disable_lijidabiao  disable_zuigaobushu
    if (indexPath.row == 0) {
        cell.viewImage.image = [UIImage imageNamed:@"disable_daka"];
        cell.targetInform.text = @"最长连续打卡";
        cell.nextTarget.text = @"下一个目标 3天";
        cell.target.text = @"0天";
    } else if (indexPath.row == 1) {
        cell.viewImage.image = [UIImage imageNamed:@"disable_zuigaobushu"];
        cell.targetInform.text = @"单日最好成绩";
        cell.nextTarget.text = @"下一个目标 5000步";
        cell.target.text = @"0步";

    } else if (indexPath.row == 2) {
        cell.viewImage.image = [UIImage imageNamed:@"disable_leijijuli"];
        cell.targetInform.text = @"步行累计";
        cell.nextTarget.text = @"下一个目标 10公里";
        cell.target.text = @"0.0公里";

    } else {
        cell.viewImage.image = [UIImage imageNamed:@"disable_lijidabiao"];
        cell.targetInform.text = @"累计达标";
        cell.nextTarget.text = @"下一个目标 3天";
        cell.target.text = @"0天";
    }
    
//    cell.target.text = [NSString stringWithFormat:@"kkkk"];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}




@end
