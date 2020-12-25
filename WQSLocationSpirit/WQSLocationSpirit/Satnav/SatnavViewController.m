//
//  SatnavViewController.m
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/14.
//

#import "SatnavViewController.h"
#import <MapKit/MapKit.h>
#import "CommonConfig.h"
#import "Masonry.h"
#import "CommonMapSettingManager.h"
#import "SearchViewController.h"
#import "UIView+ActivityIndicatorView.h"
#import "WQSAnnotionModel.h"
#import "MKMapView+ZoomLevel.h"

@interface SatnavViewController ()<MKMapViewDelegate>
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIView *navigationBar;
@property (nonatomic, weak) UILabel *startPlace;
@property (nonatomic, weak) UILabel *endPlace;
@property (nonatomic, strong) SearchPlaceModel *startPlaceModel;
@property (nonatomic, strong) SearchPlaceModel *endPlaceModel;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *navButton;
@property (nonatomic, strong) NSMutableArray *overlays;
@property (nonatomic, strong) WQSAnnotionModel *startAnnotionModel;
@property (nonatomic, strong) WQSAnnotionModel *endAnnotionModel;
@end

@implementation SatnavViewController
- (NSMutableArray *)overlays {
    if (nil == _overlays) {
        _overlays = [NSMutableArray array];
    }
    return _overlays;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.startAnnotionModel = WQSAnnotionModel.new;
    self.endAnnotionModel = WQSAnnotionModel.new;
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.navButton];
}

- (UIView *)navigationBar {
    if (nil == _navigationBar) {
        _navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIDeviceScreenWidth, kNavigationBarHeight + 80)];
        _navigationBar.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.6];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"me_back"]
                    forState:UIControlStateNormal];
        [backBtn addTarget:self
                    action:@selector(backAcvtion:)
          forControlEvents:UIControlEventTouchUpInside];
        [_navigationBar addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_navigationBar);
            make.top.mas_equalTo(_navigationBar).offset(kStatusGAP);
            make.size.mas_equalTo(CGSizeMake(kNavigationBarContentHeight, kNavigationBarContentHeight));
        }];
        
        for (NSInteger i = 0; i < 2; i++) {
            UIView *contentView = UIView.new;
            contentView.tag = i;
            contentView.userInteractionEnabled = YES;
            contentView.backgroundColor = [UIColor whiteColor];
            contentView.layer.cornerRadius = 3;
            contentView.layer.masksToBounds = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tapAction:)];
            [contentView addGestureRecognizer:tap];
            [_navigationBar addSubview:contentView];
            if (i == 0) {
                [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(backBtn);
                    make.left.mas_equalTo(backBtn.mas_right);
                    make.right.mas_equalTo(_navigationBar).offset(-kNavigationBarContentHeight);
                    make.height.mas_equalTo(30);
                }];
            } else {
                [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(backBtn.mas_bottom);
                        make.left.mas_equalTo(backBtn.mas_right);
                        make.right.mas_equalTo(_navigationBar).offset(-kNavigationBarContentHeight);
                        make.height.mas_equalTo(30);
                    }];
                }];
            }
            
            UILabel *titleLabel = UILabel.new;
            titleLabel.text = i == 0 ? @"起始位置:" : @"结束位置:";
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.font = [UIFont systemFontOfSize:15];
            [contentView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(contentView);
                make.left.mas_equalTo(contentView).offset(10);
            }];
            
            UILabel *placeLabel = UILabel.new;
            placeLabel.text = i == 0 ? @"请输入起始位置" : @"请输入结束位置";
            i == 0 ? (self.startPlace = placeLabel) : (self.endPlace = placeLabel);
            placeLabel.textColor = [UIColor lightGrayColor];
            placeLabel.font = [UIFont systemFontOfSize:13];
            [contentView addSubview:placeLabel];
            [placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(contentView);
                make.right.mas_equalTo(contentView).offset(-10);
                make.left.mas_equalTo(titleLabel.mas_right).offset(10);
            }];
        }
        
        UIScrollView *typeScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight + 40, UIDeviceScreenWidth, 40)];
        [_navigationBar addSubview:typeScroller];
        
        CGFloat typeBtnWidth = 80;
        CGFloat typeBtnSeperate = 10;
        CGFloat typeBtnHeight = 30;
        NSArray *typeDatas = @[@"驾车",@"步行"];
        for (NSInteger i = 0; i < typeDatas.count; i++) {
            UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            typeBtn.layer.cornerRadius = 15;
            typeBtn.layer.borderWidth = 1.0;
            typeBtn.tag = i + 100;
            typeBtn.layer.borderColor = [[UIColor blueColor] colorWithAlphaComponent:0.6].CGColor;
            [typeBtn setTitle:typeDatas[i] forState:UIControlStateNormal];
            [typeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [typeBtn setBackgroundColor:[UIColor whiteColor]];
            typeBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
            [typeBtn addTarget:self
                        action:@selector(typeSelectAction:)
              forControlEvents:UIControlEventTouchDown];
            typeBtn.frame = CGRectMake(10 + i * (typeBtnWidth + typeBtnSeperate), 5, typeBtnWidth, typeBtnHeight);
            [typeScroller addSubview:typeBtn];
        }
    }
    return _navigationBar;
}

- (MKMapView *)mapView {
    if (nil == _mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight + 80, UIDeviceScreenWidth, UIDeviceScreenHeight - kNavigationBarHeight - 80)];
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
        _mapView.zoomLevel = 10;
        // 是否显示建筑物
        _mapView.showsBuildings = YES;
        _mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
    }
    return _mapView;
}

