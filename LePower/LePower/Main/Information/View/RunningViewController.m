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
    
    CLLocation *_currentLocation; // 当前位置
    UIButton *_locationButton;
    
}


@end

@implementation RunningViewController

#pragma mark - 返回按钮
- (void)_createSubview {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor khakiColor]];
}

- (void)backAction {    
    [self dismissViewControllerAnimated:NO completion:nil];
}



#warning 地图有点搞不定
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _createSubview];

    [self initMapView];
    [self funcMapView];
    [self initSearchAPI];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化地图
- (void)initMapView {
    //配置用户Key
    [MAMapServices sharedServices].apiKey = APIKey;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
}

#pragma mark - 地图功能
- (void)funcMapView {
    /** 三种地图类型
     1）普通地图 MAMapTypeStandard；
     2）卫星地图 MAMapTypeSatellite；
     3）夜间地图 MAMapTypeStandardNight；
     */
    _mapView.mapType = MAMapTypeStandard; //选择地图类型
    
    //    _mapView.showTraffic= YES; // 显示实时交通图
    _mapView.showsUserLocation = YES; //YES 为打开定位，NO为关闭定位
    
    /** 定位图层有3种显示模式
     MAUserTrackingModeNone：不跟随用户位置，仅在地图上显示。
     MAUserTrackingModeFollow：跟随用户位置移动，并将定位点设置成地图中心点。
     MAUserTrackingModeFollowWithHeading：跟随用户的位置和角度移动。
     */
    [_mapView setUserTrackingMode: MAUserTrackingModeFollowWithHeading animated:YES]; //地图跟着位置移动
    
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation) {
        //取出当前位置的坐标
//        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        _latitude = userLocation.coordinate.latitude;
        _longitude = userLocation.coordinate.longitude;
        
        NSLog(@"%f %f",_longitude,_latitude); //

    }
}


#pragma mark - 初始化检索对象 
- (void)initSearchAPI {
    [AMapSearchServices sharedServices].apiKey = APIKey;
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:37.332331 longitude:122.031219];
    request.keywords = @"杭州";
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    request.types = @"餐饮服务|生活服务|住宿服务|风景名胜";
    request.sortrule = 0;
    request.requireExtension = YES;
    

    
    //发起周边搜索
    [_search AMapPOIAroundSearch:request];

}

#pragma mark - POI回调函数
//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if(response.pois.count == 0) {
        return;
    }
    //通过 AMapPOISearchResponse 对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld",(long)response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"杭州";
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"搜索失败");
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
