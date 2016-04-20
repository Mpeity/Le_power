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

#define LocationTimeout 3  //   定位超时时间，可修改，最小2s
#define ReGeocodeTimeout 3 //   逆地理请求超时时间，可修改，最小2s

@interface RunningViewController ()<MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>
{
    MAMapView *_mapView;
    CLLocationManager * locationManager;
    AMapSearchAPI *_search;
    
    CLLocationDegrees _latitude; //
    CLLocationDegrees _longitude; //
    
    CLLocation *_currentLocation; // 当前位置
    UIButton *_locationButton;
    
    NSMutableArray *_mutableArray; //
    
}

//@property (nonatomic ,strong) MAMapView * mapView;
@property (nonatomic ,strong) AMapSearchAPI * mapSearchAPI;
//@property (nonatomic ,strong) MAUserLocation * currentLocation;
@property (nonatomic ,strong) NSMutableDictionary * userLocationDict;

@property (nonatomic,strong) AMapGeocode *geocode; // 地理编码
@property (nonatomic,strong) AMapReGeocode *reGeocode; //反地理编码

@end

@implementation RunningViewController


#warning 地图有点搞不定
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mutableArray = [[NSMutableArray alloc] init];
    
    _currentLocation = [[CLLocation alloc] init];
    
    [self _createSubview];

    [self initMapView];
//    [self initLocation];
    [self initPolylines];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 返回按钮
- (void)_createSubview {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor khakiColor]];
}

- (void)backAction {
    [self dismissViewControllerAnimated:NO completion:nil];
}



#pragma mark - 初始化地图
- (void)initMapView {
    //配置用户Key
    [MAMapServices sharedServices].apiKey = APIKey;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    // 定位button
    UIButton *locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, kScreenWidth-100, 50, 50)];
    locationBtn.backgroundColor = [UIColor blackColor];
    [locationBtn addTarget:self action:@selector(locationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:locationBtn];
    
    
    /** 三种地图类型
     1）普通地图 MAMapTypeStandard；
     2）卫星地图 MAMapTypeSatellite；
     3）夜间地图 MAMapTypeStandardNight；
     */
    _mapView.mapType = MAMapTypeStandard; //选择地图类型
    
    //    _mapView.showTraffic= YES; // 显示实时交通图
    _mapView.showsUserLocation = NO; //YES 为打开定位，NO为关闭定位
    
    /** 定位图层有3种显示模式
     MAUserTrackingModeNone：不跟随用户位置，仅在地图上显示。
     MAUserTrackingModeFollow：跟随用户位置移动，并将定位点设置成地图中心点。
     MAUserTrackingModeFollowWithHeading：跟随用户的位置和角度移动。
     */
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
}

//
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation) {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}

- (void)locationBtnAction:(UIButton *)button {
    [self initLocation];
    
    [self initSearchWithLocation:_currentLocation];

}


#pragma mark -
- (void)initSearchWithLocation:(CLLocation *)location {
    //配置用户Key
    [AMapSearchServices sharedServices].apiKey = APIKey;
    
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //构造AMapReGeocodeSearchRequest对象
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
//    regeo.location = [AMapGeoPoint locationWithLatitude:30.2478170000     longitude:120.2142810000];
    regeo.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude     longitude:_currentLocation.coordinate.longitude];
    
    regeo.radius = 10000;
    regeo.requireExtension = YES;
    
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeo];
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        NSLog(@"ReGeo: %@", result);
        [_mutableArray addObject:response.regeocode];
    }
}

#pragma mark - 定位方法
- (void)initLocation {
    [AMapLocationServices sharedServices].apiKey = APIKey;
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
//    [self.locationManager startUpdatingLocation]; //开启持续定位
    
    
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
        //   定位超时时间，可修改，最小2s
    //    self.locationManager.locationTimeout = 3;
    //    //   逆地理请求超时时间，可修改，最小2s
    //    self.locationManager.reGeocodeTimeout = 3;
    
        // 带逆地理（返回坐标和地址信息）
        [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
    
            if (error)
            {
                NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    
                if (error.code == AMapLocationErrorLocateFailed)  // AMapLocatingErrorLocateFailed
                {
                    return;
                }
            }
            NSLog(@"location:%@", location);
            _currentLocation = location;
    
            if (regeocode)
            {
                NSLog(@"reGeocode:%@", regeocode);
            }
        }];
    
    
}

/**
 *  当定位发生错误时，会调用代理的此方法。
 *
 *  @param manager 定位 AMapLocationManager 类。
 *  @param error 返回的错误，参考 CLError 。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@",error.localizedDescription);
}


///**
// *  连续定位回调函数
// *
// *  @param manager 定位 AMapLocationManager 类。
// *  @param location 定位结果。
// */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
}

#pragma mark - 构造折线方法
- (void)initPolylines {
    //构造折线数据对象
    CLLocationCoordinate2D commonPolylineCoords[4];
    commonPolylineCoords[0].latitude = 39.832136;
    commonPolylineCoords[0].longitude = 116.34095;
    
    commonPolylineCoords[1].latitude = 39.832136;
    commonPolylineCoords[1].longitude = 116.42095;
    
    commonPolylineCoords[2].latitude = 39.902136;
    commonPolylineCoords[2].longitude = 116.42095;
    
    commonPolylineCoords[3].latitude = 39.902136;
    commonPolylineCoords[3].longitude = 116.44095;
    
    //构造折线对象
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:4];
    
    //在地图上添加折线对象
    [_mapView addOverlay: commonPolyline];
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 10.f;
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
        polylineView.lineJoinType = kMALineJoinRound;//连接类型
        polylineView.lineCapType = kMALineCapRound;//端点类型
        
        return polylineView;
    }
    return nil;
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
