//
//  DataServer.h
//  RunNMB
//
//  Created by 冲锋只需勇气 on 15/9/1.
//  Copyright (c) 2015年 冲锋只需勇气. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^blockType)(id result);


@interface DataServer : NSObject

+ (void)requestWithFullUrlString:(NSString*)urlString
                          params:(NSDictionary*)params
                          method:(NSString*)method
                            data:(NSDictionary*)data
                           block:(blockType)block;
//城市     -- city
//天气     -- weather
//实时温度  -- temp
//风向     -- wind_dir          //result是一个字典，左边是对应参数
//风力     -- wind_sc
//空气质量  -- aqi
//pm2.5    -- pm25

//获取主要天气信息并操作
+ (void)weatherDataWithCityName:(NSString*)cityName block:(blockType)block;


@end
