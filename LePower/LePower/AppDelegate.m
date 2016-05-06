//
//  AppDelegate.m
//  LePower
//
//  Created by nick_beibei on 16/1/4.
//  Copyright © 2016年 nick_beibei. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "Commen.h"
#import "Commen.h"
#import "GuideViewController.h"
#import "DataServer.h"
#import "GuideView.h"
#import "SOLocationManager.h"
#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI/BMKMapView.h>


@interface AppDelegate ()<BMKGeneralDelegate>
//{
//    BMKMapManager *_mapManager;
//}
@property (nonatomic,strong) BMKMapManager *mapManager;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[MainTabBarController alloc] init];
    //    self.window.rootViewController = [[GuideViewController alloc] init];
    
    //        GuideView *guideView = [[GuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];

    
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound
                                                                                    categories:nil]];
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]) {
        UILocalNotification *note = [UILocalNotification new];
        note.alertBody = @"App has been launched by reason of significant location update";
        note.soundName = UILocalNotificationDefaultSoundName;
        [application presentLocalNotificationNow:note];
    }
    
    [[SOLocationManager sharedInstance] startSignificant];
    

    


    

    
    

    
    /**
     *  思路一(1)判断 沙盒有没有某个文件a
     如果有 则不是第一次
     如果没有 则是第一次
     思路二 根据文件中的某个值来判断是否是第一次启动
     
     */
    BOOL notFirst = YES;
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/firstStart.plist"];    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSNumber *number = [dic objectForKey:@"notFirst"];
    notFirst = [number boolValue];
    if (!notFirst) {//第一次
        NSDictionary *dic = @{@"notFirst":@YES};
        [dic writeToFile:filePath atomically:YES];
        
        GuideView *guideView = [[GuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        [self.window addSubview:guideView];
//        GuideViewController *vc = [[GuideViewController alloc] init];
//        [self.window setRootViewController:vc];
        [self.window.rootViewController.view addSubview:guideView];
        //创建某个文件a
        
    }
    else{
        MainTabBarController *vc = [[MainTabBarController alloc] init];
        [self.window setRootViewController:vc];
    }
    
    // 要使用百度地图先实例化 BMKMapManager
//    self.mapManager = [[BMKMapManager alloc]init];
    
    // 如果要关注网络及授权验证事件，请设定 generalDelegate 参数
//        [_mapManager start:BaiDuAPIKey generalDelegate:self];
    
//    BOOL ret = [_mapManager start:@"OjYbYha0YULmuLPaHT9wgMcA" generalDelegate:self];
//    if (!ret) {
//        NSLog(@"manager start failed");
//    }
    
//    // 向微信注册
    [WXApi registerApp:WXAppID withDescription:@"Wechat"];
//    [self sendAuthRequest];
//    [self logIn];
    
    return YES;
}
- (void)onGetNetworkState:(int)iError

{
    
    if (0 == iError) {
        
        NSLog(@"联网成功");
        
    }
    
    else{
        
        NSLog(@"onGetNetworkState %d",iError);
        
    }
    
    
    
}



- (void)onGetPermissionState:(int)iError

{
    
    if (0 == iError) {
        
        NSLog(@"授权成功");
        
    }
    
    else {
        
        NSLog(@"onGetPermissionState %d",iError);
        
    }
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}


#pragma mark - 微信登录
-(void)sendAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
    

}


- (void)logIn {
    //    https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    NSString *urlString = @"https://api.weixin.qq.com/sns/oauth2/access_token?";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *appid = WXAppID;
    NSString *secret = WXAppSecret;
    NSString *code = @"CODE";
    NSString *grant_type = @"authorization_code";
    [params setObject:appid forKey:@"appid"];
    [params setObject:secret forKey:@"secret"];
    [params setObject:code forKey:@"code"];
    [params setObject:grant_type forKey:@"grant_type"];
    
    [DataServer requestWithFullUrlString:urlString params:params method:@"GET" data:nil block:^(id result) {
        
        NSLog(@"%@",result);
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
