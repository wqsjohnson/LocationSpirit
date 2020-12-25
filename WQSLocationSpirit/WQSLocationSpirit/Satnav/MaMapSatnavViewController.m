//
//  MaMapSatnavViewController.m
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/17.
//

#import "MaMapSatnavViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "CommonConfig.h"
#import "Masonry.h"
#import "CommonMapSettingManager.h"
#import "SearchViewController.h"
#import "UIView+ActivityIndicatorView.h"
#import "WQSAnnotionModel.h"
@interface MaMapSatnavViewController ()<MAMapViewDelegate,AMapSearchDelegate>
@property (nonatomic, strong) MAMapView *maMapView;
@property (nonatomic, strong) AMapSearchAPI *aMapSearch;
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

@implementation MaMapSatnavViewController
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
    [self.view addSubview:self.maMapView];
    [self.view addSubview:self.navButton];
    self.aMapSearch = [[AMapSearchAPI alloc] init];
    self.aMapSearch.delegate = self;
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
        NSArray *typeDatas = @[@"驾车",@"步行",@"骑行"];
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

- (MAMapView *)maMapView {
    if (nil == _maMapView) {
        _maMapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight + 80, UIDeviceScreenWidth, UIDeviceScreenHeight - kNavigationBarHeight - 80)];
        _maMapView.zoomLevel = 10;
        _maMapView.delegate = self;
    }
    return _maMapView;
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
    if (![application canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        [self.view promptMessage:@"请安装高德地图"];
        return;
    }
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,@"WQSLocationSpirit",self.endPlaceModel.latitude, self.endPlaceModel.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [application openURL:[NSURL URLWithString:urlString]
                 options:@{}
       completionHandler:^(BOOL success) {
    }];
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
        
        [weakSelf _startRouteSearch];
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
    [self _startRouteSearch];
}

- (void)_startRouteSearch {
    if (!self.startPlaceModel || !self.endPlaceModel) {
        return;
    }
    switch (self.selectBtn.tag) {
        case 100:
            [self _drivingRouteSearch];
            break;
        case 101:
            [self _walkRouteSearch];
            break;
        case 102:
            [self _rideRouteSearch];
            break;
        default:
            break;
    }
}

//高德驾车路线规划
- (void)_drivingRouteSearch {
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    navi.requireExtension = YES;
    navi.strategy = 5;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startPlaceModel.latitude
                                           longitude:self.startPlaceModel.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.endPlaceModel.latitude
                                                longitude:self.endPlaceModel.longitude];
    [self.aMapSearch AMapDrivingRouteSearch:navi];
}

//高德步行路线规划
- (void)_walkRouteSearch {
    AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startPlaceModel.latitude
                                           longitude:self.startPlaceModel.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.endPlaceModel.latitude
                                                longitude:self.endPlaceModel.longitude];
    [self.aMapSearch AMapWalkingRouteSearch:navi];
}

//高德骑行路线规划
- (void)_rideRouteSearch {
    AMapRidingRouteSearchRequest *navi = [[AMapRidingRouteSearchRequest alloc] init];
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startPlaceModel.latitude
                                           longitude:self.startPlaceModel.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.endPlaceModel.latitude
                                                longitude:self.endPlaceModel.longitude];
    [self.aMapSearch AMapRidingRouteSearch:navi];
}

-(void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    if ([views[0] isKindOfClass:MAPinAnnotationView.class]){
        MAPinAnnotationView *mapView = (MAPinAnnotationView*)views[0];
        [self.maMapView selectAnnotation:mapView.annotation
                                animated:NO];
    }
}

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request
                 response:(AMapRouteSearchResponse *)response {
    if (response.route == nil) {
        return;
    }
    if (response.route.paths.count == 0) {
        [self.view promptMessage:@"未搜索出有效路线"];
        return;
    }
    float latitude = self.startPlaceModel.latitude + (self.endPlaceModel.latitude - self.startPlaceModel.latitude);
    float longitude = self.startPlaceModel.longitude + (self.endPlaceModel.longitude - self.startPlaceModel.longitude);
    [self.maMapView setCenterCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
    //移除旧折线对象
    [self.maMapView removeOverlays:self.overlays];
    [self.overlays removeAllObjects];
    //移除旧的开始和结束点
    [self.maMapView removeAnnotation:self.startAnnotionModel];
    [self.maMapView removeAnnotation:self.endAnnotionModel];
    //构造折线对象
    MAPolyline *polyline = [self polylinesForPath:response.route.paths[0]];
    [self.overlays addObject:polyline];
    //添加新的遮盖，然后会触发代理方法(- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay)进行绘制
    [self.maMapView addOverlay:polyline];
    [self.startAnnotionModel setCoordinate:CLLocationCoordinate2DMake(self.startPlaceModel.latitude, self.startPlaceModel.longitude)];
    [self.endAnnotionModel setCoordinate:CLLocationCoordinate2DMake(self.endPlaceModel.latitude, self.endPlaceModel.longitude)];
    self.startAnnotionModel.name = @"起";
    self.endAnnotionModel.name = @"终";
    [self.maMapView addAnnotation:self.startAnnotionModel];
    [self.maMapView addAnnotation:self.endAnnotionModel];
}

//路线解析
- (MAPolyline *)polylinesForPath:(AMapPath *)path{
    if (path == nil || path.steps.count == 0){
        return nil;
    }
    NSMutableString *polylineMutableString = [@"" mutableCopy];
    for (AMapStep *step in path.steps) {
        [polylineMutableString appendFormat:@"%@;",step.polyline];
    }
    
    NSUInteger count = 0;
    CLLocationCoordinate2D *coordinates = [self coordinatesForString:polylineMutableString
                                                     coordinateCount:&count
                                                          parseToken:@";"];
    
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
    
    (void)(free(coordinates)), coordinates = NULL;
    return polyline;
}

//解析经纬度
- (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token{
    if (string == nil){
        return NULL;
    }
    
    if (token == nil){
        token = @",";
    }
    
    NSString *str = @"";
    if (![token isEqualToString:@","]){
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }else{
        str = [NSString stringWithString:string];
    }
    
    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count] / 2;
    if (coordinateCount != NULL){
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < count; i++){
        coordinates[i].longitude = [[components objectAtIndex:2 * i]     doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }
    return coordinates;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]]){
        MAPolyline *polyline = (MAPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:polyline];
            
        //添加纹理图片
        //若设置了纹理图片，设置线颜色、连接类型和端点类型将无效。
        polylineRenderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineRenderer.lineJoin = kCGLineJoinRound;
        polylineRenderer.lineCap  = kCGLineCapRound;
        polylineRenderer.lineWidth = 5.0;
            
        return polylineRenderer;
    }
    return nil;
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    [self.view promptMessage:@"搜索失败"];
}

- (void)backAcvtion:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
