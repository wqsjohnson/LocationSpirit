//
//  SettingViewController.m
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/14.
//

#import "SettingViewController.h"
#import "AboutUsViewController.h"
#import "CommonMapSettingManager.h"
#import "CommonConfig.h"
#import "Masonry.h"

@interface SettingCell : UITableViewCell
@property (nonatomic, strong) UIImageView *rightArrowImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UISwitch *rightSwitch;
@end

@implementation SettingCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _initUI];
    }
    return self;
}

- (void)_initUI {
    self.rightArrowImageView = UIImageView.new;
    self.rightArrowImageView.image = [UIImage imageNamed:@"setting_right"];
    [self.contentView addSubview:self.rightArrowImageView];
    [self.rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-20);
    }];
    
    self.titleLabel = UILabel.new;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(20);
    }];
    
    self.detailLabel = UILabel.new;
    self.detailLabel.font = [UIFont systemFontOfSize:15];
    self.detailLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.rightArrowImageView.mas_left).offset(-5);
    }];
    
    self.rightSwitch = UISwitch.new;
    [self.contentView addSubview:self.rightSwitch];
    [self.rightSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-20);
    }];
    
    UIView *line = UIView.new;
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

@end

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SettingViewController

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
    titleLabel.text = @"设置";
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
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(kNavigationBarHeight);
    }];
}

- (void)backAcvtion:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableView {
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark UITableViewDelegate, UITableViewDataSource;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = [NSString stringWithFormat:@"cellID_%@", NSStringFromClass([self class])];
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellID];
    }
    
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"地图选择";
        cell.detailLabel.text = CommonMapSettingManager.manager.type == LocationViewControllerTypeSysMap ? @"内置地图 " : @"高德地图";
        cell.rightArrowImageView.hidden = NO;
        cell.rightSwitch.hidden = YES;
        cell.detailLabel.hidden = NO;
    } else if (indexPath.row == 1) {
        cell.titleLabel.text = @"透传模式";
        cell.rightArrowImageView.hidden = YES;
        cell.rightSwitch.hidden = NO;
        cell.detailLabel.hidden = YES;
    } else {
        cell.titleLabel.text = @"关于我们";
        cell.rightArrowImageView.hidden = NO;
        cell.rightSwitch.hidden = YES;
        cell.detailLabel.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择"
                                                                                 message:@"选择地图"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
            
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
            if (CommonMapSettingManager.manager.type == LocationViewControllerTypeAMap) {
                return;
            }
            CommonMapSettingManager.manager.type = LocationViewControllerTypeAMap;
            [weakSelf.tableView reloadData];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"内置地图"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
            if (CommonMapSettingManager.manager.type == LocationViewControllerTypeSysMap) {
                return;
            }
            CommonMapSettingManager.manager.type = LocationViewControllerTypeSysMap;
            [weakSelf.tableView reloadData];
        }]];

        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
    } else if (indexPath.row == 2) {
        AboutUsViewController *vc = AboutUsViewController.new;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}
@end
