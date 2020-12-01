//
//  ViewController.m
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/1.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mapView];
    
    if ([CLLocationManager locationServicesEnabled]) {
        // 开启定位
        [self.locationManager startUpdatingLocation];
    }else{
        NSLog(@"系统定位尚未打开，请到【设置-隐私-定位服务】中手动打开");
    }
}

-(CLLocationManager *)locationManager{
    if (!_locationManager) {
        // 创建CoreLocation管理对象
        CLLocationManager *locationManager = [[CLLocationManager alloc]init];
        // 定位权限检查
        [locationManager requestWhenInUseAuthorization];
        // 设定定位精准度
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        // 设置代理
        locationManager.delegate = self;
        
        _locationManager = locationManager;
    }
    return _locationManager;
    
}

- (MKMapView *)mapView {
    if (nil == _mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _mapView.mapType = MKMapTypeStandard;
        _mapView.zoomEnabled = YES;
        _mapView.scrollEnabled = YES;
        _mapView.rotateEnabled = NO;
        _mapView.pitchEnabled = NO;
        
        // 是否显示指南针（iOS9.0）
        _mapView.showsCompass = NO;
        // 是否显示比例尺（iOS9.0）
        _mapView.showsScale = YES;
        // 是否显示交通（iOS9.0）
        _mapView.showsTraffic = YES;
        // 是否显示建筑物
        _mapView.showsBuildings = YES;
        
        _mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
        
        _mapView.delegate = self;
        
        _mapView.showsUserLocation = YES;
    }
    return _mapView;
}

// 位置变化时调用，每个位置变化时只调用一次
// 每次调用，都会把用户的最新位置（userLocation参数）传进来
// MKUserLocation: 系统大头针数据模型，内含用户位置
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
}

// 地图的显示区域即将发生改变的时候调用
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
}

// 地图的显示区域已经发生改变的时候调用
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
}

#pragma mark -代理方法，定位权限检查
-(void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager{
//    switch (manager.status) {
//        case kCLAuthorizationStatusNotDetermined:{
//            NSLog(@"用户还未决定授权");
//            // 主动获得授权
//            [self.locationManager requestWhenInUseAuthorization];
//            break;
//        }
//        case kCLAuthorizationStatusRestricted:
//        {
//            NSLog(@"访问受限");
//            // 主动获得授权
//            [self.locationManager requestWhenInUseAuthorization];
//            break;
//        }
//        case kCLAuthorizationStatusDenied:{
//            // 此时使用主动获取方法也不能申请定位权限
//            // 类方法，判断是否开启定位服务
//            if ([CLLocationManager locationServicesEnabled]) {
//                NSLog(@"定位服务开启，被拒绝");
//            } else {
//                NSLog(@"定位服务关闭，不可用");
//            }
//            break;
//        }
//        case kCLAuthorizationStatusAuthorizedAlways:{
//            NSLog(@"获得前后台授权");
//            break;
//        }
//        case kCLAuthorizationStatusAuthorizedWhenInUse:{
//            NSLog(@"获得前台授权");
//            break;
//        }
//        default:
//            break;
//    }
}
#pragma mark -获取位置
- (void)locationManager:(CLLocationManager *)manager
   didUpdateLocations:(NSArray *)locations{
    
    CLLocation * newLocation = [locations lastObject];
    // 判空处理
    if (newLocation.horizontalAccuracy < 0) {
        NSLog(@"定位失败，请检查手机网络以及定位");
        return;
    }
    //停止定位
    [self.locationManager stopUpdatingLocation];
    // 获取定位经纬度
//    CLLocationCoordinate2D coor2D = newLocation.coordinate;
//    NSLog(@"纬度为:%f, 经度为:%f", coor2D.latitude, coor2D.longitude);
    
    // 创建编码对象，获取所在城市
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    // 反地理编码
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error != nil || placemarks.count == 0) {
            return ;
        }
        // 获取地标
        CLPlacemark *placeMark = [placemarks firstObject];
//        NSLog(@"获取地标 = %@,",placeMark.locality);
    }];
   
}
#pragma mark -定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
//     NSLog(@"定位失败,请检查手机网络以及定位");
}
@end
