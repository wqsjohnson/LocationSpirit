//
//  SearchViewController.m
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/1.
//

#import "SearchViewController.h"
#import "CommonConfig.h"

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *navigationBar;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.tableView];
}

- (UIView *)navigationBar {
    if (nil == _navigationBar) {
        _navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIDeviceScreenWidth, kNavigationBarHeight)];
        
        UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(kNavigationBarContentHeight, kStatusGAP, UIDeviceScreenWidth - kNavigationBarContentHeight * 2, kNavigationBarContentHeight)];
        [_navigationBar addSubview:searchTextField];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(UIDeviceScreenWidth - kNavigationBarContentHeight, kStatusGAP, kNavigationBarContentHeight, kNavigationBarContentHeight);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelButton setTitleColor:[UIColor blackColor]
                           forState:UIControlStateNormal];
        [cancelButton addTarget:self
                        action:@selector(cancelAction:)
              forControlEvents:UIControlEventTouchUpInside];
        [_navigationBar addSubview:cancelButton];
        
        _navigationBar.backgroundColor = [UIColor whiteColor];
    }
    return _navigationBar;
}

- (UITableView *)tableView {
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, UIDeviceScreenWidth, UIDeviceScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)cancelAction:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableViewDelegate, UITableViewDataSource;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = [NSString stringWithFormat:@"cellID_%@", NSStringFromClass([self class])];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
