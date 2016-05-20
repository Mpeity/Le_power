//
//  MainTabBarController.m
//  RUNwithu
//
//  Created by mty on 15/8/20.
//  Copyright (c) 2015年 mty. All rights reserved.
//

#import "MainTabBarController.h"
#import "FuncView.h"
#import "Commen.h"
#import "UIColor+Wonderful.h"


@interface MainTabBarController ()<UITabBarControllerDelegate>
{
    FuncView *_funcView; // 添加在window上的半透明视图
    NSMutableArray *_items;
    UIImageView *_tabBarView; // 标签栏
    UIImageView *_selectImgView; // 标签栏背景图片
}

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.delegate = self;
    
    _items = [[NSMutableArray alloc] init];
    
    // 添加在window上的view
    [self _addView];
    
    // 创建五个viewController
    [self _createSubVc];
    
    // 创建底部的tabBar
    [self _createTabBarView];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - CreateSubVC 从storyBoard中创建五个viewController

- (void)_createSubVc {
    NSArray *names = @[@"Home",@"Top",@"Run",@"Information",@"More"];
    NSMutableArray *vcArray = [[NSMutableArray alloc] init];
    for (NSString *name in names) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
        UIViewController *vc = [storyboard instantiateInitialViewController];
        [vcArray addObject:vc];
    }
    self.viewControllers = vcArray;
}
#pragma mark - CreateTabBar 创建底部的tabBar
- (void)_createTabBarView {
    // 把原tabBar上的按钮移除    
    for (UIView *view in self.tabBar.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:class]) {
            [view removeFromSuperview];
        }
    }    
    // 创建底部标签视图
    _tabBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth , 49)];
    _tabBarView.userInteractionEnabled = YES;
    [self.tabBar addSubview:_tabBarView];
    
    // 添加背景图片 （未选好）
    _selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/5, 49)];
//    _selectImgView.image = [UIImage imageNamed:@"lanse.jpg"];
    [self.tabBar addSubview:_selectImgView];
    // 底部标签视图 添加5个button
    NSArray *imageNames = @[ @"tabicon_home_notsel",
                             @"tabicon_rank_notsel",
                             @"tab_btn_add_fake",
                             @"tabicon_discovery_notsel",
                             @"tabicon_more_notsel"
                            ];
//    NSArray *selectedImgNames = @[@"tabicon_home_sel",
//                                  @"tabicon_rank_sel",
//                                  @"tabicon_add_sel",
//                                  @"tabicon_discovery_sel",
//                                  @"tabicon_more_sel"];
    
    CGFloat kItemWidth = kScreenWidth/5.0;
    for (int i = 0; i<imageNames.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*kItemWidth+(kItemWidth-40)/2, 4.5, 40, 40)];
//        [button setBackgroundImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:selectedImgNames[i]] forState:UIControlStateSelected];
        button.tag = i;
        [button addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:button];
    }    
}


#pragma mark - 添加在window上的view (第三个页面)
- (void)_addView {
    
    // 在window上添加的半透明view
    _funcView = [[FuncView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-49)];
}


#pragma mark - 复写父类的 setSelectedIndex:(NSUInteger)selectedIndex 方法
-(void)setSelectedIndex:(NSUInteger)selectedIndex {

/****** 在window上添加一个view   然后再添加小view  放三个button
        在 selectedIndex == 2 的时候显示，其余时候隐藏
 */

    if (selectedIndex == 2) {
        
        // 在window上添加的半透明view
        _funcView = [[FuncView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight)];
        _funcView.hidden = NO;
        _funcView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8];
        UIWindow *window =  [UIApplication sharedApplication].keyWindow;
        [window addSubview:_funcView];
        
//        // 将第三个button隐藏
//        UIButton *button = (UIButton *)[self.view viewWithTag:2];
//        button.hidden = YES;
        return;
    } else {
        _funcView.hidden = YES;
        [_funcView removeFromSuperview];
        _funcView = nil;
    }
    [super setSelectedIndex:selectedIndex];
}

#pragma mark - tabBar 上的 button 响应方法
- (void)selectBtnAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.tag == 0 && button.selected) {
    }
    self.selectedIndex = button.tag;
    [UIView animateWithDuration:0.2 animations:^{
        if (button.tag == 2) {
            _selectImgView.hidden = YES;
        } else {
            _selectImgView.hidden = NO;
        }
        _selectImgView.center = button.center;
    }];
}




/*
 //#pragma mark - 自定义TabBar
 //- (void)_createTabBarView {
 //    NSArray *imageNames = @[ @"tabicon_home_notsel",
 //                             @"tabicon_rank_notsel",
 //                             @"tabicon_add_notsel",
 //                             @"tabicon_discovery_notsel",
 //                             @"tabicon_more_notsel"
 //                            ];
 //    NSArray *selectedImgNames = @[@"tabicon_home_sel",
 //                                  @"tabicon_rank_sel",
 //                                  @"tabicon_add_sel",
 //                                  @"tabicon_discovery_sel",
 //                                  @"tabicon_more_sel"];
 //
 ////    NSArray *titles = @[@"首页",@"热门",@"分类",@"个人"];
 //
 //    for (int i = 0; i<imageNames.count; i++) {
 //        // 可以⾃自定义title、图⽚
 //        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:imageNames[i]] tag:i];
 //        //渲染保持原图
 //        tabBarItem.selectedImage = [[UIImage imageNamed:selectedImgNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
 //        //调整image title 位置 如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的 top left bottom right
 //        UIViewController *vc = self.viewControllers[i];
 //        vc.tabBarItem = tabBarItem;
 //
 //
 //    }
 //
 //    self.tabBar.userInteractionEnabled = YES;
 //
 //    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.tabBar.width-self.tabBar.width/5)/2, 0, self.tabBar.width/5, self.tabBar.height)];
 //    button.backgroundColor = [UIColor realgarColor];
 //    [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
 //    [self.tabBar addSubview:button];
 //}
 
 //- (void)btnAction:(UIButton *)button {
 //    if (button.selected) {
 //
 //        // 在window上添加的半透明view
 //        _funcView = [[FuncView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight)];
 //        _funcView.hidden = NO;
 //        _funcView.backgroundColor = [UIColor lightGrayColor];
 //        _funcView.alpha = 0.6;
 //        UIWindow *window =  [UIApplication sharedApplication].keyWindow;
 //        [window addSubview:_funcView];
 //        return;
 //    } else {
 //        _funcView.hidden = YES;
 //        [_funcView removeFromSuperview];
 //        _funcView = nil;
 //    }
 //}
 */












/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
