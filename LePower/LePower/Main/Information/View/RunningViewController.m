//
//  RunningViewController.m
//  RUNwithu
//
//  Created by mty on 15/9/7.
//  Copyright (c) 2015年 mty. All rights reserved.
//

#import "RunningViewController.h"
#import "DataServer.h"
#import "Commen.h"
#import "UIColor+Wonderful.h"


@interface RunningViewController ()<MAMapViewDelegate,AMapSearchDelegate>
{
    MAMapView *_mapView;
    CLLocationManager * locationManager;
    AMapSearchAPI *_search;
    
    CLLocationDegrees _latitude; //
    CLLocationDegrees _longitude; //
    
}

@end

@implementation RunningViewController

#pragma mark - 返回按钮
- (void)_createSubview {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor doderBlue] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)buttonAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _createSubview];
    
    
    locationManager =[[CLLocationManager alloc] init];
    
    // fix ios8 location issue
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
#ifdef __IPHONE_8_0
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [locationManager performSelector:@selector(requestAlwaysAuthorization)];//用这个方法，plist中需要NSLocationAlwaysUsageDescription
        }
        
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [locationManager performSelector:@selector(requestWhenInUseAuthorization)];//用这个方法，plist里要加字段NSLocationWhenInUseUsageDescription
        }
#endif
    }
    
    
//    [self _createAlertView];
//    _latitude = [CLLocationDegrees alloc] 

    [self showMap];
    
    //配置用户Key
    [MAMapServices sharedServices].apiKey = APIKey;
    
    _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
    
    _mapView.showTraffic= YES; // 打开交通
    
    _mapView.showsCompass= YES; // 设置成NO表示关闭指南针；YES表示显示指南针
    _mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 22); //设置指南针位置
    
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    
    [self _searchCloud];
    
    
//    _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
//    
//    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 大头针标注

// 在viewDidAppear方法中添加如下所示代码添加标注数据对象。
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(_latitude, _longitude);
    pointAnnotation.title = @"当前位置";
    pointAnnotation.subtitle = @"当前位置====";
    [_mapView addAnnotation:pointAnnotation];
}
////实现 <MAMapViewDelegate> 协议中的 mapView:viewForAnnotation:回调函数，设置标注样式。
//- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
//    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
//        static NSString *pointReuseIndentfier = @"pointReuseIndentfier";
//        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentfier];
//        if (annotation == nil) {
//            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentfier];
//        }
//        annotationView.canShowCallout = YES; // 设置气泡可以动弹，默认为NO；
//        annotationView.animatesDrop = YES; // 设置标注动画显示，默认为NO；
//        annotationView.draggable = YES; // 设置标注可以拖动，默认NO;
//        annotationView.pinColor = MAPinAnnotationColorRed; // 设置大头针的颜色
//        return annotationView;
//    }
//    return nil;
//}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    /* 自定义userLocation对应的annotationView. */
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"userPosition"];
        
        return annotationView;
    }
    return nil;
}


#pragma mark - 显示地图
- (void)showMap {
    //配置用户Key
    [MAMapServices sharedServices].apiKey = APIKey;
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    
//    3D矢量地图SDK提供三种地图类型 MAMapTypeStandard、MAMapTypeSatellite 和 MAMapTypeStandardNight；
//    
//    2D栅格地图SDK提供两种地图类型 MAMapTypeStandard 和 MAMapTypeSatellite。
//    
//    其中：MAMapTypeStandard为标准地图（即：3D为矢量地图，2D为栅格地图），MAMapTypeSatellite为卫星地图，MAMapTypeStandardNight为夜景地图。
    
//    _mapView.showTraffic= YES; // 显示实时交通
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    /* 自定义定位精度对应的MACircleView. */
    if (overlay == mapView.userLocationAccuracyCircle)
    {
        MACircleView *accuracyCircleView = [[MACircleView alloc] initWithCircle:overlay];
        
        accuracyCircleView.lineWidth    = 2.f;
        accuracyCircleView.strokeColor  = [UIColor lightGrayColor];
        accuracyCircleView.fillColor    = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
        
        return accuracyCircleView;
    }
    return nil;
}


#pragma mark - 开启定位后回调
// 开启定位后的回调
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
        // 取出当前位置的经纬度
//        _latitude = userLocation.coordinate.latitude;
//        _longitude = userLocation.coordinate.longitude;
    }
}

#pragma mark - 提示开启GPS导航
- (void)_createAlertView {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未打开GPS" message:@"此功能需打开GPS" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"去打开", nil];
    
    [alertView show];
    
    [self.view addSubview:alertView];
}


#pragma mark - 进行本地检索

- (void)_searchCloud {
    //配置用户Key
    [AMapSearchServices sharedServices].apiKey = APIKey;
    
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //构造AMapGeocodeSearchRequest对象，address为必选项，city为可选项
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = @"西单";
    
    //发起正向地理编码
    [_search AMapGeocodeSearch: geo];
}
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response {
    if (response.geocodes.count == 0) {
        return;
    }
    //
    NSString *strCount = [NSString stringWithFormat:@"count:%ld",response.count];
    NSString *strGeocodes = @"";
    for (AMapTip *p in response.geocodes) {
        
        strGeocodes = [NSString stringWithFormat:@"%@\ngeocode: %@", strGeocodes, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@", strCount, strGeocodes];
    NSLog(@"Geocode:%@",result);
}




/*
 
 显示地图标注 步骤
 
 1、定义遵循（MKAnnotation协议）Annotation类
 
 2、创建Annotation对象，把对象添加到MapView上
 
 3、实现MapView的协议方法，创建标注视图
 
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