- (UIButton *)navButton {
    if (nil == _navButton) {
        _navButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _navButton.frame = CGRectMake((UIDeviceScreenWidth - 100) / 2, (UIDeviceScreenHeight - 140), 100, 40);
        _navButton.layer.cornerRadius = 20;
        _navButton.layer.masksToBounds = YES;
        [_navButton setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.6]];
        [_navButton setTitle:@"开始导航" forState:UIControlStateNormal];
        _navButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_navButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
        [_navButton addTarget:self
                        action:@selector(_navAction:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _navButton;
}

- (void)_navAction:(UIButton *)sender {
    UIApplication *application = [UIApplication sharedApplication];
    if (![application canOpenURL:[NSURL URLWithString:@"https://maps.apple.com/"]]) {
        [self.view promptMessage:@"无法打开地图"];
        return;
    }
    MKPlacemark *startPlacemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.startPlaceModel.latitude, self.startPlaceModel.longitude)];
    MKMapItem *startLocation = [[MKMapItem alloc] initWithPlacemark:startPlacemark];
    MKPlacemark *endPlacemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.endPlaceModel.latitude, self.endPlaceModel.longitude)];
    MKMapItem *endLocation = [[MKMapItem alloc] initWithPlacemark:endPlacemark];
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                                    MKLaunchOptionsShowsTrafficKey : @(1)};
    if (self.selectBtn.tag == 101) {
        launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
    }
    [MKMapItem openMapsWithItems:@[startLocation,endLocation] launchOptions:launchOptions];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    NSInteger tag = tap.view.tag;
    
    __weak typeof(self) weakSelf = self;
    SearchViewController *searchVC = [SearchViewController new];
    searchVC.selectLocationComplete = ^(SearchPlaceModel * _Nonnull placeModel) {
        if (tag == 0) {
            weakSelf.startPlaceModel = placeModel;
            weakSelf.startPlace.text = placeModel.address;
        } else {
            weakSelf.endPlaceModel = placeModel;
            weakSelf.endPlace.text = placeModel.address;
        }
        
        [weakSelf mapRequest];
    };
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:searchVC];
    navigation.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)typeSelectAction:(UIButton *)sender {
    if (!self.startPlaceModel) {
        [self.view promptMessage:@"请输入起始位置"];
        return;
    }
    if (!self.endPlaceModel) {
        [self.view promptMessage:@"请输入起始位置"];
        return;
    }
    if (self.selectBtn == sender) {
        return;
    }
    [self.selectBtn setBackgroundColor:[UIColor whiteColor]];
    self.selectBtn.selected = NO;
    self.selectBtn = sender;
    self.selectBtn.selected = YES;
    [self.selectBtn setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.6]];
    [self mapRequest];
}

//苹果原生地图路线规划
- (void)mapRequest {
    if (!self.startPlaceModel || !self.endPlaceModel) {
        return;
    }
    //1.创建方向请求
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.requestsAlternateRoutes = YES;//是否需要多条可用的路线
    switch (self.selectBtn.tag) {
        case 100:
            request.transportType = MKDirectionsTransportTypeAutomobile;
            break;
        case 101:
            request.transportType = MKDirectionsTransportTypeWalking;
            break;
        default:
            break;
    }
    //2.设置起点
    MKPlacemark *startPlace = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.startPlaceModel.latitude, self.startPlaceModel.longitude)];
    request.source = [[MKMapItem alloc] initWithPlacemark:startPlace];
    
    //3.设置终点
    MKPlacemark *endPlace = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.endPlaceModel.latitude, self.endPlaceModel.longitude)];
    request.destination = [[MKMapItem alloc] initWithPlacemark:endPlace];
    
    //4.创建方向对象
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    //5.计算所有路线
    __weak typeof(self) weakSelf = self;
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [weakSelf.view promptMessage:@"搜索失败"];
            return;
        }
        float latitude = weakSelf.startPlaceModel.latitude + (weakSelf.endPlaceModel.latitude - weakSelf.startPlaceModel.latitude);
        float longitude = weakSelf.startPlaceModel.longitude + (weakSelf.endPlaceModel.longitude - weakSelf.startPlaceModel.longitude);
        [weakSelf.mapView setCenterCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
        [weakSelf.mapView removeOverlays:weakSelf.overlays];
        [weakSelf.overlays removeAllObjects];
        for (MKRoute *route in response.routes) {
            [weakSelf.mapView addOverlay:route.polyline];
            [weakSelf.overlays addObject:route.polyline];
        }
        [weakSelf.startAnnotionModel setCoordinate:CLLocationCoordinate2DMake(weakSelf.startPlaceModel.latitude, weakSelf.startPlaceModel.longitude)];
        [weakSelf.endAnnotionModel setCoordinate:CLLocationCoordinate2DMake(weakSelf.endPlaceModel.latitude, weakSelf.endPlaceModel.longitude)];
        weakSelf.startAnnotionModel.name = @"起";
        weakSelf.endAnnotionModel.name = @"终";
        [weakSelf.mapView addAnnotation:weakSelf.startAnnotionModel];
        [weakSelf.mapView addAnnotation:weakSelf.endAnnotionModel];
    }];
}

//线路的绘制
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *renderer;
    renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.lineWidth = 5.0;
    renderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
    return renderer;
}

- (void)backAcvtion:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
}
@end
