//
//  EditViewController.m
//  RUNwithu
//
//  Created by mty on 15/9/8.
//  Copyright (c) 2015年 mty. All rights reserved.
//

#import "EditBtnViewController.h"
#import "Commen.h"
#import "UIColor+Wonderful.h"

@interface EditBtnViewController ()<UITextFieldDelegate>
{
    NSMutableArray *_strArray1;
    NSMutableArray *_strArray2;
    NSString *_str1;
    NSString *_str2;
    NSMutableDictionary *_dic;
    NSString *_value; //
}

@end

@implementation EditBtnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor beigeColor];
    [self _addData];
    [self _createSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 创建视图
- (void)_createSubviews {
    
    // 创建pickerView
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, kScreenWidth, 200)];
    _pickerView.backgroundColor = [UIColor clearColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self.view addSubview:_pickerView];
    
    // 创建取消视图以及确定视图
    _deletionOrcompletionView = [[UIView alloc] initWithFrame:CGRectMake(0, 450, kScreenWidth, 100)];
    [self.view addSubview:_deletionOrcompletionView];
    
    // 取消按钮
    _deletionBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth/2-20, 100)];
    [_deletionBtn setTitle:@"取消" forState:UIControlStateNormal];
    _deletionBtn.backgroundColor = [UIColor peachRed];
    [_deletionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_deletionBtn addTarget:self action:@selector(deletionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_deletionOrcompletionView addSubview:_deletionBtn];
   
    // 确定按钮
    _completionBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2-10, 100)];
    [_completionBtn setTitle:@"完成" forState:UIControlStateNormal];
    _completionBtn.backgroundColor = [UIColor peachRed];
    [_completionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_completionBtn addTarget:self action:@selector(completionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_deletionOrcompletionView addSubview:_completionBtn];
    
}

#pragma mark - 添加数据
- (void)_addData {
    _dic = [[NSMutableDictionary alloc] init];
    _str1 = [[NSString alloc] init];
    _str2 = [[NSString alloc] init];
    _strArray1 = [[NSMutableArray alloc] init];
    _strArray2 = [[NSMutableArray alloc] init];
    for (int i = 25; i<206; i++) {
        NSString *str = [NSString stringWithFormat:@"%i",i];
        [_strArray1 addObject:str];
    }
    for (int j = 0; j<10; j++) {
        NSString *str = [NSString stringWithFormat:@".%i Kg",j];
        [_strArray2 addObject:str];
    }
}

#pragma mark - button 响应方法

// 取消按钮
- (void)deletionBtnAction:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 确定按钮
- (void)completionBtnAction:(UIButton *)button {
    [[NSNotificationCenter defaultCenter] postNotificationName:DataChangeNotification object:self userInfo:_dic];
    [self.navigationController popViewControllerAnimated:NO];
    
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-200)/2, 300, 200, 40)];
//    view1.backgroundColor = [UIColor lavender];
//    [window addSubview:view1];
//    view1.hidden = YES;
//    [UIView animateKeyframesWithDuration:100 delay:1 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
//        view1.hidden = NO;
//    } completion:^(BOOL finished) {
//        view1.hidden = YES;
//    }];
//    
}

// 移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UIPickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 181;
    }
    else {
        return 10;
    }
}

//返回显⽰的文本
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [_strArray1 objectAtIndex:row];
    }
    else {
        return [_strArray2 objectAtIndex:row];
    }
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
        if (component == 0) {
            _str1 = [_strArray1 objectAtIndex:row];
        }
        else {
            _str2 = [_strArray2 objectAtIndex:row];
        }
    _value = [NSString stringWithFormat:@"%@%@",_str1,_str2];
    [_dic setValue:_value forKey:DataChange];
    NSLog(@"%@",_dic);

}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//    UILabel *lab;
//    if (view) {
//        
//        lab = (UILabel *)view;
//    }
//    else {
//        lab = [[UILabel alloc] init];
//        lab.text = [_mutableArray objectAtIndex:row];
//        lab.backgroundColor = [UIColor paleTurquoise];
//        [lab sizeToFit];
//    }
//    return lab;
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
