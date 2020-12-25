//
//  AnnotionView.m
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/25.
//

#import "AnnotionView.h"
#import "Masonry.h"

@implementation AnnotionView
- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        [self _initUI];
    }
    return self;
}

- (void)_initUI {
    _locationImageView = UIImageView.new;
    _locationImageView.image = [UIImage imageNamed:@"friend_recommend_location"];
    [self addSubview:_locationImageView];
    [_locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    _titleLabel = UILabel.new;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(_locationImageView.mas_top).offset(5);
    }];
}
@end
