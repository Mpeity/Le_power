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


@interface MainTabBarController ()
{
    FuncView *_funcView; // 添加在window上的半透明视图

}

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // 创建五个viewController
    [self _createSubVc];
    
    // 创建底部的tabBar
    [self _createTabBarView];
    
    // 添加在window上的view
    [self _addView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - CreateSubVC 从storyBoard中创建五个viewController

- (void)_createSubVc {
    
    NSArray *names = @[@"Home",@"Top",@"Information",@"Run",@"More"];
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
    _selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
    _selectImgView.image = [UIImage imageNamed:@""];
    [self.tabBar addSubview:_selectImgView];
    
    // 底部标签视图 添加5个button
    NSArray *imageNames = @[ @"tabbar_home_highlighted@2x",
                             @"tabbar_discover_highlighted@2x",
                             @"tabbar_compose_background_icon_add@2x",
                             @"tabbar_profile_highlighted@2x",
                             @"tabbar_more_highlighted@2x"
                            ];
    
    CGFloat kItemWidth = kScreenWidth/5.0;
    for (int i = 0; i<imageNames.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*kItemWidth, 0, kItemWidth, 49)];
        [button setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
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
        _funcView.backgroundColor = [UIColor lightGrayColor];
        _funcView.alpha = 0.6;
        UIWindow *window =  [UIApplication sharedApplication].keyWindow;
        [window addSubview:_funcView];
        return;
    }
    else {
        _funcView.hidden = YES;
        [_funcView removeFromSuperview];
        _funcView = nil;
    }
    [super setSelectedIndex:selectedIndex];
    
}

#pragma mark - tabBar 上的 button 响应方法
- (void)selectBtnAction:(UIButton *)button {
    
    self.selectedIndex = button.tag;
    [UIView animateWithDuration:0.2 animations:^{
        _selectImgView.center = button.center;
    }];
}















/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
