//
//  ViewController.m
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/1.
//

#import "ViewController.h"
#import "CommonConfig.h"
#import <MapKit/MapKit.h>
#import "SearchViewController.h"
#import "WQSAnnotionModel.h"

@interface ViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UIView *navigationBar;
@property (nonatomic, strong) WQSAnnotionModel *annotionModel;
@property (nonatomic, strong) UIButton *sureButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.mapView];
    self.annotionModel = WQSAnnotionModel.new;
    [self.mapView addAnnotation:self.annotionModel];
    [self.view addSubview:self.sureButton];
    
    if ([CLLocationManager locationServicesEnabled]) {
        // 开启定位
        [self.locationManager startUpdatingLocation];
    }
}

-(CLLocationManager *)locationManager{
    if (!_locationManager) {
        // 创建CoreLocation管理对象
        _locationManager = [[CLLocationManager alloc]init];
        // 定位权限检查
        [_locationManager requestWhenInUseAuthorization];
        // 设定定位精准度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        // 设置代理
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (UIView *)navigationBar {
    if (nil == _navigationBar) {
        _navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIDeviceScreenWidth, kNavigationBarHeight)];
        _navigationBar.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchAction)];
        [_navigationBar addGestureRecognizer:tap];
        _navigationBar.backgroundColor = [UIColor whiteColor];
    }
    return _navigationBar;
}

- (MKMapView *)mapView {
    if (nil == _mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, UIDeviceScreenWidth, UIDeviceScreenHeight - kNavigationBarHeight)];
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

- (UIButton *)sureButton {
    if (nil == _sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake((UIDeviceScreenWidth - 100) / 2, (UIDeviceScreenHeight - 140), 100, 40);
        _sureButton.layer.cornerRadius = 20;
        _sureButton.layer.masksToBounds = YES;
        [_sureButton setBackgroundColor:[UIColor purpleColor]];
        [_sureButton setTitle:@"设定" forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_sureButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
        [_sureButton addTarget:self
                        action:@selector(sureAction:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (void)sureAction:(UIButton *)btn {
    
}

- (void)searchAction {
    SearchViewController *searchVC = [SearchViewController new];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:searchVC];
    navigation.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navigation animated:YES completion:nil];
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
    [self.annotionModel setCoordinate:mapView.region.center];
}

#pragma mark -代理方法，定位权限检查
-(void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager{
    switch (manager.authorizationStatus) {
        case kCLAuthorizationStatusNotDetermined:{
            NSLog(@"用户还未决定授权");
            // 主动获得授权
            [self.locationManager requestWhenInUseAuthorization];
            break;
        }
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"访问受限");
            // 主动获得授权
            [self.locationManager requestWhenInUseAuthorization];
            break;
        }
        case kCLAuthorizationStatusDenied:{
            // 此时使用主动获取方法也不能申请定位权限
            // 类方法，判断是否开启定位服务
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"定位服务开启，被拒绝");
            } else {
                NSLog(@"定位服务关闭，不可用");
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:{
            NSLog(@"获得前后台授权");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:{
            NSLog(@"获得前台授权");
            break;
        }
        default:
            break;
    }
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
    [self.annotionModel setCoordinate:newLocation.coordinate];
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
        //CLPlacemark *placeMark = [placemarks firstObject];
//        NSLog(@"获取地标 = %@,",placeMark.locality);
    }];
   
}
#pragma mark -定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
//     NSLog(@"定位失败,请检查手机网络以及定位");
}
@end
