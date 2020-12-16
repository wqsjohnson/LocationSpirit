//
//  SatnavViewController.m
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/14.
//

#import "SatnavViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <MapKit/MapKit.h>
#import "CommonConfig.h"
#import "Masonry.h"
#import "CommonMapSettingManager.h"
#import "SearchViewController.h"

@interface SatnavViewController ()<MKMapViewDelegate,MAMapViewDelegate>
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) MAMapView *maMapView;
@property (nonatomic, strong) UIView *navigationBar;
@property (nonatomic, weak) UILabel *startPlace;
@property (nonatomic, weak) UILabel *endPlace;
@property (nonatomic, strong) UIButton *selectBtn;
@end

@implementation SatnavViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationBar];
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(kNavigationBarHeight + 80);
    }];
    if (CommonMapSettingManager.manager.type == LocationViewControllerTypeSysMap) {
        [self.view addSubview:self.mapView];
    } else {
        [self.view addSubview:self.maMapView];
    }
}

- (UIView *)navigationBar {
    if (nil == _navigationBar) {
        _navigationBar = UIView.new;
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
        
        CGFloat typeBtnWidth = 40;
        CGFloat typeBtnSeperate = 10;
        CGFloat typeBtnHeight = 30;
        NSArray *typeDatas = @[@"驾车",@"步行",@"公交",@"骑行"];
        for (NSInteger i = 0; i < typeDatas.count; i++) {
            UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            typeBtn.layer.cornerRadius = 15;
            typeBtn.layer.borderWidth = 1.0;
            typeBtn.tag = i + 100;
            typeBtn.layer.borderColor = [[UIColor blueColor] colorWithAlphaComponent:0.6].CGColor;
            [typeBtn setTitle:typeDatas[i] forState:UIControlStateNormal];
            [typeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [typeBtn setBackgroundColor:[UIColor whiteColor]];
            typeBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
            [typeBtn addTarget:self
                        action:@selector(typeSelectAction:)
              forControlEvents:UIControlEventTouchDown];
            typeScroller.frame = CGRectMake(10 + i * (typeBtnWidth + typeBtnSeperate), 5, typeBtnWidth, typeBtnHeight);
            if (i == 0) {
                [typeBtn setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.6]];
                self.selectBtn = typeBtn;
            }
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

- (void)tapAction:(UITapGestureRecognizer *)tap {
    NSInteger tag = tap.view.tag;
    
    __weak typeof(self) weakSelf = self;
    SearchViewController *searchVC = [SearchViewController new];
    searchVC.selectLocationComplete = ^(CLLocationCoordinate2D locationCoordinate) {
        if (tag == 0) {
            weakSelf.startPlace.text = @"";
        } else {
            weakSelf.endPlace.text = @"";
        }
    };
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:searchVC];
    navigation.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)typeSelectAction:(UIButton *)sender {
    if (self.selectBtn == sender) {
        return;
    }
    [self.selectBtn setBackgroundColor:[UIColor whiteColor]];
    self.selectBtn = sender;
    [self.selectBtn setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.6]];
}

- (void)backAcvtion:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
}
@end
