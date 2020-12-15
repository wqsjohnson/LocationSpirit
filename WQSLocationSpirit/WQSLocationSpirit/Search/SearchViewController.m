//
//  SearchViewController.m
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/1.
//

#import "SearchViewController.h"
#import "CommonConfig.h"

@interface SearchLocationCell : UITableViewCell
@property (nonatomic, strong) UIImageView *locationImageView;
@property (nonatomic, strong) UILabel *locationLabel;
@end

@implementation SearchLocationCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _initUI];
    }
    return self;
}

- (void)_initUI {
    self.locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
    self.locationImageView.image = [UIImage imageNamed:@"location_user_panel"];
    [self.contentView addSubview:self.locationImageView];
    
    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, UIDeviceScreenWidth - 100, 50)];
    self.locationLabel.font = [UIFont systemFontOfSize:13];
    self.locationLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.locationLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, UIDeviceScreenWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
}

@end
@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *navigationBar;
@property (nonatomic, strong) NSMutableArray *searchResults;
@end

@implementation SearchViewController
- (NSMutableArray *)searchResults {
    if (nil == _searchResults) {
        _searchResults = [NSMutableArray array];
    }
    return _searchResults;
}

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
        _navigationBar.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.6];
        
        UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(kNavigationBarContentHeight, kStatusGAP + (kNavigationBarContentHeight - 30) / 2.0, UIDeviceScreenWidth - kNavigationBarContentHeight * 2, 30)];
        searchView.userInteractionEnabled = YES;
        searchView.backgroundColor = [UIColor whiteColor];
        searchView.layer.cornerRadius = 15;
        searchView.layer.masksToBounds = YES;
        [_navigationBar addSubview:searchView];
        
        UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 15, 15)];
        searchImageView.image = [UIImage imageNamed:@"search"];
        [searchView addSubview:searchImageView];
        
        UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, searchView.frame.size.width - 50, 30)];
        searchTextField.placeholder = @"输入地名进行搜索";
        searchTextField.textColor = [UIColor blackColor];
        searchTextField.font = [UIFont systemFontOfSize:13];
        [searchView addSubview:searchTextField];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(UIDeviceScreenWidth - kNavigationBarContentHeight, kStatusGAP, kNavigationBarContentHeight, kNavigationBarContentHeight);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [cancelButton setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]
                           forState:UIControlStateNormal];
        [cancelButton addTarget:self
                        action:@selector(cancelAction:)
              forControlEvents:UIControlEventTouchUpInside];
        [_navigationBar addSubview:cancelButton];
    }
    return _navigationBar;
}

- (UITableView *)tableView {
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, UIDeviceScreenWidth, UIDeviceScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = [NSString stringWithFormat:@"cellID_%@", NSStringFromClass([self class])];
    SearchLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[SearchLocationCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:cellID];
    }
    cell.locationLabel.text = @"搜索定位位置";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectLocationComplete) {
        CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(39.9,116.4);
        self.selectLocationComplete(locationCoordinate);
    }
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}
@end