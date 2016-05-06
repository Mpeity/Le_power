//
//  YSMapViewController.m
//  LePower
//
//  Created by nick_beibei on 16/5/6.
//  Copyright © 2016年 nick_beibei. All rights reserved.
//

#import "YSMapViewController.h"

@interface YSMapViewController ()<CLLocationManagerDelegate>
{
    NSMutableArray *_locations;
    
    CLLocationManager *locationMgr;
    
    NSInteger noUpdates;
    
    MKMapRect _routeRect;
}

@property (nonatomic,strong) MKMapView *mkMapView;

@property (nonatomic,strong) MKPolyline *routeLine;
@property (nonatomic,strong) MKPolylineView *routeLineView;

@end

@implementation YSMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    noUpdates = 0;
    _locations = [[NSMutableArray alloc] init];
    
    self.mkMapView = [[MKMapView alloc] init];
    _mkMapView.showsUserLocation = YES;

     [self.view addSubview:_mkMapView];
    
    locationMgr = [[CLLocationManager alloc] init];
    locationMgr.delegate = self;
    locationMgr.desiredAccuracy =kCLLocationAccuracyBest;
    locationMgr.distanceFilter  = 1.0f;
    [locationMgr startUpdatingLocation];
    
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    noUpdates++;
    
    [_locations addObject: [NSString stringWithFormat:@"%f,%f",[newLocation coordinate].latitude, [newLocation coordinate].longitude]];
    
//    [self updateLocation];
    if (self.routeLine!=nil) {
        self.routeLine =nil;
    }
    if(self.routeLine!=nil)
        [self.mkMapView removeOverlay:self.routeLine];
    self.routeLine =nil;
    // create the overlay
    [self loadRoute];
    
    // add the overlay to the map
    if (nil != self.routeLine) {
        [self.mkMapView addOverlay:self.routeLine];
    }
    
    // zoom in on the route.
//    [self zoomInOnRoute];
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id )overlay
{
    MKOverlayView* overlayView = nil;
    
    if(overlay == self.routeLine)
    {
        //if we have not yet created an overlay view for this overlay, create it now.
        if(nil == self.routeLineView)
        {
            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
            self.routeLineView.fillColor = [UIColor redColor];
            self.routeLineView.strokeColor = [UIColor redColor];
            self.routeLineView.lineWidth = 3;
        }
        
        overlayView = self.routeLineView;
        
    }
    
    return overlayView;
    
}

-(void) loadRoute
{
    
    
    // while we create the route points, we will also be calculating the bounding box of our route
    // so we can easily zoom in on it.
    MKMapPoint northEastPoint;
    MKMapPoint southWestPoint;
    
    // create a c array of points.
    MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * _locations.count);
    for(int idx = 0; idx < _locations.count; idx++)
    {
        // break the string down even further to latitude and longitude fields.
        NSString* currentPointString = [_locations objectAtIndex:idx];
        NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        
        CLLocationDegrees latitude  = [[latLonArr objectAtIndex:0] doubleValue];
        CLLocationDegrees longitude = [[latLonArr objectAtIndex:1] doubleValue];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
        
        
        if (idx == 0) {
            northEastPoint = point;
            southWestPoint = point;
        }
        else
        {
            if (point.x > northEastPoint.x)
                northEastPoint.x = point.x;
            if(point.y > northEastPoint.y)
                northEastPoint.y = point.y;
            if (point.x < southWestPoint.x)
                southWestPoint.x = point.x;
            if (point.y < southWestPoint.y)
                southWestPoint.y = point.y;
        }
        
        pointArr[idx] = point;
        
    }
    
    self.routeLine = [MKPolyline polylineWithPoints:pointArr count:_locations.count];
    
    _routeRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, northEastPoint.x - southWestPoint.x, northEastPoint.y - southWestPoint.y);
    
    free(pointArr);
    
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
