//
//  LocationCollectViewController.m
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/17.
//

#import "LocationCollectViewController.h"
#import "UIView+ActivityIndicatorView.h"
#import "CommonConfig.h"
#import "Masonry.h"

@interface LocationCollectCell : UITableViewCell
@property (nonatomic, strong) UIImageView *locationImageView;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *locationDetailLabel;
@end

@implementation LocationCollectCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _initUI];
    }
    return self;
}

- (void)_initUI {
    self.locationImageView = UIImageView.new;
    self.locationImageView.image = [UIImage imageNamed:@"location_user_panel"];
    [self.contentView addSubview:self.locationImageView];
    [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UIView *rightContentView = UIView.new;
    [self.contentView addSubview:rightContentView];
    [rightContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.left.mas_equalTo(self.locationImageView.mas_right).offset(15);
    }];
    
    self.locationLabel = UILabel.new;
    self.locationLabel.font = [UIFont systemFontOfSize:13];
    self.locationLabel.textColor = [UIColor lightGrayColor];
    [rightContentView addSubview:self.locationLabel];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(rightContentView);
    }];
    
    self.locationDetailLabel = UILabel.new;
    self.locationDetailLabel.font = [UIFont systemFontOfSize:13];
    self.locationDetailLabel.textColor = [UIColor lightGrayColor];
    [rightContentView addSubview:self.locationDetailLabel];
    [self.locationDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(rightContentView);
        make.top.mas_equalTo(self.locationLabel.mas_bottom).offset(5);
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

@interface LocationCollectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *collectDatas;
@end

@implementation LocationCollectViewController
- (NSMutableArray *)collectDatas {
    if (nil == _collectDatas) {
        _collectDatas = [NSMutableArray array];
    }
    return _collectDatas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initDatas];
    [self _initUI];
}

- (void)_initDatas {
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/collectDatas.plist"];
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:filePath];
    [self.collectDatas addObjectsFromArray:dataArr];
}

- (void)_initUI {
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIDeviceScreenWidth, kNavigationBarHeight)];
    navigationBar.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.6];
    [self.view addSubview:navigationBar];
    
    UILabel *titleLabel = UILabel.new;
    titleLabel.text = @"收藏";
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

- (void)backAcvtion:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDelegate, UITableViewDataSource;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.collectDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = [NSString stringWithFormat:@"cellID_%@", NSStringFromClass([self class])];
    LocationCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[LocationCollectCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellID];
    }
    
    NSDictionary *dic = [self.collectDatas objectAtIndex:indexPath.row];
    cell.locationLabel.text = [dic objectForKey:@"name"];
    cell.locationDetailLabel.text = [NSString stringWithFormat:@"经度:%@ 纬度:%@",[dic objectForKey:@"latitude"],[dic objectForKey:@"longitude"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [self.collectDatas objectAtIndex:indexPath.row];
    CLLocationDegrees latitude = [[dic objectForKey:@"latitude"] doubleValue];
    CLLocationDegrees longitude = [[dic objectForKey:@"longitude"] doubleValue];
    if (self.selectLocationComplete) {
        self.selectLocationComplete(CLLocationCoordinate2DMake(latitude, longitude));
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//多个自定义的按钮
- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name = [[self.collectDatas objectAtIndex:indexPath.row] objectForKey:@"name"];
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/collectDatas.plist"];
    __weak typeof(self) weakSelf = self;
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [weakSelf.view showActivityViewWithTitle:@"删除中..."];
        NSMutableArray *newDataArr = [NSMutableArray arrayWithArray:weakSelf.collectDatas];
        [newDataArr removeObjectAtIndex:indexPath.row];
        BOOL flag = [newDataArr writeToFile:filePath atomically:YES];
        if (flag) {
            [weakSelf.view hiddenActivityWithTitle:@"删除成功"];
            [weakSelf.collectDatas removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView reloadData];
        }
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    UIContextualAction *editAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"编辑" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        //提示框添加文本输入框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"编辑名称"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
            //得到文本信息
            UITextField *textField = alert.textFields[0];
            if (textField.text.length == 0) {
                [weakSelf.view promptMessage:@"请输入编辑后的名称"];
                return;
            }
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[weakSelf.collectDatas objectAtIndex:indexPath.row]];
            dic[@"name"] = textField.text;
            NSMutableArray *newDataArr = [NSMutableArray arrayWithArray:weakSelf.collectDatas];
            [newDataArr replaceObjectAtIndex:indexPath.row withObject:dic];
            [weakSelf.view showActivityViewWithTitle:@"修改中..."];
            BOOL flag = [newDataArr writeToFile:filePath atomically:YES];
            if (flag) {
                [weakSelf.view hiddenActivityWithTitle:@"修改成功"];
                [weakSelf.collectDatas replaceObjectAtIndex:indexPath.row withObject:dic];
                [weakSelf.tableView reloadData];
            }
        }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {
                                                                 //响应事件
                                                             }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"点击进行编辑";
            textField.text = name;
        }];

        [alert addAction:sureAction];
        [alert addAction:cancelAction];
        [weakSelf presentViewController:alert
                               animated:YES
                             completion:nil];
    }];
    editAction.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.6];
    
    UISwipeActionsConfiguration *swipeActionsConfiguration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction,editAction]];
    return swipeActionsConfiguration;
}

@end
