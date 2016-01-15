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
    
    NSMutableArray *_mutableArray;
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
    _mutableArray = [[NSMutableArray alloc] init];
    _strArray1 = [[NSMutableArray alloc] init];
    _strArray2 = [[NSMutableArray alloc] init];
//    for (int i = 25; i<206; i++) {
//        NSString *str = [NSString stringWithFormat:@"%i",i];
//        [_mutableArray addObject:str];
////        NSLog(@"%@",_mutableArray[i]);
//        for (int j = 0; j<10; j++) {
//            
//            NSString *str = [NSString stringWithFormat:@".%i Kg",j];
//            [_mutableArray addObject:str];
//        }
//    }
//    _mutableArray = [NSMutableArray arrayWithObjects:_strArray1,_strArray2, nil];
    
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
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"体重添加成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self.navigationController presentViewController:alertController animated:NO completion:^{
        [UIView animateWithDuration:10 animations:^{
            [alertController dismissViewControllerAnimated:nil completion:nil];
        }];
    }];
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
    
//    _strArray1 = [[NSMutableArray alloc] init];
//    NSMutableArray *strArray2 = [[NSMutableArray alloc] init];
//    if (component == 0) {
//        for (int i = 25; i<206; i++) {
//            NSString *str = [NSString stringWithFormat:@"%i",i];
//            [strArray1 addObject:str];
//        }
//        return [strArray1 objectAtIndex:row];
//    }
//    else {
//        for (int i = 0; i<10; i++) {
//            NSString *str = [NSString stringWithFormat:@".%i  Kg",i];
//            [strArray2 addObject:str];
//        }
//        return [strArray2 objectAtIndex:row];
//    }
    
    if (component == 0) {
//        NSArray *array = [_mutableArray objectAtIndex:0];
        return [_strArray1 objectAtIndex:row];
    }
    else {
//        NSArray *array = [_mutableArray objectAtIndex:1];
        return [_strArray2 objectAtIndex:row];
    }
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 50;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
//    这个pickerView是在pickerViewController这个UIViewController中。
//    
//    ／／获取选中的列中的所在的行
//    
//    NSInteger row=[_pickerViewController.pickerView selectedRowInComponent:0];
//    
//    ／／然后是获取这个行中的值，就是数组中的值
//    
//    NSString *value=[_pickerViewController.array objectAtIndex:row];
    
    if (component == 0) {
        
        NSString *str = [_strArray1 objectAtIndex:row];
        
        NSString *value = [NSString stringWithFormat:@""];
    }
    else {
        
    }
    
    
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataChange" object:self userInfo:dic];
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
