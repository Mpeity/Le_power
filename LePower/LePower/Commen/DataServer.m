//
//  DataServer.m
//  RunNMB
//
//  Created by 冲锋只需勇气 on 15/9/1.
//  Copyright (c) 2015年 冲锋只需勇气. All rights reserved.
//

#import "DataServer.h"
#define weatherAPI @"http://apis.baidu.com/heweather/weather/free"
#define weatherAPIKey @"02e39a6cc76cd891fea44fe0ccf6aa85"

@implementation DataServer
+ (void)requestWithFullUrlString:(NSString *)urlString    //url
                          params:(NSDictionary *)params  //requestBody
                          method:(NSString *)method     //方法
                            data:(NSDictionary *)data  //requestHeader
                           block:(blockType)block{
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    
    NSString* fullString = [[NSString alloc] init];
    if(data != nil){
        NSArray* allKeyArray = [data allKeys];
        NSMutableString* dataString = [[NSMutableString alloc] init];
        
        //params requestBody参数写入
        for (int i = 0; i < [allKeyArray count]; i++) {
            
            [dataString appendFormat:@"%@=%@",allKeyArray[i],[data valueForKey:allKeyArray[i]]];
            
            if (i < [allKeyArray count] -1) {
                [dataString appendString:@"&"];
            }
        }
        
        NSString* preString = url.query?@"&":@"?";
        fullString = [NSString stringWithFormat:@"%@%@%@",urlString,preString,dataString];
    }else{
        fullString = urlString;
    }
    
    //创建request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullString]];
    
    //设置请求头
    NSArray* requestHTTPBodyKey = [params allKeys];
    for (NSString* key in requestHTTPBodyKey) {
        
        NSString* value = [params valueForKey:key];
        [request addValue:value forHTTPHeaderField:key];
    }
    

    //创建operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    //结果处理
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"数据下载成功");
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError* error){
        NSLog(@"数据下载失败");
    }];

    //operation加入队列
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

+ (void)weatherDataWithCityName:(NSString *)cityName block:(blockType)block{
    
    NSString* utf8String = [cityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //header
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue:weatherAPIKey forKey:@"apikey"];
    
    //body
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    [data setValue:utf8String forKey:@"city"];
    
    NSMutableDictionary* resultDic = [[NSMutableDictionary alloc] init];
    [DataServer requestWithFullUrlString:weatherAPI params:params method:@"GET" data:data block:^(id result) {
        
        NSArray* dataArray = [result valueForKey:@"HeWeather data service 3.0"];
        NSDictionary* dataDic = dataArray[0];
        
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"ok"]) {
            NSDictionary* now = [dataDic valueForKey:@"now"];
            NSDictionary* cond = [now valueForKey:@"cond"];
            NSDictionary* wind = [now valueForKey:@"wind"];
            NSDictionary* aqi = [dataDic valueForKey:@"aqi"];
            if ([aqi valueForKey:@"city"]) {
                NSDictionary* cityAqi = [aqi valueForKey:@"city"];
                [resultDic setValue:[cityAqi valueForKey:@"aqi"] forKey:@"aqi"];   //空气质量指数
                [resultDic setValue:[cityAqi valueForKey:@"pm25"] forKey:@"pm25"]; //pm2.5
            }else{
                [resultDic setValue:@"此城市无空气数据" forKey:@"aqi"];   //部分城市没有这两项数据
                [resultDic setValue:@"此城市无空气数据" forKey:@"pm25"];
            }
            [resultDic setValue:cityName forKey:@"city"];                           //城市
            [resultDic setValue:[cond valueForKey:@"txt"] forKey:@"weather"]; //天气情况
            [resultDic setValue:[now valueForKey:@"tmp"] forKey:@"temp"];       //实时温度
            [resultDic setValue:[wind valueForKey:@"dir"] forKey:@"wind_dir"];  //风向
            [resultDic setValue:[wind valueForKey:@"sc"] forKey:@"wind_sc"];    //风力
            block(resultDic);
        }
    }];
    
    
}





@end
