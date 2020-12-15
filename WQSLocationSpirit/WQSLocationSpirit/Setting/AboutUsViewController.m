//
//  AboutUsViewController.m
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/15.
//

#import "AboutUsViewController.h"
#import "CommonConfig.h"
#import "Masonry.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initUI];
}

- (void)_initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIDeviceScreenWidth, kNavigationBarHeight)];
    navigationBar.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.6];
    [self.view addSubview:navigationBar];
    
    UILabel *titleLabel = UILabel.new;
    titleLabel.text = @"关于";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [navigationBar addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(navigationBar);
        make.top.mas_equalTo(navigationBar).offset(kStatusGAP);
        make.height.mas_equalTo(kNavigationBarContentHeight);
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"me_back"]
                forState:UIControlStateNormal];
    [navigationBar addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navigationBar).offset(kStatusGAP);
        make.left.mas_equalTo(navigationBar);
        make.size.mas_equalTo(CGSizeMake(kNavigationBarContentHeight, kNavigationBarContentHeight));
    }];
    [backBtn addTarget:self
                action:@selector(backAcvtion:)
      forControlEvents:UIControlEventTouchUpInside];
}

- (void)backAcvtion:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
