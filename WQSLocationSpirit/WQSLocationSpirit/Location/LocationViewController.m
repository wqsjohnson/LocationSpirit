//
//  LocationViewController.m
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/14.
//

#import "LocationViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <MapKit/MapKit.h>
#import "CommonConfig.h"
#import "CommonMapSettingManager.h"
//ctrl
#import "SearchViewController.h"
//model
#import "WQSAnnotionModel.h"
@interface LocationViewController ()<MKMapViewDelegate,MAMapViewDelegate>
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) MAMapView *maMapView;
@property (nonatomic, strong) UIView *navigationBar;
@property (nonatomic, strong) WQSAnnotionModel *annotionModel;
@property (nonatomic, strong) UIButton *sureButton;
@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navigationBar];
    self.annotionModel = WQSAnnotionModel.new;
    if (CommonMapSettingManager.manager.type == LocationViewControllerTypeSysMap) {
        [self.view addSubview:self.mapView];
        [self.mapView addAnnotation:self.annotionModel];
        [self.annotionModel setCoordinate:self.mapView.centerCoordinate];
    } else {
        [self.view addSubview:self.maMapView];
        [self.maMapView addAnnotation:self.annotionModel];
        [self.annotionModel setCoordinate:self.maMapView.centerCoordinate];
    }
    [self.view addSubview:self.sureButton];
}

- (UIView *)navigationBar {
    if (nil == _navigationBar) {
        _navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIDeviceScreenWidth, kNavigationBarHeight)];
        _navigationBar.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.6];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, kStatusGAP, kNavigationBarContentHeight, kNavigationBarContentHeight);
        [backBtn setImage:[UIImage imageNamed:@"me_back"]
                    forState:UIControlStateNormal];
        [_navigationBar addSubview:backBtn];
        [backBtn addTarget:self
                    action:@selector(backAcvtion:)
          forControlEvents:UIControlEventTouchUpInside];
        
        UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(kNavigationBarContentHeight, kStatusGAP + (kNavigationBarContentHeight - 30) / 2.0, UIDeviceScreenWidth - kNavigationBarContentHeight * 2, 30)];
        searchView.userInteractionEnabled = YES;
        searchView.backgroundColor = [UIColor whiteColor];
        searchView.layer.cornerRadius = 15;
        searchView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchAction)];
        [searchView addGestureRecognizer:tap];
        [_navigationBar addSubview:searchView];
        
        UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 15, 15)];
        searchImageView.image = [UIImage imageNamed:@"search"];
        [searchView addSubview:searchImageView];
        
        UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, searchView.frame.size.width - 40, 30)];
        searchLabel.text = @"输入地名进行搜索";
        searchLabel.textColor = [UIColor lightGrayColor];
        searchLabel.font = [UIFont systemFontOfSize:13];
        [searchView addSubview:searchLabel];
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

- (MAMapView *)maMapView {
    if (nil == _maMapView) {
        _maMapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, UIDeviceScreenWidth, UIDeviceScreenHeight - kNavigationBarHeight)];
        _maMapView.delegate = self;
    }
    return _maMapView;
}

- (UIButton *)sureButton {
    if (nil == _sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake((UIDeviceScreenWidth - 100) / 2, (UIDeviceScreenHeight - 140), 100, 40);
        _sureButton.layer.cornerRadius = 20;
        _sureButton.layer.masksToBounds = YES;
        [_sureButton setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.6]];
        [_sureButton setTitle:@"开始设置" forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_sureButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
        [_sureButton addTarget:self
                        action:@selector(sureAction:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (void)backAcvtion:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sureAction:(UIButton *)btn {
    
}

- (void)searchAction {
    __weak typeof(self) weakSelf = self;
    SearchViewController *searchVC = [SearchViewController new];
    searchVC.selectLocationComplete = ^(SearchPlaceModel * _Nonnull placeModel) {
        if (CommonMapSettingManager.manager.type == LocationViewControllerTypeSysMap) {
            [weakSelf.mapView setCenterCoordinate:CLLocationCoordinate2DMake(placeModel.latitude, placeModel.longitude) animated:NO];
        } else {
            [weakSelf.maMapView setCenterCoordinate:CLLocationCoordinate2DMake(placeModel.latitude, placeModel.longitude) animated:NO];
        }
    };
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:searchVC];
    navigation.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)_showSureBtn {
    
}

- (void)_hideSureBtn {
    
}

// MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self.annotionModel setCoordinate:mapView.region.center];
}
@end
