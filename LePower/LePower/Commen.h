//
//  Commen.h
//  RUNwithu
//
//  Created by mty on 15/8/20.
//  Copyright (c) 2015年 mty. All rights reserved.
//

#ifndef RUNwithu_Commen_h
#define RUNwithu_Commen_h



#define kVersion [[UIDevice currentDevice].systemVersion floatValue]

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#import "UIViewExt.h"

// 运动列表
#define ActivityTypeList @"ActivityTypeList.plist"


/* 使用高德地图API，请注册Key，注册地址：http://lbs.amap.com/console/key */
#define APIKey @"8b37b0cecf4b6ae96ab5934f6d6116a5"


// 百度地图 信息
//#define BaiDuAPIKey @"8y6GYygGFUbKBoY5XIYw0nO0"
//App ID：7378129
//Api Key：8y6GYygGFUbKBoY5XIYw0nO0
//Secret Key： uvloQTXSQlf3tpu2yCNK4t1y5SH6GW54
//访问密匙（AK） UM8GYxrnYn8v3vKgt2rI3LSU

// 微信SDK信息
//AppID：wx5d8a7cafde5441d1
//AppSecret：90fd2104acacbc2c9006ca63c4ecdf71
#define WXAppID @"wx5d8a7cafde5441d1"
#define WXAppSecret @"90fd2104acacbc2c9006ca63c4ecdf71"

#define PersonInfo @"personInfo" // 个人身高体重出生年份数据
#define CountData @"countData" //步数记录

#define SexValue @"sexValue"  // 性别
#define SexValueNotification @"sexValueNotification" // 性别通知
#define WeightValue @"weightValue" // 体重
#define WeightValueNotification @"weightValueNotification" // 体重通知
#define HeightValue @"heightValue" // 身高
#define HeightValueNotification @"HeightValueNotification" // 身高通知

#define DataChange @"dataChange" // 体重改变
#define DataChangeNotification @"dataChangeNotification" // 体重改变通知






#endif
