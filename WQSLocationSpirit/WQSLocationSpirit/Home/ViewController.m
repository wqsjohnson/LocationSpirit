//
//  ViewController.m
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/1.
//

#import "ViewController.h"
#import "CommonConfig.h"
#import "Masonry.h"
//ctrl
#import "SettingViewController.h"
#import "LocationViewController.h"
#import "GPSViewController.h"
#import "SatnavViewController.h"
//model
#import "CommonMapSettingManager.h"
//category
#import "UIView+ActivityIndicatorView.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initUI];
    
    id mapType = [[NSUserDefaults standardUserDefaults] objectForKey:@"MapType"];
    if (mapType) {
        CommonMapSettingManager.manager.type = [mapType integerValue];
    }
}

- (void)_initUI {
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView *bgImageView = UIImageView.new;
    bgImageView.image = [UIImage imageNamed:@"home_bg"];
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self.view);
    }];
    
    //标题
    UILabel *titleLabel = UILabel.new;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"定位精灵";
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(15);
        make.top.mas_equalTo(self.view).offset(kNavigationBarHeight);
    }];
    
    //副标题
    UILabel *detailLabel = UILabel.new;
    detailLabel.textColor = [UIColor lightGrayColor];
    detailLabel.text = @"系统定位助手";
    detailLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [self.view addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
    }];
    
    //右边设置按钮
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setImage:[UIImage imageNamed:@"chat_setup"]
                forState:UIControlStateNormal];
    [self.view addSubview:settingBtn];
    [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLabel);
        make.right.mas_equalTo(self.view).offset(-15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [settingBtn addTarget:self
                   action:@selector(toSetting:)
         forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *datas = @[@{@"img":@"",@"title":@"路线规划",@"detail":@"最优路线推荐"},
                       @{@"img":@"",@"title":@"经纬度移动",@"detail":@"输入经纬度，精准位移"},
                       @{@"img":@"",@"title":@"自由编辑定位",@"detail":@"拖动位置，搜索地标，轻松定位"}];
    for (NSInteger i = 0; i < datas.count; i++) {
        UIView *contentView = UIView.new;
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 10.0;
        contentView.userInteractionEnabled = YES;
        contentView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tapAction:)];
        [contentView addGestureRecognizer:tap];
        [self.view addSubview:contentView];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(15);
            make.right.mas_equalTo(self.view).offset(-15);
            make.height.mas_equalTo(120);
            make.bottom.mas_equalTo(self.view).offset(-(i * (135) + 50));
        }];
        
        //图片
        UIImageView *typeImageView = UIImageView.new;
        typeImageView.image = [UIImage imageNamed:datas[i][@"img"]];
        [contentView addSubview:typeImageView];
        [typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(contentView);
            make.left.mas_equalTo(contentView).offset(20);
            make.size.mas_equalTo(CGSizeMake(90, 90));
        }];
    
        UIView *rightContentView = UIView.new;
        [contentView addSubview:rightContentView];
        [rightContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(contentView);
            make.left.mas_equalTo(typeImageView).offset(20);
            make.right.mas_equalTo(contentView).offset(-50);
        }];
        
        //标题
        UILabel *titleLabel = UILabel.new;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = datas[i][@"title"];
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        [rightContentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(rightContentView);
        }];
        
        //副标题
        UILabel *detailLabel = UILabel.new;
        detailLabel.textColor = [UIColor lightGrayColor];
        detailLabel.text = datas[i][@"detail"];
        detailLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        [rightContentView addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(rightContentView);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(5);
        }];
        
        //图片
        UIImageView *rightArrowImageView = UIImageView.new;
        rightArrowImageView.image = [UIImage imageNamed:@"login_record_arrow"];
        [contentView addSubview:rightArrowImageView];
        [rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(contentView);
            make.right.mas_equalTo(contentView).offset(-20);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    UIView *view = tap.view;
    switch (view.tag) {
        case 0:
            //自由编辑定位
            [self _toSatnav];
            break;
        case 1:
            //经纬度移动
            [self _toGPS];
            break;
        case 2:
            //路线规划
            [self _toLocation];
            break;
        default:
            break;
    }
}

- (void)_toLocation {
    LocationViewController *locationVC = LocationViewController.new;
    [self.navigationController pushViewController:locationVC
                                         animated:YES];
}

- (void)_toGPS {
    [self.view promptMessage:@"功能暂未开放"];
//    GPSViewController *gpsVC = GPSViewController.new;
//    [self.navigationController pushViewController:gpsVC
//                                         animated:YES];
}

- (void)_toSatnav {
    SatnavViewController *satnavVC = SatnavViewController.new;
    [self.navigationController pushViewController:satnavVC
                                         animated:YES];
}

- (void)toSetting:(UIButton *)sender {
    SettingViewController *settingCtrl = SettingViewController.new;
    [self.navigationController pushViewController:settingCtrl
                                         animated:YES];
}
@end
